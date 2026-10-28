import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  Future<void> openSearchTab(WidgetTester tester, Widget app) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
  }

  testWidgets('typing searches after a short pause', (tester) async {
    final repo = FakePhotoRepository();
    await openSearchTab(tester, testApp(repository: repo));

    await tester.enterText(find.byType(TextField), 'nature');
    await tester.pump(const Duration(milliseconds: 300));
    expect(repo.searchCalls, isEmpty); // still typing

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(repo.searchCalls, [('nature', 1)]);
    expect(find.byType(PhotoCard), findsWidgets);
  });

  testWidgets('no results shows a message', (tester) async {
    final repo = FakePhotoRepository(
      onSearch: (query, page) async =>
          Success(PhotosPage(page: 1, perPage: 20, photos: const [])),
    );
    await openSearchTab(tester, testApp(repository: repo));

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('No results'), findsOneWidget);
  });

  testWidgets('a recent search can be tapped to search again', (tester) async {
    final repo = FakePhotoRepository();
    await openSearchTab(tester, testApp(repository: repo));
    await tester.enterText(find.byType(TextField), 'coffee');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Clear')); // back to the empty screen
    await tester.pumpAndSettle();
    expect(find.text('Recent searches'), findsOneWidget);

    await tester.tap(find.text('coffee'));
    await tester.pumpAndSettle();

    // The old results were disposed with their query, so this is a new
    // request.
    expect(repo.searchCalls, [('coffee', 1), ('coffee', 1)]);
    expect(find.byType(PhotoCard), findsWidgets);
  });

  testWidgets('typing a new query cancels the old request', (tester) async {
    final first = Completer<Result<PhotosPage>>();
    final repo = FakePhotoRepository(
      onSearch: (query, page) => query == 'cat'
          ? first.future
          : Future.value(FakePhotoRepository.fixturePage('search_nature')),
    );
    await openSearchTab(tester, testApp(repository: repo));

    await tester.enterText(find.byType(TextField), 'cat');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    final catToken = repo.searchTokens.single!;
    expect(catToken.isCancelled, isFalse);

    await tester.enterText(find.byType(TextField), 'dog');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(catToken.isCancelled, isTrue);
    expect(find.byType(PhotoCard), findsWidgets); // the dog results
    first.complete(FakePhotoRepository.fixturePage('search_nature'));
  });

  testWidgets('tapping a result opens the detail inside the search tab', (
    tester,
  ) async {
    final router = createRouter();
    await openSearchTab(tester, testApp(router: router));

    await tester.enterText(find.byType(TextField), 'nature');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PhotoCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(PhotoDetailScreen), findsOneWidget);
    expect(router.state.uri.toString(), AppRoutes.searchPhoto(1012));
  });
}
