import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  Future<SharedPreferencesWithCache> createPrefs() {
    return SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {PrefsBookmarksStorage.key},
      ),
    );
  }

  setUp(() {
    // No real device storage in tests: use the package's in-memory store.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('nothing saved yet reads as an empty list', () async {
    final storage = PrefsBookmarksStorage(await createPrefs());
    expect(storage.read(), isEmpty);
  });

  test('what is written can be read by a new instance', () async {
    await PrefsBookmarksStorage(await createPrefs()).write(['a', 'b']);

    final again = PrefsBookmarksStorage(await createPrefs());
    expect(again.read(), ['a', 'b']);
  });
}
