import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/repositories/photo_repository.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:pixly/storage/settings_storage.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/// The device storage. It is created (asynchronously) in main() before the
/// app starts and handed in with an override, so this body never runs.
final sharedPreferencesProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw UnimplementedError('Overridden in main()'),
);

/// One Dio-based client for the whole app.
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// Built from the client above. Tests can replace either one.
final photoRepositoryProvider = Provider<PhotoRepository>(
  (ref) => PhotoRepository(ref.watch(apiClientProvider)),
);

final bookmarksStorageProvider = Provider<BookmarksStorage>(
  (ref) => PrefsBookmarksStorage(ref.watch(sharedPreferencesProvider)),
);

final settingsStorageProvider = Provider<SettingsStorage>(
  (ref) => PrefsSettingsStorage(ref.watch(sharedPreferencesProvider)),
);

/// The SQLite database that Riverpod's offline persistence writes to.
/// One instance, shared by every persisted provider. Tests override it with
/// Storage.inMemory().
final storageProvider = FutureProvider<Storage<String, String>>((ref) async {
  final storage = await JsonSqFliteStorage.open(
    join(await getDatabasesPath(), 'pixly.db'),
  );
  ref.onDispose(storage.close);
  return storage;
});
