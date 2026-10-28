import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/core/api/api_exception.dart';

import 'helpers/fake_adapter.dart';

void main() {
  ApiClient clientReturning(ResponseBody Function() response) {
    final dio = Dio(BaseOptions(baseUrl: ApiClient.baseUrl))
      ..httpClientAdapter = FakeAdapter((_) => response());
    return ApiClient(dio: dio);
  }

  test('reads the monthly quota from a successful response', () async {
    final client = clientReturning(
      () => FakeAdapter.json(
        {'photos': <Object>[]},
        headers: {
          'X-Ratelimit-Limit': '20000',
          'X-Ratelimit-Remaining': '19684',
          'X-Ratelimit-Reset': '1767225600',
        },
      ),
    );

    await client.get('/curated');

    final quota = client.rateLimit!;
    expect(quota.limit, 20000);
    expect(quota.remaining, 19684);
    expect(quota.resetsAt, DateTime.utc(2026, 1, 1));
  });

  test('no headers, no quota', () async {
    final client = clientReturning(() => FakeAdapter.json({'photos': []}));
    await client.get('/curated');
    expect(client.rateLimit, isNull);
  });

  test('a failed request keeps the last known quota', () async {
    var fail = false;
    final client = clientReturning(
      () => fail
          ? FakeAdapter.json({'error': 'x'}, status: 429)
          : FakeAdapter.json(
              {'photos': <Object>[]},
              headers: {
                'X-Ratelimit-Limit': '20000',
                'X-Ratelimit-Remaining': '5',
                'X-Ratelimit-Reset': '1767225600',
              },
            ),
    );

    await client.get('/curated');
    fail = true;
    await expectLater(client.get('/curated'), throwsA(isA<ApiException>()));

    expect(client.rateLimit!.remaining, 5);
  });
}
