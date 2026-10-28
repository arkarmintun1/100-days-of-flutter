import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_bookmarks.dart';
import 'helpers/fake_repository.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  Future<PhotosProvider> pumpHome(
    WidgetTester tester,
    FakePhotoRepository repo,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final provider = PhotosProvider(repo);
    await tester.pumpWidget(
      withBookmarks(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      ),
    );
    await provider.loadCurated();
    await tester.pumpAndSettle();
    return provider;
  }

  Future<Result<PhotosPage>> pages(int page) async => page == 1
      ? FakePhotoRepository.fixturePage('curated_page1')
      : FakePhotoRepository.fixturePage('curated_page2');

  testWidgets('scrolling near the end loads the next page', (tester) async {
    final repo = FakePhotoRepository(onCurated: pages);
    final provider = await pumpHome(tester, repo);

    await tester.drag(find.byType(GridView), const Offset(0, -2000));
    await tester.pumpAndSettle();

    expect(repo.curatedCalls, [1, 2]);
    expect(provider.photos, hasLength(24));
  });

  testWidgets('a first page that does not fill the screen loads page 2', (
    tester,
  ) async {
    final repo = FakePhotoRepository(onCurated: pages);
    tester.view.physicalSize = const Size(390, 2400); // a very tall screen
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final provider = PhotosProvider(repo);
    await tester.pumpWidget(
      withBookmarks(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      ),
    );
    await provider.loadCurated();
    await tester.pumpAndSettle();

    // No scrolling happened, but the grid noticed it wasn't full.
    expect(repo.curatedCalls, [1, 2]);
    expect(provider.photos, hasLength(24));
  });

  testWidgets('a page with only photos we already have does not stall', (
    tester,
  ) async {
    final page1 =
        (FakePhotoRepository.fixturePage('curated_page1')
                as Success<PhotosPage>)
            .data;
    final repo = FakePhotoRepository(
      onCurated: (page) async => switch (page) {
        1 => Success(page1),
        // Page 2 repeats page 1 (the curated list changed in between).
        2 => Success(
          PhotosPage(
            page: 2,
            perPage: 12,
            photos: page1.photos,
            nextPage: 'next',
          ),
        ),
        _ => FakePhotoRepository.fixturePage('curated_page2'),
      },
    );
    tester.view.physicalSize = const Size(390, 2400); // a very tall screen
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final provider = PhotosProvider(repo);
    await tester.pumpWidget(
      withBookmarks(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      ),
    );
    await provider.loadCurated();
    await tester.pumpAndSettle();

    expect(repo.curatedCalls, [1, 2, 3]);
    expect(provider.photos, hasLength(24));
  });

  testWidgets('an empty first page shows a Reload button', (tester) async {
    var empty = true;
    final repo = FakePhotoRepository(
      onCurated: (page) async => empty
          ? Success(PhotosPage(page: 1, perPage: 12, photos: const []))
          : await pages(page),
    );
    await pumpHome(tester, repo);
    expect(find.text('No photos yet'), findsOneWidget);

    empty = false;
    await tester.tap(find.text('Reload'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('pull to refresh reloads page 1', (tester) async {
    final repo = FakePhotoRepository(onCurated: pages);
    await pumpHome(tester, repo);

    await tester.fling(find.byType(GridView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(repo.curatedCalls, [1, 1]);
  });

  testWidgets('a failed refresh shows a SnackBar and keeps the grid', (
    tester,
  ) async {
    var fail = false;
    final repo = FakePhotoRepository(
      onCurated: (page) async =>
          fail ? const Failure('No internet') : await pages(page),
    );
    await pumpHome(tester, repo);

    fail = true;
    await tester.fling(find.byType(GridView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(SnackBar, 'No internet'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('a failed loadMore shows a retry button', (tester) async {
    var fail = true;
    final repo = FakePhotoRepository(
      onCurated: (page) async =>
          page == 2 && fail ? const Failure('No internet') : await pages(page),
    );
    final provider = await pumpHome(tester, repo);

    await tester.drag(find.byType(GridView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(find.text("Couldn't load more. Retry"), findsOneWidget);

    fail = false;
    await tester.tap(find.text("Couldn't load more. Retry"));
    await tester.pumpAndSettle();

    expect(provider.photos, hasLength(24));
    expect(find.text("Couldn't load more. Retry"), findsNothing);
  });
}
