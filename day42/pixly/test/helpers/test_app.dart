import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/main.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/providers/search_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:pixly/storage/settings_storage.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

import 'fake_repository.dart';
import 'memory_bookmarks.dart';
import 'memory_settings.dart';

/// Riverpod overrides that keep bookmarks and settings in memory.
List<Override> storageOverrides({
  BookmarksStorage? bookmarks,
  SettingsStorage? settings,
}) => [
  bookmarksStorageProvider.overrideWithValue(
    bookmarks ?? MemoryBookmarksStorage(),
  ),
  settingsStorageProvider.overrideWithValue(
    settings ?? MemorySettingsStorage(),
  ),
];

/// For tests that pump a single screen: a ProviderScope with in-memory
/// storage above [child].
Widget withFakeStorage(
  Widget child, {
  BookmarksStorage? bookmarks,
  SettingsStorage? settings,
}) {
  return ProviderScope(
    overrides: storageOverrides(bookmarks: bookmarks, settings: settings),
    child: child,
  );
}

/// The Riverpod container of the app under test (to read providers).
ProviderContainer containerOf(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(MaterialApp).first));

/// The whole app (router + providers) on top of a fake repository.
Widget testApp({
  FakePhotoRepository? repository,
  PhotosProvider? provider,
  SearchProvider? searchProvider,
  BookmarksStorage? bookmarks,
  SettingsStorage? settings,
  GoRouter? router,
  bool loadOnStart = true,
}) {
  final repo = repository ?? FakePhotoRepository();
  // Riverpod: hand the fakes to everything that reads these providers.
  return ProviderScope(
    overrides: [
      photoRepositoryProvider.overrideWithValue(repo),
      ...storageOverrides(bookmarks: bookmarks, settings: settings),
    ],
    child: MultiProvider(
      providers: [
        if (provider != null)
          ChangeNotifierProvider.value(value: provider)
        else
          ChangeNotifierProvider(
            create: (_) {
              final p = PhotosProvider(repo);
              if (loadOnStart) p.loadCurated();
              return p;
            },
          ),
        if (searchProvider != null)
          ChangeNotifierProvider.value(value: searchProvider)
        else
          ChangeNotifierProvider(create: (_) => SearchProvider(repo)),
      ],
      // The real app widget, so the theme wiring is tested too.
      child: PixlyApp(router: router ?? createRouter()),
    ),
  );
}
