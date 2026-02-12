import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';

class PlayerControlsOverlay extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onSeekForward;
  final VoidCallback onSeekBackward;
  final ValueChanged<double> onVolumeChanged; // delta
  final ValueChanged<double> onBrightnessChanged; // delta
  final VoidCallback onTogglePiP;

  const PlayerControlsOverlay({
    super.key,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.onSeekForward,
    required this.onSeekBackward,
    required this.onVolumeChanged,
    required this.onBrightnessChanged,
    required this.onTogglePiP,
  });

  @override
  State<PlayerControlsOverlay> createState() => _PlayerControlsOverlayState();
}

class _PlayerControlsOverlayState extends State<PlayerControlsOverlay> {
  Timer? _hideTimer;

  @override
  void didUpdateWidget(covariant PlayerControlsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startHideTimer();
    } else if (!widget.isVisible) {
      _hideTimer?.cancel();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.isVisible) {
        widget.onToggleVisibility();
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        // We always need GestureDetector to catch taps to toggle visibility
        // even if not visible (invisible layer?).
        // Actually, if !isVisible, we return SizedBox.shrink() so no gestures.
        // User taps container in CustomVideoPlayer to toggle.

        if (!widget.isVisible) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            // Tapping the overlay itself should probably hide it or reset timer
            _startHideTimer();
          },
          onDoubleTapDown: (details) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (details.globalPosition.dx < screenWidth / 2) {
              widget.onSeekBackward();
            } else {
              widget.onSeekForward();
            }
            _startHideTimer();
          },
          onVerticalDragUpdate: (details) {
            final screenWidth = MediaQuery.of(context).size.width;
            final delta = details.primaryDelta! / -200; // Sensitivity
            if (details.globalPosition.dx < screenWidth / 2) {
              widget.onBrightnessChanged(delta);
            } else {
              widget.onVolumeChanged(delta);
            }
            _startHideTimer();
          },
          child: Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: Stack(
              children: [
                // PiP Button (Top Left)
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.picture_in_picture_alt,
                      color: Colors.white,
                    ),
                    onPressed: widget.onTogglePiP,
                  ),
                ),

                // Center Play/Pause Button
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.replay_10,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () {
                          widget.onSeekBackward();
                          _startHideTimer();
                        },
                      ),
                      IconButton(
                        iconSize: 64,
                        icon: Icon(
                          state.status == PlayerStatus.playing
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.read<PlayerBloc>().add(PlayPauseToggled());
                          _startHideTimer();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.forward_10,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () {
                          widget.onSeekForward();
                          _startHideTimer();
                        },
                      ),
                    ],
                  ),
                ),

                // Top Right: Settings & Fullscreen
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          _showSettingsModal(context, state.playbackSpeed);
                          _startHideTimer();
                        },
                      ),
                    ],
                  ),
                ),

                // Bottom: Progress Bar & Fullscreen
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Placeholder for Progress Bar
                      Expanded(
                        child: Container(
                          height: 4,
                          color: Colors.white.withValues(alpha: 0.3),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 100, // Dummy progress
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          state.isFullscreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.read<PlayerBloc>().add(ToggleFullscreen());
                          _startHideTimer();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSettingsModal(BuildContext context, double currentSpeed) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              'Playback Speed',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              '${currentSpeed}x',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.pop(ctx);
              _showSpeedSelector(context);
            },
          ),
          ListTile(
            title: const Text('Quality', style: TextStyle(color: Colors.white)),
            trailing: const Text('Auto', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Placeholder for quality selection
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showSpeedSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [0.5, 1.0, 1.5, 2.0]
            .map(
              (speed) => ListTile(
                title: Text(
                  '${speed}x',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  context.read<PlayerBloc>().add(PlaybackSpeedChanged(speed));
                  Navigator.pop(ctx);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
