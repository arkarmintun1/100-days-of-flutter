// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/core/retry_policy.dart';
import 'package:pixly/models/photo_feed.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
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

  testWidgets(
    'day40_bookmarks_dark',
    (t) => screenshot(
      t,
      'day40_bookmarks_dark',
      testApp(
        bookmarks: MemoryBookmarksStorage.withPhotos([
          photos[1],
          photos[3],
          photos[5],
        ]),
        settings: MemorySettingsStorage('dark'),
        router: createRouter(initialLocation: AppRoutes.bookmarks),
      ),
    ),
  );

  // Day 47: the first page keeps failing, Riverpod is retrying.
  testWidgets(
    'day47_retrying',
    (t) => screenshot(
      t,
      'day47_retrying',
      testApp(
        retry: retryTransient,
        repository: FakePhotoRepository(
          onCurated: (_) async =>
              const Failure('Unable to connect.', kind: ErrorKind.network),
        ),
      ),
      settle: false,
    ),
  );

  // Day 48: offline, showing the photos saved last time.
  testWidgets('day48_stale', (t) async {
    final storage = Storage<String, String>.inMemory();
    final saved = PhotoFeed(photos: photos, page: 1, hasMore: true);
    storage.write(
      'curated_photos',
      jsonEncode(saved.toSavedJson()),
      const StorageOptions(),
    );
    await screenshot(
      t,
      'day48_stale',
      testApp(
        persisted: storage,
        repository: FakePhotoRepository(
          onCurated: (_) async =>
              const Failure('Unable to connect.', kind: ErrorKind.network),
        ),
      ),
    );
  });
}
