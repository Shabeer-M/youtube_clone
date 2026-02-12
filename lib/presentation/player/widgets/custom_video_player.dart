import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import 'player_controls_overlay.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Map<String, String> availableQualities;

  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
    this.availableQualities = const {},
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  BetterPlayerController? _betterPlayerController;
  bool _areControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
      resolutions: widget.availableQualities,
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 2000,
        maxBufferMs: 5000,
        bufferForPlaybackMs: 1000,
        bufferForPlaybackAfterRebufferMs: 2000,
      ),
      cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: false),
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        handleLifecycle: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false, // We use custom overlay
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    // Sync Bloc with Controller events if needed
    _betterPlayerController?.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        context.read<PlayerBloc>().add(PlayPauseToggled()); // Set to paused
      }
    });

    context.read<PlayerBloc>().add(InitializePlayer(widget.videoUrl));
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      listener: (context, state) {
        if (state.status == PlayerStatus.paused) {
          _betterPlayerController?.pause();
        } else if (state.status == PlayerStatus.playing) {
          _betterPlayerController?.play();
        }

        _betterPlayerController?.setSpeed(state.playbackSpeed);

        if (state.isFullscreen) {
          _betterPlayerController?.enterFullScreen();
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          _betterPlayerController?.exitFullScreen();
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
      },
      builder: (context, state) {
        if (_betterPlayerController == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _areControlsVisible = !_areControlsVisible;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              BetterPlayer(controller: _betterPlayerController!),
              PlayerControlsOverlay(
                isVisible: _areControlsVisible,
                onToggleVisibility: () {
                  setState(() {
                    _areControlsVisible = !_areControlsVisible;
                  });
                },
                onSeekForward: () {
                  final current = _betterPlayerController
                      ?.videoPlayerController
                      ?.value
                      .position;
                  if (current != null) {
                    _betterPlayerController?.seekTo(
                      current + const Duration(seconds: 10),
                    );
                  }
                },
                onSeekBackward: () {
                  final current = _betterPlayerController
                      ?.videoPlayerController
                      ?.value
                      .position;
                  if (current != null) {
                    _betterPlayerController?.seekTo(
                      current - const Duration(seconds: 10),
                    );
                  }
                },
                onVolumeChanged: (delta) async {
                  final current =
                      _betterPlayerController
                          ?.videoPlayerController
                          ?.value
                          .volume ??
                      1.0;
                  var newVol = (current + delta).clamp(0.0, 1.0);
                  _betterPlayerController?.setVolume(newVol);
                },
                onBrightnessChanged: (delta) {
                  // Placeholder for brightness since we don't have a package
                  // real implementation requires screen_brightness or similar
                  debugPrint('Brightness delta: $delta');
                },
                onTogglePiP: () {
                  _betterPlayerController?.enablePictureInPicture(GlobalKey());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
