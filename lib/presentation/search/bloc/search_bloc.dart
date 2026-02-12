import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/video.dart';
import '../../../domain/repositories/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;

  SearchBloc({required SearchRepository repository})
    : _repository = repository,
      super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<ClearSearchHistory>(_onClearSearchHistory);
    on<AddSearchHistoryItem>(
      _onAddSearchHistoryItem,
    ); // Optional: if we want to add explicitly
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final history = await _repository.getSearchHistory();
      emit(SearchHistoryLoaded(history));
    } catch (e) {
      // If error loading history, just show empty or initial
      emit(const SearchHistoryLoaded([]));
    }
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    await _repository.clearSearchHistory();
    emit(const SearchHistoryLoaded([]));
  }

  Future<void> _onAddSearchHistoryItem(
    AddSearchHistoryItem event,
    Emitter<SearchState> emit,
  ) async {
    await _repository.saveSearchQuery(event.query);
    // Reload history
    add(LoadSearchHistory());
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadSearchHistory());
      return;
    }

    emit(SearchLoading());

    try {
      final result = await _repository.searchVideos(event.query);
      final failure =
          result[0]
              as Failure?; // Import Failure? No, it's Object? cast to Failure?
      // Check imports for Failure
      final videos = result[1] as List<Video>?;

      if (failure != null) {
        emit(SearchError(failure.message));
      } else if (videos != null) {
        if (videos.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchResultsLoaded(videos));
        }
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
