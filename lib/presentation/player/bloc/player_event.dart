import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

class InitializePlayer extends PlayerEvent {
  final String videoUrl;

  const InitializePlayer(this.videoUrl);

  @override
  List<Object> get props => [videoUrl];
}

class PlayPauseToggled extends PlayerEvent {}

class SeekForward extends PlayerEvent {}

class SeekBackward extends PlayerEvent {}

class PlaybackSpeedChanged extends PlayerEvent {
  final double speed;

  const PlaybackSpeedChanged(this.speed);

  @override
  List<Object> get props => [speed];
}

class QualityChanged extends PlayerEvent {
  final String quality;

  const QualityChanged(this.quality);

  @override
  List<Object> get props => [quality];
}

class ToggleFullscreen extends PlayerEvent {}

class DisposePlayer extends PlayerEvent {}
