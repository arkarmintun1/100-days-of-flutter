import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'helpers/fake_adapter.dart';

void main() {
  test('the repository is built from apiClientProvider', () async {
    final adapter = FakeAdapter(
      (_) => FakeAdapter.json(FakeAdapter.fixture('curated_page1')),
    );
    final dio = Dio(BaseOptions(baseUrl: ApiClient.baseUrl))
      ..httpClientAdapter = adapter;

    // Replace only the client: the real repository provider uses it.
    final container = ProviderContainer.test(
      overrides: [apiClientProvider.overrideWithValue(ApiClient(dio: dio))],
    );

    final result = await container.read(photoRepositoryProvider).curated();

    expect(result, isA<Success>());
    expect(adapter.requests.single.uri.path, '/v1/curated');
  });

  test('a provider is created once and then reused', () {
    final container = ProviderContainer.test(
      overrides: [apiClientProvider.overrideWithValue(ApiClient(apiKey: 'k'))],
    );

    expect(
      container.read(photoRepositoryProvider),
      same(container.read(photoRepositoryProvider)),
    );
  });

  test('every container has its own values', () {
    ProviderContainer create() => ProviderContainer.test(
      overrides: [apiClientProvider.overrideWithValue(ApiClient(apiKey: 'k'))],
    );

    expect(
      create().read(photoRepositoryProvider),
      isNot(same(create().read(photoRepositoryProvider))),
    );
  });

  test('without the main() override, shared preferences fail loudly', () {
    final container = ProviderContainer.test();

    expect(
      () => container.read(sharedPreferencesProvider),
      throwsA(isA<ProviderException>()),
    );
  });

  test('storage providers use the overridden shared preferences', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {PrefsBookmarksStorage.key},
      ),
    );
    final container = ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    await container.read(bookmarksStorageProvider).write(['a']);

    expect(prefs.getStringList(PrefsBookmarksStorage.key), ['a']);
  });
}
