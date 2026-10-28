// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/providers/theme_provider.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/memory_settings.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  Future<void> scrollDown(WidgetTester t) async {
    await t.drag(find.byType(PhotoGrid), const Offset(0, -300));
    await t.pumpAndSettle();
  }

  testWidgets(
    'day37_home_expanded',
    (t) => screenshot(t, 'day37_home_expanded', testApp()),
  );

  testWidgets(
    'day37_home_collapsed',
    (t) => screenshot(t, 'day37_home_collapsed', testApp(), before: scrollDown),
  );

  testWidgets(
    'day37_home_collapsed_dark',
    (t) => screenshot(
      t,
      'day37_home_collapsed_dark',
      testApp(themeProvider: ThemeProvider(MemorySettingsStorage('dark'))),
      before: scrollDown,
    ),
  );

  testWidgets('day37_loading', (t) {
    final repo = FakePhotoRepository(
      onCurated: (_) => FakePhotoRepository.never(),
    );
    return screenshot(
      t,
      'day37_loading',
      testApp(repository: repo, provider: PhotosProvider(repo)..loadCurated()),
      settle: false,
    );
  });
}
