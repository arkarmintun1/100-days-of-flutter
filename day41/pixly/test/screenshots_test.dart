// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/bookmarks_provider.dart';
import 'package:pixly/providers/theme_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_bookmarks.dart';
import 'helpers/memory_settings.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

/// The finished Pixly, for the Day 40 recap.
void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  final photos = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos;

  testWidgets('day40_home', (t) => screenshot(t, 'day40_home', testApp()));

  testWidgets(
    'day40_detail',
    (t) => screenshot(
      t,
      'day40_detail',
      testApp(
        router: createRouter(initialLocation: AppRoutes.photo(photos[2].id)),
      ),
    ),
  );

  testWidgets('day40_search', (t) async {
    await screenshot(
      t,
      'day40_search',
      testApp(router: createRouter(initialLocation: AppRoutes.search)),
      before: (t) async {
        await t.enterText(find.byType(TextField), 'nature');
        await t.testTextInput.receiveAction(TextInputAction.search);
        await t.pumpAndSettle();
        await precacheAllImages(t);
      },
    );
  });

  testWidgets('day40_bookmarks_dark', (t) async {
    final bookmarks = (await t.runAsync(() async {
      final provider = BookmarksProvider(MemoryBookmarksStorage());
      for (final i in [5, 3, 1]) {
        await provider.toggle(photos[i]);
      }
      return provider;
    }))!;
    await screenshot(
      t,
      'day40_bookmarks_dark',
      testApp(
        bookmarks: bookmarks,
        themeProvider: ThemeProvider(MemorySettingsStorage('dark')),
        router: createRouter(initialLocation: AppRoutes.bookmarks),
      ),
    );
  });
}
