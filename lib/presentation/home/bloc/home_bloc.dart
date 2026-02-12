import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/video.dart';
import '../../../../domain/usecases/fetch_videos_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchVideosUseCase fetchVideosUseCase;

  int _page = 1;
  final int _limit = 10;
  bool _isFetching = false;

  HomeBloc({required this.fetchVideosUseCase}) : super(HomeInitial()) {
    on<FetchVideosRequested>(_onFetchVideosRequested);
    on<RefreshVideosRequested>(_onRefreshVideosRequested);
    on<LoadMoreVideosRequested>(_onLoadMoreVideosRequested);
  }

  Future<void> _onFetchVideosRequested(
    FetchVideosRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    _page = 1;

    final result = await fetchVideosUseCase(page: _page, limit: _limit);

    // result is [Failure?, List<Video>?] because of previous List<Object?> return type change
    final failure = result[0] as Failure?;
    final videos = result[1] as List<Video>?;

    if (failure != null) {
      emit(HomeError(failure.message));
    } else if (videos != null) {
      emit(HomeLoaded(videos: videos, hasReachedMax: videos.length < _limit));
    }
  }

  Future<void> _onRefreshVideosRequested(
    RefreshVideosRequested event,
    Emitter<HomeState> emit,
  ) async {
    _page = 1;
    final result = await fetchVideosUseCase(page: _page, limit: _limit);

    final failure = result[0] as Failure?;
    final videos = result[1] as List<Video>?;

    if (failure != null) {
      emit(HomeError(failure.message));
    } else if (videos != null) {
      emit(HomeLoaded(videos: videos, hasReachedMax: videos.length < _limit));
    }
  }

  Future<void> _onLoadMoreVideosRequested(
    LoadMoreVideosRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded ||
        currentState.hasReachedMax ||
        _isFetching) {
      return;
    }

    _isFetching = true;
    _page++;

    final result = await fetchVideosUseCase(page: _page, limit: _limit);

    final failure = result[0] as Failure?;
    final newVideos = result[1] as List<Video>?;

    if (failure != null) {
      // For load more error, we might want to keep the current list and show a snackbar (handled in UI)
      // or duplicate the error state. For simplicity, we keep current state but could emit an error event
      // However, emitting HomeError would replace the list.
      // A strict approach: emit HomeLoaded with an extra error field, or use a side-effect channel.
      // Here we just revert page and stop.
      _page--;
      _isFetching = false;
      return;
    } else if (newVideos != null) {
      if (newVideos.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        emit(
          currentState.copyWith(
            videos: currentState.videos + newVideos,
            hasReachedMax: newVideos.length < _limit,
          ),
        );
      }
    }
    _isFetching = false;
  }
}
