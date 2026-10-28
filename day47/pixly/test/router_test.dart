import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/screens/bookmarks_screen.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/screens/not_found_screen.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/screens/search_screen.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  // A phone, so the tabs are in the bottom navigation bar (Day 38).
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('the bottom navigation switches tabs', (tester) async {
    phone(tester);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen), findsOneWidget);

    await tester.tap(find.text('Bookmarks'));
    await tester.pumpAndSettle();
    expect(find.byType(BookmarksScreen), findsOneWidget);
  });

  testWidgets('each tab keeps its own stack', (tester) async {
    phone(tester);
    final router = createRouter();
    await tester.pumpWidget(testApp(router: router));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PhotoCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(PhotoDetailScreen), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // Still on the detail screen we left.
    expect(find.byType(PhotoDetailScreen), findsOneWidget);
    expect(router.state.uri.toString(), '/photo/1001');

    // Tapping the current tab again goes back to its first screen.
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(PhotoDetailScreen), findsNothing);
    expect(router.state.uri.toString(), '/');
  });

  testWidgets('a link to a photo that is not loaded fetches it by id', (
    tester,
  ) async {
    // Tall view so the credit under the portrait photo is built.
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = FakePhotoRepository();
    await tester.pumpWidget(
      testApp(
        repository: repo,
        router: createRouter(initialLocation: AppRoutes.photo(1003)),
      ),
    );
    await tester.pumpAndSettle();

    expect(repo.photoCalls, [1003]);
    expect(find.byType(PhotoDetailScreen), findsOneWidget);
    expect(find.textContaining('Photo by'), findsOneWidget);
  });

  testWidgets('going from one photo link to another loads the new photo', (
    tester,
  ) async {
    final repo = emptyFeedRepository();
    final router = createRouter(initialLocation: AppRoutes.photo(1001));
    await tester.pumpWidget(testApp(repository: repo, router: router));
    await tester.pumpAndSettle();

    router.go(AppRoutes.photo(1002));
    await tester.pumpAndSettle();

    expect(repo.photoCalls, [1001, 1002]);
    expect(router.state.uri.toString(), '/photo/1002');
  });

  testWidgets('an extra that is not a Photo falls back to loading by id', (
    tester,
  ) async {
    final repo = emptyFeedRepository();
    final router = createRouter();
    await tester.pumpWidget(testApp(repository: repo, router: router));
    await tester.pumpAndSettle();

    // What a restored browser history entry looks like: a decoded map.
    router.go(AppRoutes.photo(1003), extra: {'id': 1003});
    await tester.pumpAndSettle();

    expect(repo.photoCalls, [1003]);
    expect(find.byType(PhotoDetailScreen), findsOneWidget);
  });

  testWidgets('a photo that cannot be loaded shows a message', (tester) async {
    final repo = FakePhotoRepository(
      onPhoto: (_) async =>
          const Failure('Photo not found.', kind: ErrorKind.notFound),
    );
    await tester.pumpWidget(
      testApp(
        repository: repo,
        router: createRouter(initialLocation: AppRoutes.photo(42)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Not found'), findsOneWidget);
    expect(find.text('Photo not found.'), findsOneWidget);
    // Asking again won't bring a missing photo back.
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('a photo that failed to load can be retried', (tester) async {
    var fail = true;
    final repo = FakePhotoRepository(
      onPhoto: (id) async => fail
          ? const Failure('No internet', kind: ErrorKind.network)
          : Success(
              PhotosPage.fromJson(
                FakeAdapter.fixture('curated_page1'),
              ).photos.first,
            ),
    );
    await tester.pumpWidget(
      testApp(
        repository: repo,
        router: createRouter(initialLocation: AppRoutes.photo(42)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No connection'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(repo.photoCalls, [42, 42]);
    expect(find.byType(PhotoDetailScreen), findsOneWidget);
  });

  testWidgets('unknown and malformed links show the not-found page', (
    tester,
  ) async {
    for (final location in ['/nope', '/photo/abc']) {
      await tester.pumpWidget(
        KeyedSubtree(
          key: ValueKey(location), // a fresh app for each link
          child: testApp(router: createRouter(initialLocation: location)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NotFoundScreen), findsOneWidget, reason: location);
    }

    await tester.tap(find.text('Go home'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

/// Home's feed is empty, so the photo can't come from the loaded feed and
/// has to be fetched by id.
FakePhotoRepository emptyFeedRepository() => FakePhotoRepository(
  onCurated: (page) async =>
      Success(PhotosPage(page: page, perPage: 12, photos: const [])),
);
