import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:pixly/widgets/shimmer_grid.dart';
import 'package:shimmer/shimmer.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_bookmarks.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  final photos = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos;

  Widget wrap(Widget child) => withBookmarks(
    MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    ),
  );

  testWidgets('PhotoGrid shows 2 columns of cards with photographer names', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(PhotoGrid(photos: photos)));

    final first = tester.getTopLeft(find.byType(PhotoCard).at(0));
    final second = tester.getTopLeft(find.byType(PhotoCard).at(1));
    final third = tester.getTopLeft(find.byType(PhotoCard).at(2));
    expect(first.dy, second.dy);
    expect(third.dy, greaterThan(first.dy));
    expect(find.text(photos.first.photographer), findsOneWidget);

    // 390 - 2*12 padding - 12 spacing = 354 / 2 = 177 wide, 177 / 0.75 = 236 tall
    final size = tester.getSize(find.byType(PhotoCard).first);
    expect(size.width, closeTo(177, 0.01));
    expect(size.height, closeTo(236, 0.01));
  });

  testWidgets('PhotoCard asks for the medium-size image', (tester) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(width: 200, height: 260, child: PhotoCard(photo: photos[0])),
      ),
    );
    final image = tester.widget<PhotoImage>(find.byType(PhotoImage));
    expect(image.url, photos[0].src.medium);
  });

  testWidgets('ShimmerGrid uses the PixlyColors shimmer colours', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const ShimmerGrid()));
    final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    final gradient = shimmer.gradient as LinearGradient;
    expect(gradient.colors.first, PixlyColors.light.shimmerBase);
    expect(gradient.colors, contains(PixlyColors.light.shimmerHighlight));
  });
}
