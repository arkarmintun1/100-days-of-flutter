import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/repositories/photo_repository.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:pixly/storage/settings_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
