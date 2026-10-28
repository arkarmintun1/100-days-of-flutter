import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pixly/config/env.dart';
import 'package:pixly/core/api/api_exception.dart';
import 'package:pixly/core/api/rate_limit.dart';

/// Thin wrapper around Dio configured for the Pexels API.
class ApiClient {
  ApiClient({Dio? dio, String? apiKey})
    : _dio = dio ?? Dio(_options(apiKey ?? Env.pexelsApiKey)) {
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

  RateLimit? _rateLimit;

  /// The quota from the last successful response, if Pexels sent one.
  RateLimit? get rateLimit => _rateLimit;

  static BaseOptions _options(String apiKey) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Authorization': apiKey},
    );
  }

  /// GET [path] and return the decoded JSON object.
  /// Throws [ApiException] when the request fails.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      _rateLimit = RateLimit.fromHeaders(response.headers) ?? _rateLimit;
      _warnIfQuotaLow();
      return response.data ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  void _warnIfQuotaLow() {
    final quota = _rateLimit;
    if (!kDebugMode || quota == null) return;
    if (quota.remaining < quota.limit / 10) {
      debugPrint(
        'Pexels: only ${quota.remaining} of ${quota.limit} requests left '
        'until ${quota.resetsAt.toLocal()}.',
      );
    }
  }
}
