import '../entities/video.dart';

abstract class SearchRepository {
  Future<List<Video>> searchVideos(String query);
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
}
