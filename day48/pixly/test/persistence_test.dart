import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/core/retry_policy.dart';
import 'package:pixly/models/photo_feed.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/curated_photos.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:pixly/widgets/stale_notice.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

const key = 'curated_photos';

/// What the last app session saved: page 1 of the curated photos.
Future<Storage<String, String>> savedLastTime() async {
  final storage = Storage<String, String>.inMemory();
  final page = FakePhotoRepository.fixturePage('curated_page1');
  final feed = PhotoFeed.firstPage((page as Success<PhotosPage>).data);
  await storage.write(
    key,
    jsonEncode(feed.toSavedJson()),
    const StorageOptions(),
  );
  return storage;
}

FakePhotoRepository offline() => FakePhotoRepository(
  onCurated: (_) async => const Failure('Unable to connect.'),
);

void main() {
  ProviderContainer containerWith(
    FakePhotoRepository repo,
    Storage<String, String> storage,
  ) => ProviderContainer.test(
    retry: noRetry,
    overrides: [
      photoRepositoryProvider.overrideWithValue(repo),
      storageProvider.overrideWith((ref) => storage),
    ],
  );

  Future<void> settle(ProviderContainer container) async {
    try {
      await container.read(curatedPhotosProvider.future);
    } catch (_) {
      // Checked through the state.
    }
  }

  test('page 1 is saved to the storage', () async {
    final storage = Storage<String, String>.inMemory();
    final container = containerWith(FakePhotoRepository(), storage);
    await settle(container);

    final saved = await storage.read(key);
    final feed = PhotoFeed.fromSavedJson(
      jsonDecode(saved!.data) as Map<String, dynamic>,
    );
    expect(feed.photos, hasLength(12));
    expect(feed.page, 1);
    // CuratedPhotos keeps it for 7 days.
    expect(saved.expireAt, isNotNull);
  });

  test('the saved feed shows while page 1 loads', () async {
    final page1 = Completer<Result<PhotosPage>>();
    final container = containerWith(
      FakePhotoRepository(onCurated: (_) => page1.future),
      await savedLastTime(),
    );
    container.listen(curatedPhotosProvider, (_, _) {});
    await pumpEventQueue();

    final state = container.read(curatedPhotosProvider);
    expect(state.isLoading, isTrue);
    expect(state.isFromCache, isTrue);
    expect(state.value!.photos, hasLength(12));

    page1.complete(FakePhotoRepository.fixturePage('curated_page1'));
    await settle(container);
    expect(container.read(curatedPhotosProvider).isFromCache, isFalse);
  });

  test('offline at launch: the saved feed stays, marked as stale', () async {
    final storage = await savedLastTime();
    final container = containerWith(offline(), storage);
    await settle(container);

    final state = container.read(curatedPhotosProvider);
    expect(state, isA<AsyncData<PhotoFeed>>());
    expect(state.value!.isStale, isTrue);
    expect(state.value!.photos, hasLength(12));
    // Still saved for the next launch.
    expect(await storage.read(key), isNotNull);
  });

  test('offline on the very first launch: an error, nothing saved', () async {
    final storage = Storage<String, String>.inMemory();
    final container = containerWith(offline(), storage);
    await settle(container);

    expect(container.read(curatedPhotosProvider), isA<AsyncError<Object>>());
    expect(await storage.read(key), isNull);
  });

  test('loading state and errors are not saved', () {
    final page = FakePhotoRepository.fixturePage('curated_page1');
    final feed = PhotoFeed.firstPage(
      (page as Success<PhotosPage>).data,
    ).loadingMore().withLoadMoreError('No internet').copyWith(isStale: true);

    final copy = PhotoFeed.fromSavedJson(
      jsonDecode(jsonEncode(feed.toSavedJson())) as Map<String, dynamic>,
    );
    expect(copy.photos, feed.photos);
    expect(copy.loadMoreError, isNull);
    expect(copy.isStale, isFalse);
  });

  group('Home', () {
    setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

    testWidgets('offline with saved photos shows them and a notice', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final storage = await tester.runAsync(savedLastTime);
      await tester.pumpWidget(
        testApp(repository: offline(), persisted: storage),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StaleNotice), findsOneWidget);
      expect(find.byType(PhotoCard), findsWidgets);
    });
  });
}
