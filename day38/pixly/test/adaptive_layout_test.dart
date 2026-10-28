import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/screens/search_screen.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  void useSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  /// Cards in the first row of the grid.
  int columns(WidgetTester tester) {
    final cards = find.byType(PhotoCard);
    final top = tester.getTopLeft(cards.first).dy;
    return cards
        .evaluate()
        .where((e) => tester.getTopLeft(find.byWidget(e.widget)).dy == top)
        .length;
  }

  testWidgets('phone: bottom navigation bar and 2 columns', (tester) async {
    useSize(tester, const Size(390, 844));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(columns(tester), 2);
  });

  testWidgets('medium width: a rail with labels under the icons', (
    tester,
  ) async {
    useSize(tester, const Size(700, 1000));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
    expect(rail.labelType, NavigationRailLabelType.all);
    expect(columns(tester), 3);
  });

  testWidgets('expanded width: an extended rail and more columns', (
    tester,
  ) async {
    useSize(tester, const Size(1280, 800));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
    expect(columns(tester), greaterThanOrEqualTo(4));
  });

  testWidgets('a short, wide window does not overflow the rail', (
    tester,
  ) async {
    useSize(tester, const Size(900, 220));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.widget<NavigationRail>(find.byType(NavigationRail)).scrollable,
      isTrue,
    );
  });

  testWidgets('resizing keeps the open detail screen', (tester) async {
    useSize(tester, const Size(390, 844));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PhotoCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(PhotoDetailScreen), findsOneWidget);

    // Bar -> rail: the shell moves in the tree but keeps its state.
    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(PhotoDetailScreen), findsOneWidget);
  });

  testWidgets('the rail switches tabs', (tester) async {
    useSize(tester, const Size(1280, 800));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text('Search'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
  });

  group('detail screen', () {
    final photo = PhotosPage.fromJson(
      FakeAdapter.fixture('curated_page1'),
    ).photos.first;
    final title = photo.alt.isEmpty ? 'Untitled' : photo.alt;

    Future<void> openDetail(WidgetTester tester) async {
      await tester.pumpWidget(
        testApp(
          router: createRouter(initialLocation: AppRoutes.photo(photo.id)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PhotoDetailScreen), findsOneWidget);
    }

    testWidgets('narrow: the info is below the photo', (tester) async {
      useSize(tester, const Size(390, 844));
      await openDetail(tester);

      final photoRect = tester.getRect(find.byType(Hero));
      final titleRect = tester.getRect(find.text(title));
      expect(titleRect.top, greaterThanOrEqualTo(photoRect.bottom));
    });

    testWidgets('wide: the info is next to the photo', (tester) async {
      useSize(tester, const Size(1280, 800));
      await openDetail(tester);

      final photoRect = tester.getRect(find.byType(Hero));
      final titleRect = tester.getRect(find.text(title));
      expect(titleRect.left, greaterThanOrEqualTo(photoRect.right));
    });

    testWidgets('uses the space it gets, not the window width', (tester) async {
      // 760 is a "medium" window, but the rail takes some of it, so the
      // detail screen gets less than 720 and stacks.
      useSize(tester, const Size(760, 1000));
      await openDetail(tester);

      final body = find.descendant(
        of: find.byType(PhotoDetailScreen),
        matching: find.byType(LayoutBuilder),
      );
      expect(
        tester.getSize(body).width,
        lessThan(PhotoDetailScreen.sideBySideMinWidth),
      );
      // Stacked: one scrolling list (the title may be below the fold).
      expect(
        find.descendant(of: body, matching: find.byType(ListView)),
        findsOneWidget,
      );
    });
  });
}
