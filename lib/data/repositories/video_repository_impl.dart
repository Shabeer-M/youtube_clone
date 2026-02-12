import '../../../core/error/failure.dart';
import '../../../domain/repositories/video_repository.dart';
import '../datasources/remote/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Object?>> fetchVideos({
    required int page,
    required int limit,
  }) async {
    try {
      final videos = await remoteDataSource.fetchVideos(
        page: page,
        limit: limit,
      );
      return [null, videos];
    } on Failure catch (e) {
      return [e, null];
    } catch (e) {
      return [ServerFailure(e.toString()), null];
    }
  }

  @override
  Future<List<Object?>> getRelatedVideos(String videoId) async {
    // Placeholder implementation
    return [null, []];
  }

  @override
  Future<List<Object?>> getTrendingVideos() async {
    // Placeholder implementation: Re-using fetchVideos for now as an example
    return fetchVideos(page: 1, limit: 10);
  }

  @override
  Future<List<Object?>> getVideoDetails(String videoId) async {
    // Placeholder implementation
    return [const ServerFailure('Not implemented'), null];
  }

  @override
  Future<List<Object?>> searchVideos(String query) async {
    try {
      final videos = await remoteDataSource.searchVideos(
        query: query,
        page: 1,
        limit: 15, // Default limit for search
      );
      return [null, videos];
    } on Failure catch (e) {
      return [e, null];
    } catch (e) {
      return [ServerFailure(e.toString()), null];
    }
  }
}
