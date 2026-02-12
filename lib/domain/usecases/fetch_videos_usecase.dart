import '../repositories/video_repository.dart';

class FetchVideosUseCase {
  final VideoRepository repository;

  FetchVideosUseCase(this.repository);

  Future<List<Object?>> call({required int page, required int limit}) async {
    return repository.fetchVideos(page: page, limit: limit);
  }
}
