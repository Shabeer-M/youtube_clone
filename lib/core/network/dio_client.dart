import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = AppConstants.apiBaseUrl
      ..options.connectTimeout = const Duration(
        milliseconds: AppConstants.connectTimeout,
      )
      ..options.receiveTimeout = const Duration(
        milliseconds: AppConstants.receiveTimeout,
      )
      ..options.responseType = ResponseType.json;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add Pexels API Key
          options.headers['Authorization'] = AppConstants.pexelsApiKey;

          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Log errors
          if (kDebugMode) {
            print(
              'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
            );
            print('Message: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Example convenience methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }
}
