// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/providers/theme_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_settings.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  ThemeProvider savedMode(String? mode) =>
      ThemeProvider(MemorySettingsStorage(mode));

  Future<void> openSheet(WidgetTester t) async {
    await t.tap(find.byTooltip('Appearance'));
    await t.pumpAndSettle();
  }

  testWidgets(
    'day36_theme_sheet',
    (t) => screenshot(
      t,
      'day36_theme_sheet',
      testApp(themeProvider: savedMode(null)),
      before: openSheet,
    ),
  );

  testWidgets(
    'day36_theme_sheet_dark',
    (t) => screenshot(
      t,
      'day36_theme_sheet_dark',
      testApp(themeProvider: savedMode('dark')),
      before: openSheet,
    ),
  );

  testWidgets(
    'day36_home_dark',
    (t) => screenshot(
      t,
      'day36_home_dark',
      testApp(themeProvider: savedMode('dark')),
    ),
  );

  testWidgets(
    'day36_bookmarks_dark',
    (t) => screenshot(
      t,
      'day36_bookmarks_dark',
      testApp(
        themeProvider: savedMode('dark'),
        router: createRouter(initialLocation: AppRoutes.bookmarks),
      ),
    ),
  );
}
