import 'package:dio/dio.dart';

/// A readable error the UI can show, created from a [DioException].
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    return switch (e.type) {
      .connectionTimeout || .sendTimeout || .receiveTimeout =>
        const ApiException('The connection timed out. Please try again.'),
      .connectionError => const ApiException(
        'Unable to connect. Check your network and try again.',
      ),
      .cancel => const ApiException('The request was cancelled.'),
      .badResponse => switch (status) {
        401 => ApiException(
          'Invalid API key. Check PEXELS_API_KEY in your .env file.',
          statusCode: status,
        ),
        429 => ApiException(
          'Too many requests. Please wait a moment and try again.',
          statusCode: status,
        ),
        _ => ApiException('Server error ($status).', statusCode: status),
      },
      _ => const ApiException('Something went wrong. Please try again.'),
    };
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
