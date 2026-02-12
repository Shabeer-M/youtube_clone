import 'package:equatable/equatable.dart';
import '../../../domain/entities/video.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Video> videos;
  final bool hasReachedMax;

  const HomeLoaded({required this.videos, this.hasReachedMax = false});

  @override
  List<Object> get props => [videos, hasReachedMax];

  HomeLoaded copyWith({List<Video>? videos, bool? hasReachedMax}) {
    return HomeLoaded(
      videos: videos ?? this.videos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
