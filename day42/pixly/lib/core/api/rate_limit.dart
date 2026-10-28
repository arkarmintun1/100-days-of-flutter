import 'package:dio/dio.dart';

/// Pexels' monthly request quota, read from the headers of a successful
/// response. (Pexels only sends these headers on 2xx responses.)
class RateLimit {
  const RateLimit({
    required this.limit,
    required this.remaining,
    required this.resetsAt,
  });

  /// Requests allowed in the current monthly period.
  final int limit;

  /// Requests left in the current monthly period.
  final int remaining;

  /// When the monthly period rolls over.
  final DateTime resetsAt;

  /// null when the headers are missing (e.g. a failed request).
  static RateLimit? fromHeaders(Headers headers) {
    final limit = int.tryParse(headers.value('x-ratelimit-limit') ?? '');
    final remaining = int.tryParse(
      headers.value('x-ratelimit-remaining') ?? '',
    );
    final reset = int.tryParse(headers.value('x-ratelimit-reset') ?? '');
    if (limit == null || remaining == null || reset == null) return null;

    return RateLimit(
      limit: limit,
      remaining: remaining,
      // A UNIX timestamp: seconds since 1 January 1970 (UTC).
      resetsAt: DateTime.fromMillisecondsSinceEpoch(reset * 1000, isUtc: true),
    );
  }
}
