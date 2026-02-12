part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class LoadSearchHistory extends SearchEvent {}

class ClearSearchHistory extends SearchEvent {}

class AddSearchHistoryItem extends SearchEvent {
  final String query;

  const AddSearchHistoryItem(this.query);

  @override
  List<Object> get props => [query];
}
