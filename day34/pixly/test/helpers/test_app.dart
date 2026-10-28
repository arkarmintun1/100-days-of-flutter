import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/providers/search_provider.dart';
import 'package:pixly/repositories/photo_repository.dart';
import 'package:pixly/router/app_router.dart';
import 'package:provider/provider.dart';

import 'fake_repository.dart';

/// The whole app (router + providers) on top of a fake repository.
Widget testApp({
  FakePhotoRepository? repository,
  PhotosProvider? provider,
  SearchProvider? searchProvider,
  GoRouter? router,
  ThemeData? theme,
  bool loadOnStart = true,
}) {
  final repo = repository ?? FakePhotoRepository();
  return MultiProvider(
    providers: [
      Provider<PhotoRepository>.value(value: repo),
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
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.lightTheme,
      routerConfig: router ?? createRouter(),
    ),
  );
}
