// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/search_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() async {
    await loadRealFonts();
    PhotoImage.cacheManagerOverride = FakeCacheManager();
  });

  /// A SearchProvider that has already searched [queries] (last one shown).
  Future<SearchProvider> searched(
    FakePhotoRepository repo,
    List<String> queries, {
    bool clearAfter = false,
  }) async {
    final provider = SearchProvider(repo);
    for (final q in queries) {
      await provider.search(q);
    }
    if (clearAfter) provider.clear();
    return provider;
  }

  Future<void> shot(
    WidgetTester t,
    String name,
    Future<SearchProvider> Function(FakePhotoRepository repo) build, {
    FakePhotoRepository? repo,
    bool dark = false,
  }) async {
    final r = repo ?? FakePhotoRepository();
    // Build the provider outside the fake-async test zone.
    final provider = (await t.runAsync(() => build(r)))!;
    await screenshot(
      t,
      name,
      testApp(
        repository: r,
        searchProvider: provider,
        loadOnStart: false,
        theme: dark ? AppTheme.darkTheme : null,
        router: createRouter(initialLocation: AppRoutes.search),
      ),
    );
  }

  testWidgets(
    'day34_recent_searches',
    (t) => shot(
      t,
      'day34_recent_searches',
      (repo) => searched(repo, [
        'mountains',
        'coffee',
        'yangon',
        'nature',
      ], clearAfter: true),
    ),
  );

  testWidgets(
    'day34_results',
    (t) => shot(t, 'day34_results', (repo) => searched(repo, ['nature'])),
  );

  testWidgets(
    'day34_results_dark',
    (t) => shot(
      t,
      'day34_results_dark',
      (repo) => searched(repo, ['nature']),
      dark: true,
    ),
  );

  testWidgets(
    'day34_no_results',
    (t) => shot(
      t,
      'day34_no_results',
      (repo) => searched(repo, ['qwertyuiop']),
      repo: FakePhotoRepository(
        onSearch: (query, page) async =>
            Success(PhotosPage(page: 1, perPage: 20, photos: const [])),
      ),
    ),
  );
}
