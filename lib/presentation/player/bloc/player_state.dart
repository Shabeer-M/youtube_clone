import 'package:equatable/equatable.dart';

enum PlayerStatus { initial, loading, ready, playing, paused, error }

class PlayerState extends Equatable {
  final PlayerStatus status;
  final bool isFullscreen;
  final double playbackSpeed;
  final String? errorMessage;

  const PlayerState({
    this.status = PlayerStatus.initial,
    this.isFullscreen = false,
    this.playbackSpeed = 1.0,
    this.errorMessage,
  });

  PlayerState copyWith({
    PlayerStatus? status,
    bool? isFullscreen,
    double? playbackSpeed,
    String? errorMessage,
  }) {
    return PlayerState(
      status: status ?? this.status,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isFullscreen,
    playbackSpeed,
    errorMessage,
  ];
}
