// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/screenshot_helper.dart';

Widget app(FakePhotoRepository repo, {ThemeData? theme}) {
  return ChangeNotifierProvider(
    create: (_) => PhotosProvider(repo)..loadCurated(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.lightTheme,
      home: const HomeScreen(),
    ),
  );
}

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  testWidgets(
    'day30_shimmer',
    (t) => screenshot(
      t,
      'day30_shimmer',
      app(FakePhotoRepository(onCurated: (_) => FakePhotoRepository.never())),
      settle: false,
    ),
  );

  testWidgets(
    'day30_grid_light',
    (t) => screenshot(t, 'day30_grid_light', app(FakePhotoRepository())),
  );

  testWidgets(
    'day30_grid_dark',
    (t) => screenshot(
      t,
      'day30_grid_dark',
      app(FakePhotoRepository(), theme: AppTheme.darkTheme),
    ),
  );
}
