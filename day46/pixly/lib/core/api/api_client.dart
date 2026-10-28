import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pixly/config/env.dart';
import 'package:pixly/core/api/api_exception.dart';
import 'package:pixly/core/api/rate_limit.dart';
import 'package:pixly/core/api/rate_limit_interceptor.dart';

/// Thin wrapper around Dio configured for the Pexels API.
class ApiClient {
  ApiClient({Dio? dio, String? apiKey})
    : _dio = dio ?? Dio(_options(apiKey ?? Env.pexelsApiKey)) {
    // Interceptors run in the order they are added, for every request.
    _dio.interceptors.add(_rateLimit);
    if (dio == null && kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: false, // never print the API key
          responseHeader: false,
          responseBody: false,
        ),
      );
    }
  }

  static const String baseUrl = 'https://api.pexels.com/v1';

  final Dio _dio;
  final _rateLimit = RateLimitInterceptor();

  /// The quota from the last successful response, if Pexels sent one.
  RateLimit? get rateLimit => _rateLimit.latest;

  static BaseOptions _options(String apiKey) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Authorization': apiKey},
    );
  }

  /// GET [path] and return the decoded JSON object.
  ///
  /// Cancelling [cancelToken] stops the request; it then throws an
  /// [ApiException] with [ApiException.isCancelled] set.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
