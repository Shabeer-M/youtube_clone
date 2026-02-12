import '../../models/video_model.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> fetchVideos({required int page, required int limit});
  Future<List<VideoModel>> searchVideos({
    required String query,
    required int page,
    required int limit,
  });
}
