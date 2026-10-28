// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
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

  Widget homeFailing(Failure<Never> failure) =>
      testApp(repository: FakePhotoRepository(onCurated: (_) async => failure));

  testWidgets(
    'day39_offline',
    (t) => screenshot(
      t,
      'day39_offline',
      homeFailing(
        const Failure(
          'Unable to connect. Check your network and try again.',
          kind: ErrorKind.network,
        ),
      ),
    ),
  );

  testWidgets(
    'day39_api_key',
    (t) => screenshot(
      t,
      'day39_api_key',
      homeFailing(
        const Failure(
          'Invalid API key. Check PEXELS_API_KEY in your .env file.',
          kind: ErrorKind.unauthorized,
        ),
      ),
    ),
  );

  testWidgets('day39_search_rate_limited', (t) async {
    final repo = FakePhotoRepository(
      onSearch: (query, page) async => const Failure(
        'Too many requests to Pexels for now. '
        'Please wait a while and try again.',
        kind: ErrorKind.rateLimited,
      ),
    );
    final search = SearchProvider(repo);
    await screenshot(
      t,
      'day39_search_rate_limited',
      testApp(
        repository: repo,
        searchProvider: search,
        router: createRouter(initialLocation: AppRoutes.search),
      ),
      before: (t) async {
        await t.enterText(find.byType(TextField), 'mountains');
        await t.testTextInput.receiveAction(TextInputAction.search);
        await t.pumpAndSettle();
      },
    );
  });

  testWidgets('day39_search_results', (t) async {
    await screenshot(
      t,
      'day39_search_results',
      testApp(router: createRouter(initialLocation: AppRoutes.search)),
      before: (t) async {
        await t.enterText(find.byType(TextField), 'nature');
        await t.testTextInput.receiveAction(TextInputAction.search);
        await t.pumpAndSettle();
        await precacheAllImages(t);
      },
    );
  });
}
