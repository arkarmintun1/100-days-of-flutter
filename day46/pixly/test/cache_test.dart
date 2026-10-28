import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/providers/cache_for.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/providers/photo_by_id.dart';
import 'package:pixly/providers/search.dart';

import 'helpers/fake_repository.dart';

void main() {
  ProviderContainer containerWith(FakePhotoRepository repo) =>
      ProviderContainer.test(
        overrides: [photoRepositoryProvider.overrideWithValue(repo)],
      );

  group('photoById', () {
    test('a loaded photo is kept for cacheDuration after it loaded', () {
      fakeAsync((async) {
        final repo = FakePhotoRepository();
        final container = containerWith(repo);
        final provider = photoByIdProvider(1001);

        final sub = container.listen(provider, (_, _) {});
        async.flushMicrotasks();
        expect(sub.read().value?.id, 1001);

        sub.close(); // e.g. the detail screen was closed
        async.elapse(Duration.zero); // Riverpod disposes on a zero timer
        expect(container.exists(provider), isTrue);

        // Opening it again uses the cached photo: no second request.
        final again = container.listen(provider, (_, _) {});
        expect(again.read().value?.id, 1001);
        again.close();
        expect(repo.photoCalls, [1001]);

        async.elapse(cacheDuration - const Duration(seconds: 1));
        expect(container.exists(provider), isTrue);

        async.elapse(const Duration(seconds: 1));
        expect(container.exists(provider), isFalse);
      });
    });

    test('a photo that failed to load is not kept', () {
      fakeAsync((async) {
        final repo = FakePhotoRepository(
          onPhoto: (id) async => const Failure('No connection'),
        );
        final container = containerWith(repo);
        final provider = photoByIdProvider(1001);

        final sub = container.listen(provider, (_, _) {});
        async.flushMicrotasks();
        expect(sub.read().hasError, isTrue);

        sub.close();
        async.elapse(Duration.zero);
        expect(container.exists(provider), isFalse);
      });
    });

    test('while it is shown, the photo stays loaded past cacheDuration', () {
      fakeAsync((async) {
        final container = containerWith(FakePhotoRepository());
        final provider = photoByIdProvider(1001);

        container.listen(provider, (_, _) {});
        async.elapse(cacheDuration * 2);
        expect(container.read(provider).value?.id, 1001);
      });
    });
  });

  group('searchResults', () {
    test(
      'going back to a query within cacheDuration does not search again',
      () {
        fakeAsync((async) {
          final repo = FakePhotoRepository();
          final container = containerWith(repo);

          final cat = container.listen(searchResultsProvider('cat'), (_, _) {});
          async.flushMicrotasks();
          cat.close(); // the user searched for something else
          async.elapse(const Duration(minutes: 1));

          final again = container.listen(
            searchResultsProvider('cat'),
            (_, _) {},
          );
          expect(again.read().value?.photos, isNotEmpty);
          expect(repo.searchCalls, [('cat', 1)]);
        });
      },
    );

    test('after cacheDuration the query is searched again', () {
      fakeAsync((async) {
        final repo = FakePhotoRepository();
        final container = containerWith(repo);

        container.listen(searchResultsProvider('cat'), (_, _) {}).close();
        async.flushMicrotasks();
        async.elapse(cacheDuration);

        container.listen(searchResultsProvider('cat'), (_, _) {});
        async.flushMicrotasks();
        expect(repo.searchCalls, [('cat', 1), ('cat', 1)]);
      });
    });

    test('invalidating the family forgets every cached query', () {
      fakeAsync((async) {
        final repo = FakePhotoRepository();
        final container = containerWith(repo);

        for (final query in ['cat', 'dog']) {
          container.listen(searchResultsProvider(query), (_, _) {}).close();
        }
        async.flushMicrotasks();
        expect(container.exists(searchResultsProvider('cat')), isTrue);

        container.invalidate(searchResultsProvider);
        async.elapse(Duration.zero);

        expect(container.exists(searchResultsProvider('cat')), isFalse);
        expect(container.exists(searchResultsProvider('dog')), isFalse);
      });
    });
  });
}
