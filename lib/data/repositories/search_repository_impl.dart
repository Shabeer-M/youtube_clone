import '../../domain/entities/video.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/local/search_history_local_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final VideoRepository videoRepository;
  final SearchHistoryLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.videoRepository,
    required this.localDataSource,
  });

  @override
  Future<List<Video>> searchVideos(String query) async {
    // Save query to history
    await localDataSource.saveSearchQuery(query);

    // Delegate search to VideoRepository
    // VideoRepository returns [Failure?, List<Video>?]
    final result = await videoRepository.searchVideos(query);

    if (result[0] != null) {
      throw result[0]!; // Throw Failure
    }

    return result[1] as List<Video>;
  }

  @override
  Future<List<String>> getSearchHistory() async {
    return await localDataSource.getSearchHistory();
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    await localDataSource.saveSearchQuery(query);
  }

  @override
  Future<void> clearSearchHistory() async {
    await localDataSource.clearHistory();
  }
}
