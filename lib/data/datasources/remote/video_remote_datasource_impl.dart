import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/video_model.dart';
import 'video_remote_datasource.dart';

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final DioClient _dioClient;

  VideoRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<VideoModel>> fetchVideos({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dioClient.get(
        '/popular',
        queryParameters: {'page': page, 'per_page': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['videos'];
        return data.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('Failed to fetch videos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<VideoModel>> searchVideos({
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dioClient.get(
        '/search',
        queryParameters: {'query': query, 'page': page, 'per_page': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['videos'];
        return data.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('Failed to search videos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
