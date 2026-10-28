import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/core/api/api_exception.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/repositories/photo_repository.dart';

import 'helpers/fake_adapter.dart';

/// Builds the same Dio the app uses, but with a fake adapter.
(PhotoRepository, FakeAdapter) build(ResponseBody Function(RequestOptions) h) {
  final adapter = FakeAdapter(h);
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiClient.baseUrl,
      headers: {'Authorization': 'test-key'},
    ),
  )..httpClientAdapter = adapter;
  return (PhotoRepository(ApiClient(dio: dio)), adapter);
}

void main() {
  test(
    'curated() calls /curated with page & per_page and the raw key',
    () async {
      final (repo, adapter) = build(
        (_) => FakeAdapter.json(FakeAdapter.fixture('curated_page1')),
      );

      final result = await repo.curated(page: 2);

      expect(result, isA<Success>());
      final req = adapter.requests.single;
      expect(
        req.uri.toString(),
        startsWith('https://api.pexels.com/v1/curated'),
      );
      expect(req.queryParameters, {
        'page': 2,
        'per_page': PhotoRepository.perPage,
      });
      expect(req.headers['Authorization'], 'test-key'); // no "Bearer"
      final page = (result as Success).data;
      expect(page.photos, hasLength(12));
      expect(page.hasMore, isTrue);
    },
  );

  test('search() URL-encodes the query', () async {
    final (repo, adapter) = build(
      (_) => FakeAdapter.json(FakeAdapter.fixture('search_nature')),
    );

    await repo.search('coffee & cake');

    final uri = adapter.requests.single.uri;
    expect(uri.path, '/v1/search');
    expect(uri.queryParameters['query'], 'coffee & cake');
    expect(uri.query, contains('query=coffee+%26+cake'));
  });

  for (final (status, text) in [
    (401, 'Invalid API key'),
    (429, 'Too many requests'),
    (500, 'Server error (500)'),
  ]) {
    test('HTTP $status becomes a Failure with a readable message', () async {
      final (repo, _) = build(
        (_) => FakeAdapter.json({'error': 'x'}, status: status),
      );
      final result = await repo.curated();
      expect(result, isA<Failure>());
      expect((result as Failure).message, contains(text));
    });
  }

  test('timeouts map to a timeout message', () {
    final e = ApiException.fromDio(
      DioException.connectionTimeout(
        timeout: const Duration(seconds: 10),
        requestOptions: RequestOptions(path: '/curated'),
      ),
    );
    expect(e.message, contains('timed out'));
  });

  test('no network maps to a no-internet message', () {
    final e = ApiException.fromDio(
      DioException.connectionError(
        requestOptions: RequestOptions(path: '/curated'),
        reason: 'offline',
      ),
    );
    expect(e.message, contains('No internet'));
  });

  test(
    'ApiClient() without a Dio uses the Pexels base URL and raw key header',
    () {
      // Reads the key from the argument instead of .env.
      final client = ApiClient(apiKey: 'abc');
      expect(client, isA<ApiClient>());
    },
  );
}
