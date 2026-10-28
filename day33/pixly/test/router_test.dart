import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/screens/bookmarks_screen.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/screens/not_found_screen.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/screens/search_screen.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  testWidgets('the bottom navigation switches tabs', (tester) async {
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
        loadOnStart: false,
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
    final repo = FakePhotoRepository();
    final router = createRouter(initialLocation: AppRoutes.photo(1001));
    await tester.pumpWidget(
      testApp(repository: repo, loadOnStart: false, router: router),
    );
    await tester.pumpAndSettle();

    router.go(AppRoutes.photo(1002));
    await tester.pumpAndSettle();

    expect(repo.photoCalls, [1001, 1002]);
    expect(router.state.uri.toString(), '/photo/1002');
  });

  testWidgets('an extra that is not a Photo falls back to loading by id', (
    tester,
  ) async {
    final repo = FakePhotoRepository();
    final router = createRouter();
    await tester.pumpWidget(
      testApp(repository: repo, loadOnStart: false, router: router),
    );
    await tester.pumpAndSettle();

    // What a restored browser history entry looks like: a decoded map.
    router.go(AppRoutes.photo(1003), extra: {'id': 1003});
    await tester.pumpAndSettle();

    expect(repo.photoCalls, [1003]);
    expect(find.byType(PhotoDetailScreen), findsOneWidget);
  });

  testWidgets('a photo that cannot be loaded shows a message', (tester) async {
    final repo = FakePhotoRepository(
      onPhoto: (_) async => const Failure('Photo not found.'),
    );
    await tester.pumpWidget(
      testApp(
        repository: repo,
        loadOnStart: false,
        router: createRouter(initialLocation: AppRoutes.photo(42)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Photo not available'), findsOneWidget);
    expect(find.text('Photo not found.'), findsOneWidget);
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
