// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/screenshot_helper.dart';

Widget app(Widget home, {ThemeData? theme}) {
  return ChangeNotifierProvider(
    create: (_) => PhotosProvider(FakePhotoRepository())..loadCurated(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.lightTheme,
      home: home,
    ),
  );
}

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  final photos = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos;

  testWidgets(
    'day32_detail_light',
    (t) => screenshot(
      t,
      'day32_detail_light',
      app(PhotoDetailScreen(photo: photos[0])),
    ),
  );

  testWidgets(
    'day32_detail_dark',
    (t) => screenshot(
      t,
      'day32_detail_dark',
      app(PhotoDetailScreen(photo: photos[2]), theme: AppTheme.darkTheme),
    ),
  );

  testWidgets(
    'day32_hero_flight',
    (t) => screenshot(
      t,
      'day32_hero_flight',
      app(const HomeScreen()),
      settle: false,
      before: (t) async {
        await t.tap(find.byType(PhotoCard).first);
        await t.pump(); // start the route transition
        await t.pump(const Duration(milliseconds: 150)); // mid-flight
      },
    ),
  );
}
