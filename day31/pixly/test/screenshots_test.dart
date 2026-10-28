// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/screenshot_helper.dart';

Widget app(FakePhotoRepository repo, {ThemeData? theme}) {
  return ChangeNotifierProvider(
    create: (_) => PhotosProvider(repo)..loadCurated(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.lightTheme,
      home: const HomeScreen(),
    ),
  );
}

/// Scrolls in real async so images of the newly built cards can load.
Future<void> scrollToEnd(WidgetTester tester) async {
  await tester.runAsync(() async {
    await tester.drag(find.byType(GridView), const Offset(0, -3000));
    await tester.pump();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await tester.pump();
    await Future<void>.delayed(const Duration(milliseconds: 300));
  });
  await tester.pump();
}

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  testWidgets(
    'day31_loading_more',
    (t) => screenshot(
      t,
      'day31_loading_more',
      app(
        FakePhotoRepository(
          onCurated: (page) => page == 1
              ? Future.value(FakePhotoRepository.fixturePage('curated_page1'))
              : FakePhotoRepository.never(),
        ),
      ),
      settle: false,
      before: (t) async {
        await scrollToEnd(t);
        await t.pump(const Duration(milliseconds: 300));
      },
    ),
  );

  testWidgets(
    'day31_load_more_error',
    (t) => screenshot(
      t,
      'day31_load_more_error',
      app(
        FakePhotoRepository(
          onCurated: (page) async => page == 1
              ? FakePhotoRepository.fixturePage('curated_page1')
              : const Failure('No internet connection.'),
        ),
      ),
      before: (t) async {
        await scrollToEnd(t);
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets('day31_refreshing', (t) {
    var calls = 0;
    return screenshot(
      t,
      'day31_refreshing',
      app(
        FakePhotoRepository(
          onCurated: (_) => calls++ == 0
              ? Future.value(FakePhotoRepository.fixturePage('curated_page1'))
              : FakePhotoRepository.never(),
        ),
      ),
      settle: false,
      before: (t) async {
        await t.fling(find.byType(GridView), const Offset(0, 400), 1000);
        for (var i = 0; i < 10; i++) {
          await t.pump(const Duration(milliseconds: 100));
        }
      },
    );
  });
}
