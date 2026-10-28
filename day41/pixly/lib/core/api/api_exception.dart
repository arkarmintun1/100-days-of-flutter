import 'package:dio/dio.dart';
import 'package:pixly/core/error_kind.dart';

/// A readable error the UI can show, created from a [DioException].
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.kind = ErrorKind.unknown,
  });

  final String message;
  final int? statusCode;
  final ErrorKind kind;

  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    return switch (e.type) {
      .connectionTimeout ||
      .sendTimeout ||
      .receiveTimeout => const ApiException(
        'The connection timed out. Please try again.',
        kind: .network,
      ),
      .connectionError => const ApiException(
        'Unable to connect. Check your network and try again.',
        kind: .network,
      ),
      .cancel => const ApiException('The request was cancelled.'),
      .badResponse => switch (status) {
        401 => ApiException(
          'Invalid API key. Check PEXELS_API_KEY in your .env file.',
          statusCode: status,
          kind: .unauthorized,
        ),
        404 => ApiException(
          "Pexels couldn't find it. It may have been removed.",
          statusCode: status,
          kind: .notFound,
        ),
        429 => ApiException(
          'Too many requests to Pexels for now. '
          'Please wait a while and try again.',
          statusCode: status,
          kind: .rateLimited,
        ),
        // 5xx: a problem on Pexels' side that may go away.
        final int code when code >= 500 => ApiException(
          'Server error ($code).',
          statusCode: code,
          kind: .server,
        ),
        // Any other status (e.g. 400, 403).
        _ => ApiException('Request failed ($status).', statusCode: status),
      },
      _ => const ApiException('Something went wrong. Please try again.'),
    };
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
