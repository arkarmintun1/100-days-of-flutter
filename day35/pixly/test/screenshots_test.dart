// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/bookmarks_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_bookmarks.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  final photos = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos;

  /// Bookmarks for the photos with these indexes (first = newest).
  Future<BookmarksProvider> bookmarked(List<int> indexes) async {
    final provider = BookmarksProvider(MemoryBookmarksStorage());
    for (final i in indexes.reversed) {
      await provider.toggle(photos[i]);
    }
    return provider;
  }

  testWidgets('day35_home_bookmark_icons', (t) async {
    final bookmarks = (await t.runAsync(() => bookmarked([1, 2])))!;
    await screenshot(
      t,
      'day35_home_bookmark_icons',
      testApp(bookmarks: bookmarks),
    );
  });

  testWidgets('day35_bookmarks_tab', (t) async {
    final bookmarks = (await t.runAsync(() => bookmarked([1, 2, 4, 7])))!;
    await screenshot(
      t,
      'day35_bookmarks_tab',
      testApp(
        bookmarks: bookmarks,
        router: createRouter(initialLocation: AppRoutes.bookmarks),
      ),
    );
  });

  testWidgets('day35_bookmarks_tab_dark', (t) async {
    final bookmarks = (await t.runAsync(() => bookmarked([1, 2, 4, 7])))!;
    await screenshot(
      t,
      'day35_bookmarks_tab_dark',
      testApp(
        bookmarks: bookmarks,
        theme: AppTheme.darkTheme,
        router: createRouter(initialLocation: AppRoutes.bookmarks),
      ),
    );
  });

  testWidgets('day35_detail_bookmarked', (t) async {
    final bookmarks = (await t.runAsync(() => bookmarked([1])))!;
    await screenshot(
      t,
      'day35_detail_bookmarked',
      testApp(
        bookmarks: bookmarks,
        router: createRouter(initialLocation: AppRoutes.photo(photos[1].id)),
      ),
    );
  });

  testWidgets(
    'day35_bookmarks_empty',
    (t) => screenshot(
      t,
      'day35_bookmarks_empty',
      testApp(router: createRouter(initialLocation: AppRoutes.bookmarks)),
    ),
  );
}
