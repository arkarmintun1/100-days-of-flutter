import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:pixly/widgets/shimmer_grid.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  /// How tall the app bar is drawn right now.
  double appBarHeight(WidgetTester tester) {
    final header = tester.renderObject<RenderSliver>(
      find.byType(SliverPersistentHeader),
    );
    return header.geometry!.paintExtent;
  }

  testWidgets('the large app bar shrinks but stays pinned when scrolling', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final expanded = appBarHeight(tester);
    expect(find.text('Curated by the Pexels team'), findsOneWidget);

    await tester.drag(find.byType(PhotoGrid), const Offset(0, -500));
    await tester.pumpAndSettle();

    final collapsed = appBarHeight(tester);
    expect(collapsed, lessThan(expanded));
    expect(collapsed, greaterThan(0)); // pinned: never scrolls away
    expect(find.text('Pixly').hitTestable(), findsWidgets);
  });

  testWidgets('the intro text scrolls away with the grid', (tester) async {
    phone(tester);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PhotoGrid), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Curated by the Pexels team').hitTestable(), findsNothing);
  });

  testWidgets('the app bar is shown while the first page loads', (
    tester,
  ) async {
    phone(tester);
    final repo = FakePhotoRepository(
      onCurated: (_) => FakePhotoRepository.never(),
    );
    await tester.pumpWidget(
      testApp(repository: repo, provider: PhotosProvider(repo)..loadCurated()),
    );
    await tester.pump();

    expect(find.byType(SliverAppBar), findsOneWidget);
    expect(find.byType(ShimmerGrid), findsOneWidget);
  });
}
