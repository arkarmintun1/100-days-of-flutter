// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  final photo = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos[1];

  testWidgets(
    'day38_tablet_portrait',
    (t) => screenshot(
      t,
      'day38_tablet_portrait',
      testApp(),
      size: const Size(768, 1024),
      pixelRatio: 1,
    ),
  );

  testWidgets(
    'day38_desktop_home',
    (t) => screenshot(
      t,
      'day38_desktop_home',
      testApp(),
      size: const Size(1280, 800),
      pixelRatio: 1,
    ),
  );

  testWidgets(
    'day38_desktop_detail',
    (t) => screenshot(
      t,
      'day38_desktop_detail',
      testApp(router: createRouter(initialLocation: AppRoutes.photo(photo.id))),
      size: const Size(1280, 800),
      pixelRatio: 1,
    ),
  );
}
