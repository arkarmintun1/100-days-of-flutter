import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/app_exception.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/core/retry_policy.dart';
import 'package:pixly/providers/curated_photos.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:pixly/widgets/retrying_notice.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

/// Fails [failures] times with [kind], then returns page 1.
FakePhotoRepository flaky(int failures, {ErrorKind kind = ErrorKind.network}) {
  var calls = 0;
  return FakePhotoRepository(
    onCurated: (page) async => ++calls <= failures
        ? Failure('Unable to connect.', kind: kind)
        : FakePhotoRepository.fixturePage('curated_page1'),
  );
}

void main() {
  group('retryTransient', () {
    const network = AppException('No internet', kind: ErrorKind.network);

    test('waits 1 s, 2 s, then 4 s, then gives up', () {
      expect(retryTransient(0, network), const Duration(seconds: 1));
      expect(retryTransient(1, network), const Duration(seconds: 2));
      expect(retryTransient(2, network), const Duration(seconds: 4));
      expect(retryTransient(3, network), isNull);
    });

    test('retries only errors that may fix themselves', () {
      Duration? first(ErrorKind kind) =>
          retryTransient(0, AppException('x', kind: kind));
      expect(first(ErrorKind.network), isNotNull);
      expect(first(ErrorKind.server), isNotNull);
      expect(first(ErrorKind.rateLimited), isNull);
      expect(first(ErrorKind.unauthorized), isNull);
      expect(first(ErrorKind.notFound), isNull);
      expect(first(ErrorKind.unknown), isNull);
    });

    test('never retries bugs', () {
      expect(retryTransient(0, StateError('bug')), isNull);
      expect(retryTransient(0, Exception('not ours')), isNull);
    });
  });

  group('a provider with retryTransient', () {
    ProviderContainer containerWith(FakePhotoRepository repo) =>
        ProviderContainer.test(
          retry: retryTransient,
          overrides: [
            photoRepositoryProvider.overrideWithValue(repo),
            storageProvider.overrideWith(
              (ref) => Storage<String, String>.inMemory(),
            ),
          ],
        );

    test('recovers from two network errors by itself', () {
      fakeAsync((async) {
        final repo = flaky(2);
        final container = containerWith(repo);
        final sub = container.listen(curatedPhotosProvider, (_, _) {});
        async.flushMicrotasks();

        // Failed once: loading again, with the error, retry scheduled.
        expect(sub.read(), isA<AsyncLoading<Object>>());
        expect(sub.read().retrying, isTrue);
        expect(repo.curatedCalls, [1]);

        async.elapse(const Duration(seconds: 1));
        expect(repo.curatedCalls, [1, 1]);

        async.elapse(const Duration(seconds: 2));
        expect(repo.curatedCalls, [1, 1, 1]);
        expect(sub.read().value?.photos, hasLength(12));
        expect(sub.read().retrying, isFalse);
      });
    });

    test('gives up after 3 retries and shows the error', () {
      fakeAsync((async) {
        final repo = flaky(100);
        final container = containerWith(repo);
        final sub = container.listen(curatedPhotosProvider, (_, _) {});

        async.elapse(const Duration(seconds: 1 + 2 + 4));
        expect(repo.curatedCalls, [1, 1, 1, 1]); // first try + 3 retries
        expect(sub.read(), isA<AsyncError<Object>>());
        expect(sub.read().retrying, isFalse);

        async.elapse(const Duration(minutes: 1));
        expect(repo.curatedCalls, hasLength(4)); // no more requests
      });
    });

    test('a rate limit is not retried', () {
      fakeAsync((async) {
        final repo = flaky(100, kind: ErrorKind.rateLimited);
        final container = containerWith(repo);
        final sub = container.listen(curatedPhotosProvider, (_, _) {});

        async.elapse(const Duration(minutes: 1));
        expect(repo.curatedCalls, [1]);
        expect(sub.read(), isA<AsyncError<Object>>());
      });
    });
  });

  group('Home', () {
    setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

    testWidgets('says it is trying again, then shows the photos', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        testApp(repository: flaky(1), retry: retryTransient),
      );
      await tester.pump(); // the first request fails
      await tester.pump();
      expect(find.byType(RetryingNotice), findsOneWidget);
      expect(find.text("Couldn't load. Trying again…"), findsOneWidget);

      await tester.pump(const Duration(seconds: 1)); // the retry
      await tester.pumpAndSettle();
      expect(find.byType(RetryingNotice), findsNothing);
      expect(find.byType(PhotoCard), findsWidgets);
    });
  });
}
