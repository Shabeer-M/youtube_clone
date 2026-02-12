import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Duration current;
  final Duration total;
  final ValueChanged<Duration> onSeek;

  const ProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            trackHeight: 2,
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
            thumbColor: Colors.red,
          ),
          child: Slider(
            value: current.inSeconds.toDouble().clamp(
              0.0,
              total.inSeconds.toDouble(),
            ),
            min: 0.0,
            max: total.inSeconds.toDouble(),
            onChanged: (value) {
              onSeek(Duration(seconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(current),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                _formatDuration(total),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
