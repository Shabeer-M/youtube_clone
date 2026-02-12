abstract class VideoRepository {
  Future<List<Object?>> fetchVideos({
    required int page,
    required int limit,
  }); // [Failure?, List<Video>?]
  Future<List<Object?>> getTrendingVideos(); // [Failure?, List<Video>?]
  Future<List<Object?>> searchVideos(String query);
  Future<List<Object?>> getVideoDetails(String videoId);
  Future<List<Object?>> getRelatedVideos(String videoId);
}
