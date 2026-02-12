import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchVideosRequested extends HomeEvent {}

class RefreshVideosRequested extends HomeEvent {}

class LoadMoreVideosRequested extends HomeEvent {}
