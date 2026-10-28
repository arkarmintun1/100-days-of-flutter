import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/pexels_link.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

/// Pexels' API guidelines: show a prominent link to Pexels whenever you
/// make an API request, and credit photographers when possible.
void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  final photo = PhotosPage.fromJson(
    FakeAdapter.fixture('curated_page1'),
  ).photos.first;

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('Home links to Pexels and names photographers', (tester) async {
    phone(tester);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.byType(PexelsLink), findsOneWidget);
    expect(find.text(photo.photographer), findsOneWidget);
  });

  testWidgets('Search links to Pexels', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      testApp(router: createRouter(initialLocation: AppRoutes.search)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PexelsLink), findsOneWidget);
  });

  testWidgets('the detail screen credits the photographer', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      testApp(router: createRouter(initialLocation: AppRoutes.photo(photo.id))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Photo by ${photo.photographer} on Pexels'), findsOne);
    expect(find.text('View on Pexels'), findsOneWidget);
  });

  testWidgets('loading a photo by link shows the Pexels link too', (
    tester,
  ) async {
    phone(tester);
    final answer = Completer<Result<Photo>>();
    final repo = FakePhotoRepository(onPhoto: (_) => answer.future);
    await tester.pumpWidget(
      testApp(
        repository: repo,
        loadOnStart: false,
        router: createRouter(initialLocation: AppRoutes.photo(42)),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(PexelsLink), findsOneWidget);

    answer.complete(const Failure('No internet', kind: ErrorKind.network));
    await tester.pumpAndSettle();
    expect(find.text('No connection'), findsOneWidget);
    expect(find.byType(PexelsLink), findsOneWidget);
  });
}
