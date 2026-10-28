import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:pixly/storage/settings_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  // The same allowList as main.dart.
  Future<SharedPreferencesWithCache> createPrefs() {
    return SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {
          PrefsBookmarksStorage.key,
          PrefsSettingsStorage.themeModeKey,
        },
      ),
    );
  }

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('nothing saved yet reads as null', () async {
    final storage = PrefsSettingsStorage(await createPrefs());
    expect(storage.readThemeMode(), isNull);
  });

  test('what is written can be read by a new instance', () async {
    await PrefsSettingsStorage(await createPrefs()).writeThemeMode('dark');

    final again = PrefsSettingsStorage(await createPrefs());
    expect(again.readThemeMode(), 'dark');
  });
}
