import 'package:flutter_bloc/flutter_bloc.dart';
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(const PlayerState()) {
    on<InitializePlayer>(_onInitializePlayer);
    on<PlayPauseToggled>(_onPlayPauseToggled);
    on<PlaybackSpeedChanged>(_onPlaybackSpeedChanged);
    on<ToggleFullscreen>(_onToggleFullscreen);
    on<DisposePlayer>(_onDisposePlayer);
  }

  void _onInitializePlayer(InitializePlayer event, Emitter<PlayerState> emit) {
    emit(state.copyWith(status: PlayerStatus.loading));
    // Simulating initialization completion, actual player setup happens in UI/Controller
    emit(state.copyWith(status: PlayerStatus.ready));
  }

  void _onPlayPauseToggled(PlayPauseToggled event, Emitter<PlayerState> emit) {
    if (state.status == PlayerStatus.playing) {
      emit(state.copyWith(status: PlayerStatus.paused));
    } else {
      emit(state.copyWith(status: PlayerStatus.playing));
    }
  }

  void _onPlaybackSpeedChanged(
    PlaybackSpeedChanged event,
    Emitter<PlayerState> emit,
  ) {
    emit(state.copyWith(playbackSpeed: event.speed));
  }

  void _onToggleFullscreen(ToggleFullscreen event, Emitter<PlayerState> emit) {
    emit(state.copyWith(isFullscreen: !state.isFullscreen));
  }

  void _onDisposePlayer(DisposePlayer event, Emitter<PlayerState> emit) {
    emit(const PlayerState(status: PlayerStatus.initial));
  }
}
