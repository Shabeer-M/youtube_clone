import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF98888), Color(0xFFF65B5B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Wave Pattern (simplified with CustomPainter)
          CustomPaint(size: Size.infinite, painter: WavePainter()),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ideally use an SVG logo or icon here
                      const Icon(
                        Icons.play_circle_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Watch your favorite videos anytime, anywhere.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Sheet look
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), // Curve
                    topRight: Radius.circular(0), // Keep sharp to match design
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Allow button to overflow
                  children: [
                    // White Curve overlay to match design specifically
                    Positioned(
                      top: -40,
                      left: 0,
                      right: 0,
                      height: 50,
                      child: CustomPaint(painter: CurveHeaderPainter()),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Discover endless entertainment and knowledge.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF65B5B),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFF65B5B,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

    // Draw pattern lines similar to the design
    // This is a simplified version
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

    // More circles/waves
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
    // Start from bottom left
    path.moveTo(0, size.height);
    // Line to top left (start of curve)
    path.lineTo(0, size.height);
    // Bezier curve to create the wave effect
    // This needs to match the top-left radius of the container essentially extending it
    // Actually the container handles the main shape, this is just to add a 'swoosh' if needed.
    // Given the design, a simple Container with proper borderRadius is usually enough,
    // but the reference shows a specific organic curve.

    // Let's make a wave that goes up and then connects
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
