part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchHistoryLoaded extends SearchState {
  final List<String> history;

  const SearchHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class SearchResultsLoaded extends SearchState {
  final List<Video> videos;

  const SearchResultsLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
