// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  testWidgets(
    'day33_home_tab',
    (t) => screenshot(t, 'day33_home_tab', testApp()),
  );

  testWidgets(
    'day33_detail_in_tab',
    (t) => screenshot(
      t,
      'day33_detail_in_tab',
      testApp(router: createRouter(initialLocation: AppRoutes.photo(1002))),
    ),
  );

  testWidgets(
    'day33_bookmarks_tab_dark',
    (t) => screenshot(
      t,
      'day33_bookmarks_tab_dark',
      testApp(
        theme: AppTheme.darkTheme,
        router: createRouter(initialLocation: AppRoutes.bookmarks),
      ),
    ),
  );

  testWidgets(
    'day33_not_found',
    (t) => screenshot(
      t,
      'day33_not_found',
      testApp(router: createRouter(initialLocation: '/does-not-exist')),
    ),
  );
}
