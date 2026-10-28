import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/core/api/api_exception.dart';
import 'package:pixly/core/api/rate_limit_interceptor.dart';

import 'helpers/fake_adapter.dart';

/// An adapter whose responses only arrive when the test says so.
class SlowAdapter implements HttpClientAdapter {
  final response = Completer<ResponseBody>();

  /// Completes when Dio hands the request to the adapter ("sent").
  final started = Completer<void>();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    started.complete();
    return response.future;
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  ApiClient clientWith(HttpClientAdapter adapter) => ApiClient(
    dio: Dio(BaseOptions(baseUrl: ApiClient.baseUrl))
      ..httpClientAdapter = adapter,
  );

  test('the rate limit interceptor is added to every client', () {
    final dio = Dio();
    ApiClient(dio: dio);
    expect(dio.interceptors.whereType<RateLimitInterceptor>(), hasLength(1));
  });

  test('a cancelled token stops the request before it is sent', () async {
    final adapter = FakeAdapter((_) => FakeAdapter.json({'photos': []}));
    final client = clientWith(adapter);
    final token = CancelToken()..cancel();

    await expectLater(
      client.get('/search', cancelToken: token),
      throwsA(
        isA<ApiException>().having((e) => e.isCancelled, 'isCancelled', isTrue),
      ),
    );
    expect(adapter.requests, isEmpty);
  });

  test('cancelling while waiting ends the request', () async {
    final adapter = SlowAdapter();
    final client = clientWith(adapter);
    final token = CancelToken();

    final request = client.get('/search', cancelToken: token);
    await adapter.started.future; // the request is on its way
    token.cancel();

    await expectLater(
      request,
      throwsA(
        isA<ApiException>().having((e) => e.isCancelled, 'isCancelled', isTrue),
      ),
    );
  });
}
