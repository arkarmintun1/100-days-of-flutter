import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_bookmarks.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  final photo = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos.first;

  // A tall phone-shaped view so the text under the (portrait) photo is
  // built; ListView only builds what is on screen.
  void useTallView(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpHome(WidgetTester tester) async {
    useTallView(tester);
    final provider = PhotosProvider(FakePhotoRepository());
    await tester.pumpWidget(testApp(provider: provider));
    await provider.loadCurated();
    await tester.pumpAndSettle();
  }

  testWidgets('tapping a photo opens its detail screen, back returns', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byType(PhotoCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(PhotoDetailScreen), findsOneWidget);
    expect(find.text('Photo by ${photo.photographer} on Pexels'), findsOne);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(PhotoDetailScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('the grid card and the detail image share a Hero tag', (
    tester,
  ) async {
    await pumpHome(tester);
    final cardHero = tester.widget<Hero>(find.byType(Hero).first);

    await tester.tap(find.byType(PhotoCard).first);
    await tester.pumpAndSettle();

    final detailHero = tester.widget<Hero>(
      find.descendant(
        of: find.byType(PhotoDetailScreen),
        matching: find.byType(Hero),
      ),
    );
    expect(detailHero.tag, cardHero.tag);
    expect(detailHero.tag, 'photo-${photo.id}');
  });

  testWidgets('detail shows alt text, size and average colour', (tester) async {
    useTallView(tester);
    await tester.pumpWidget(
      withBookmarks(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PhotoDetailScreen(photo: photo),
        ),
      ),
    );

    expect(find.text(photo.alt), findsOneWidget);
    expect(find.text('${photo.width} × ${photo.height}'), findsOneWidget);
    expect(find.text(photo.avgColor), findsOneWidget);
    expect(find.text('View on Pexels'), findsOneWidget);

    final image = tester.widget<PhotoImage>(find.byType(PhotoImage).first);
    expect(image.url, photo.src.large2x);
    expect(image.thumbnailUrl, photo.src.medium);
  });
}
