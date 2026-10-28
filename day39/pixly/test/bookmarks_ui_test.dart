import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/bookmarks_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/screens/bookmarks_screen.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/widgets/bookmark_button.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_bookmarks.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('bookmarking a card shows it in the Bookmarks tab', (
    tester,
  ) async {
    phone(tester);
    final bookmarks = BookmarksProvider(MemoryBookmarksStorage());
    await tester.pumpWidget(testApp(bookmarks: bookmarks));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Bookmark').first);
    await tester.pumpAndSettle();
    expect(bookmarks.photos, hasLength(1));
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);

    await tester.tap(find.text('Bookmarks'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(BookmarksScreen),
        matching: find.byType(PhotoCard),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping the card itself still opens the detail', (tester) async {
    phone(tester);
    final bookmarks = BookmarksProvider(MemoryBookmarksStorage());
    await tester.pumpWidget(testApp(bookmarks: bookmarks));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PhotoCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(PhotoDetailScreen), findsOneWidget);
    expect(bookmarks.photos, isEmpty); // the bookmark wasn't toggled
  });

  testWidgets('the detail screen can bookmark the photo too', (tester) async {
    phone(tester);
    final bookmarks = BookmarksProvider(MemoryBookmarksStorage());
    await tester.pumpWidget(
      testApp(
        bookmarks: bookmarks,
        router: createRouter(initialLocation: AppRoutes.photo(1002)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(BookmarkButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(bookmarks.photos.single.id, 1002);
  });

  testWidgets('a bookmarked photo opens inside the Bookmarks tab', (
    tester,
  ) async {
    phone(tester);
    final bookmarks = BookmarksProvider(MemoryBookmarksStorage());
    final router = createRouter(initialLocation: AppRoutes.bookmarks);
    await tester.pumpWidget(testApp(bookmarks: bookmarks, router: router));
    await tester.pumpAndSettle();
    expect(find.text('No bookmarks yet'), findsOneWidget);

    // Bookmark from Home, then come back.
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Bookmark').first);
    await tester.tap(find.text('Bookmarks'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(BookmarksScreen),
        matching: find.byType(PhotoCard),
      ),
    );
    await tester.pumpAndSettle();

    expect(router.state.uri.toString(), AppRoutes.bookmarkPhoto(1001));
    expect(find.byType(PhotoDetailScreen), findsOneWidget);
  });

  testWidgets('a bookmark that cannot be saved shows a message', (
    tester,
  ) async {
    phone(tester);
    final storage = MemoryBookmarksStorage()..failWrites = true;
    final bookmarks = BookmarksProvider(storage);
    await tester.pumpWidget(testApp(bookmarks: bookmarks));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Bookmark').first);
    await tester.pumpAndSettle();

    expect(find.textContaining("Couldn't save your bookmarks"), findsOneWidget);
    // The bookmark still shows; the next successful save will store it.
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);
  });

  testWidgets('removing a bookmark on the Bookmarks tab removes the card', (
    tester,
  ) async {
    phone(tester);
    final photo = PhotosPage.fromJson(
      FakeAdapter.fixture('curated_page1'),
    ).photos.first;
    final bookmarks = BookmarksProvider(MemoryBookmarksStorage());
    await bookmarks.toggle(photo);
    await tester.pumpWidget(
      testApp(
        bookmarks: bookmarks,
        router: createRouter(initialLocation: AppRoutes.bookmarks),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PhotoCard), findsOneWidget);

    // The button is removed with its card while it is still saving.
    await tester.tap(find.byTooltip('Remove bookmark'));
    await tester.pumpAndSettle();

    expect(find.text('No bookmarks yet'), findsOneWidget);
    expect(bookmarks.photos, isEmpty);
  });
}
