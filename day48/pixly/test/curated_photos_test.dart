import 'dart:async';

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/retry_policy.dart';
import 'package:pixly/core/app_exception.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/curated_photos.dart';
import 'package:pixly/providers/dependencies.dart';

import 'helpers/fake_repository.dart';

Future<Result<PhotosPage>> pages(int page) async => switch (page) {
  1 => FakePhotoRepository.fixturePage('curated_page1'),
  2 => FakePhotoRepository.fixturePage('curated_page2'),
  _ => FakePhotoRepository.fixturePage('curated_last_page'),
};

void main() {
  ProviderContainer containerWith(FakePhotoRepository repo) =>
      ProviderContainer.test(
        retry: noRetry,
        overrides: [
          photoRepositoryProvider.overrideWithValue(repo),
          storageProvider.overrideWith(
            (ref) => Storage<String, String>.inMemory(),
          ),
        ],
      );

  /// Waits for build() to finish, whether it worked or not.
  Future<void> settle(ProviderContainer container) async {
    try {
      await container.read(curatedPhotosProvider.future);
    } catch (_) {
      // The error is checked through the provider's state.
    }
  }

  group('build()', () {
    test('loading, then the first page', () async {
      final container = containerWith(FakePhotoRepository(onCurated: pages));
      final states = <AsyncValue<Object>>[];
      container.listen(
        curatedPhotosProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      await settle(container);

      expect(states.first, isA<AsyncLoading<Object>>());
      final feed = container.read(curatedPhotosProvider).requireValue;
      expect(feed.photos, hasLength(12));
      expect(feed.hasMore, isTrue);
    });

    test('a Failure becomes an AsyncError with an AppException', () async {
      final repo = FakePhotoRepository(
        onCurated: (_) async =>
            const Failure('No internet', kind: ErrorKind.network),
      );
      final container = containerWith(repo);

      await settle(container);

      final state = container.read(curatedPhotosProvider);
      expect(state, isA<AsyncError<Object>>());
      final error = state.error! as AppException;
      expect(error.message, 'No internet');
      expect(error.kind, ErrorKind.network);
    });
  });

  group('loadMore()', () {
    test('appends the next page', () async {
      final repo = FakePhotoRepository(onCurated: pages);
      final container = containerWith(repo);
      await settle(container);

      await container.read(curatedPhotosProvider.notifier).loadMore();

      final feed = container.read(curatedPhotosProvider).requireValue;
      expect(repo.curatedCalls, [1, 2]);
      expect(feed.photos, hasLength(24));
      expect(feed.photos.last.id, 1024);
      expect(feed.isLoadingMore, isFalse);
    });

    test('skips photos we already have and stops at the end', () async {
      final repo = FakePhotoRepository(onCurated: pages);
      final container = containerWith(repo);
      final notifier = container.read(curatedPhotosProvider.notifier);
      await settle(container);
      await notifier.loadMore(); // page 2
      await notifier.loadMore(); // page 3: ids 1001-1004 again, no next_page

      final feed = container.read(curatedPhotosProvider).requireValue;
      expect(feed.photos, hasLength(24));
      expect(feed.hasMore, isFalse);

      await notifier.loadMore(); // nothing left
      expect(repo.curatedCalls, [1, 2, 3]);
    });

    test('does nothing before the first page has loaded', () async {
      final first = Completer<Result<PhotosPage>>();
      final repo = FakePhotoRepository(onCurated: (_) => first.future);
      final container = containerWith(repo);
      container.read(curatedPhotosProvider); // starts build()

      await container.read(curatedPhotosProvider.notifier).loadMore();

      expect(repo.curatedCalls, [1]);
      first.complete(await pages(1));
    });

    test('two calls at once make one request', () async {
      final repo = FakePhotoRepository(onCurated: pages);
      final container = containerWith(repo);
      final notifier = container.read(curatedPhotosProvider.notifier);
      await settle(container);

      await Future.wait([notifier.loadMore(), notifier.loadMore()]);

      expect(repo.curatedCalls, [1, 2]);
    });

    test('a failure keeps the photos and waits for retryLoadMore', () async {
      var failNext = true;
      final repo = FakePhotoRepository(
        onCurated: (page) async {
          if (page == 2 && failNext) {
            failNext = false;
            return const Failure('No internet');
          }
          return pages(page);
        },
      );
      final container = containerWith(repo);
      final notifier = container.read(curatedPhotosProvider.notifier);
      await settle(container);

      await notifier.loadMore();
      var feed = container.read(curatedPhotosProvider).requireValue;
      expect(feed.loadMoreError, 'No internet');
      expect(feed.photos, hasLength(12));

      await notifier.loadMore(); // scrolling again doesn't spam requests
      expect(repo.curatedCalls, [1, 2]);

      await notifier.retryLoadMore();
      feed = container.read(curatedPhotosProvider).requireValue;
      expect(feed.loadMoreError, isNull);
      expect(feed.photos, hasLength(24));
    });
  });

  group('refresh', () {
    test('a refresh ignores a loadMore that was still running', () async {
      final page2 = Completer<Result<PhotosPage>>();
      final repo = FakePhotoRepository(
        onCurated: (page) => page == 2 ? page2.future : pages(page),
      );
      final container = containerWith(repo);
      await settle(container);

      final notifier = container.read(curatedPhotosProvider.notifier);
      final more = notifier.loadMore();
      await notifier.refresh(); // pull to refresh
      page2.complete(await pages(2)); // the old page 2 arrives late
      await more;

      final feed = container.read(curatedPhotosProvider).requireValue;
      expect(feed.photos, hasLength(12)); // page 2 was not appended
      expect(feed.isLoadingMore, isFalse);
    });

    test('a failed refresh keeps the photos, marked as stale', () async {
      var fail = false;
      final container = containerWith(
        FakePhotoRepository(
          onCurated: (page) async =>
              fail ? const Failure('No internet') : await pages(page),
        ),
      );
      await settle(container);

      fail = true;
      // Day 48: no error any more - the photos on screen stay.
      await container.read(curatedPhotosProvider.notifier).refresh();

      final state = container.read(curatedPhotosProvider);
      expect(state, isA<AsyncData<Object>>());
      expect(state.value!.photos, hasLength(12));
      expect(state.value!.isStale, isTrue);
    });

    test('while refreshing, the state is AsyncData with isLoading', () async {
      final page1 = Completer<Result<PhotosPage>>();
      var calls = 0;
      final container = containerWith(
        FakePhotoRepository(
          onCurated: (page) => ++calls == 1 ? pages(page) : page1.future,
        ),
      );
      await settle(container);

      final refresh = container.read(curatedPhotosProvider.notifier).refresh();
      final state = container.read(curatedPhotosProvider);
      expect(state, isA<AsyncData<Object>>());
      expect(state.isLoading, isTrue);
      expect(state.value!.photos, hasLength(12));

      page1.complete(await pages(1));
      await refresh;
      expect(container.read(curatedPhotosProvider).isLoading, isFalse);
    });

    test('a failed refresh during loadMore leaves no stuck spinner', () async {
      final page2 = Completer<Result<PhotosPage>>();
      var fail = false;
      final repo = FakePhotoRepository(
        onCurated: (page) async {
          if (fail) return const Failure('No internet');
          return page == 2 ? page2.future : pages(page);
        },
      );
      final container = containerWith(repo);
      final notifier = container.read(curatedPhotosProvider.notifier);
      await settle(container);

      final more = notifier.loadMore(); // page 2 is loading...
      fail = true;
      await notifier.refresh(); // fails, keeps the (stale) photos
      page2.complete(await pages(2));
      await more;

      final feed = container.read(curatedPhotosProvider).value!;
      expect(feed.isLoadingMore, isFalse);
      expect(feed.canLoadMore, isTrue); // scrolling can load page 2 again
    });

    test('retryLoadMore does nothing while a refresh is running', () async {
      final page1 = Completer<Result<PhotosPage>>();
      var calls = 0;
      final repo = FakePhotoRepository(
        onCurated: (page) {
          calls++;
          if (page == 2) return Future.value(const Failure('No internet'));
          return calls == 1 ? pages(page) : page1.future;
        },
      );
      final container = containerWith(repo);
      final notifier = container.read(curatedPhotosProvider.notifier);
      await settle(container);
      await notifier.loadMore(); // page 2 fails: Retry is shown

      final refresh = notifier.refresh();
      await notifier.retryLoadMore(); // tapped during the refresh
      expect(repo.curatedCalls, [1, 2, 1]);
      expect(container.read(curatedPhotosProvider).isLoading, isTrue);

      page1.complete(await pages(1));
      await refresh;
    });
  });
}
