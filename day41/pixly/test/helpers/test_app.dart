import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/main.dart';
import 'package:pixly/providers/bookmarks_provider.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/providers/search_provider.dart';
import 'package:pixly/providers/theme_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

import 'fake_repository.dart';
import 'memory_bookmarks.dart';
import 'memory_settings.dart';

/// The whole app (router + providers) on top of a fake repository.
Widget testApp({
  FakePhotoRepository? repository,
  PhotosProvider? provider,
  SearchProvider? searchProvider,
  BookmarksProvider? bookmarks,
  GoRouter? router,
  ThemeProvider? themeProvider,
  bool loadOnStart = true,
}) {
  final repo = repository ?? FakePhotoRepository();
  // Riverpod: hand the fake repository to everything that reads
  // photoRepositoryProvider.
  return ProviderScope(
    overrides: [photoRepositoryProvider.overrideWithValue(repo)],
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
        ChangeNotifierProvider.value(
          value: bookmarks ?? BookmarksProvider(MemoryBookmarksStorage()),
        ),
        ChangeNotifierProvider.value(
          value: themeProvider ?? ThemeProvider(MemorySettingsStorage()),
        ),
      ],
      // The real app widget, so the theme wiring is tested too.
      child: PixlyApp(router: router ?? createRouter()),
    ),
  );
}
