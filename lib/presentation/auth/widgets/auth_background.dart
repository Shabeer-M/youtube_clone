import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final double headerHeight;

  const AuthBackground({
    super.key,
    required this.child,
    this.headerHeight = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Handle inside SingleChildScrollView
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF98888), Color(0xFFF65B5B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Wave Pattern
          CustomPaint(size: Size.infinite, painter: WavePainter()),

          // Foreground Content (White Sheet)
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * headerHeight,
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Curve connector
                    Positioned(
                      top: -49,
                      left: 0,
                      right: 0,
                      height: 50,
                      child: CustomPaint(painter: CurveHeaderPainter()),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          // We rely on the CustomPaint for the top curve visual
                          // But we need this for the solid background
                        ),
                      ),
                      child: child,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    var path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width,
      size.height * 0.3,
    );
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width,
      size.height * 0.4,
    );
    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 50, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.5), 80, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CurveHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();
    // This creates a wave that goes:
    // Start bottom left
    path.moveTo(0, size.height);
    // Curve up to top right area
    // Control point at (0.25w, 0)
    // End point at (w, 0.6h) -> Actually let's make it simpler
    // to ensure it covers the gap without being too complex

    // We want a shape that is WHITE and sits ON TOP of the pink implementation
    // But since this is inside the stack of the white container, it sits ON TOP of the pink background (visually)

    path.lineTo(0, size.height); // Bottom Left (50)
    path.moveTo(0, size.height);

    // Cubic Bezier for smoother wave
    path.cubicTo(
      size.width * 0.2,
      0, // Control 1
      size.width * 0.5,
      size.height * 0.8, // Control 2
      size.width,
      size.height * 0.4, // End
    );

    // Close the shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
