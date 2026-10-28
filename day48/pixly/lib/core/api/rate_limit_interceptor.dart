import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pixly/core/api/rate_limit.dart';

/// Looks at every successful response and remembers Pexels' monthly quota.
class RateLimitInterceptor extends Interceptor {
  RateLimit? _latest;

  /// The quota from the last successful response, if Pexels sent one.
  RateLimit? get latest => _latest;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _latest = RateLimit.fromHeaders(response.headers) ?? _latest;
    _warnIfLow();
    // Pass the response on to the next interceptor (and then the caller).
    handler.next(response);
  }

  void _warnIfLow() {
    final quota = _latest;
    if (!kDebugMode || quota == null) return;
    if (quota.remaining < quota.limit / 10) {
      debugPrint(
        'Pexels: only ${quota.remaining} of ${quota.limit} requests left '
        'until ${quota.resetsAt.toLocal()}.',
      );
    }
  }
}
