import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/retry_policy.dart';
import 'package:pixly/core/app_exception.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/providers/search.dart';

import 'helpers/fake_repository.dart';

void main() {
  ProviderContainer containerWith([FakePhotoRepository? repo]) =>
      ProviderContainer.test(
        retry: noRetry,
        overrides: [
          photoRepositoryProvider.overrideWithValue(
            repo ?? FakePhotoRepository(),
          ),
        ],
      );

  group('SearchQuery', () {
    test('sets the query only after a 500 ms pause in typing', () {
      fakeAsync((async) {
        final container = containerWith();
        final search = container.read(searchQueryProvider.notifier);

        for (final text in ['c', 'ca', 'cat']) {
          search.onChanged(text);
          async.elapse(const Duration(milliseconds: 100));
        }
        expect(container.read(searchQueryProvider), (text: 'cat', query: ''));

        async.elapse(const Duration(milliseconds: 400));
        expect(container.read(searchQueryProvider), (
          text: 'cat',
          query: 'cat',
        ));
      });
    });

    test('submit searches right away', () {
      final container = containerWith();
      container.read(searchQueryProvider.notifier).submit('  coffee ');
      expect(container.read(searchQueryProvider), (
        text: 'coffee',
        query: 'coffee',
      ));
    });

    test('clearing the box cancels a pending search', () {
      fakeAsync((async) {
        final container = containerWith();
        final search = container.read(searchQueryProvider.notifier);

        search.onChanged('cat');
        search.onChanged('');
        async.elapse(const Duration(seconds: 1));

        expect(container.read(searchQueryProvider), (text: '', query: ''));
      });
    });
  });

  group('SearchResults', () {
    test('loads the first page for its query', () async {
      final repo = FakePhotoRepository();
      final container = containerWith(repo);
      // Listen, like a widget would: an autoDispose provider nobody listens
      // to may be disposed right away.
      container.listen(searchResultsProvider('cat'), (_, _) {});

      final feed = await container.read(searchResultsProvider('cat').future);

      expect(repo.searchCalls, [('cat', 1)]);
      expect(feed.photos, isNotEmpty);
    });

    test('a Failure becomes an AsyncError', () async {
      final container = containerWith(
        FakePhotoRepository(
          onSearch: (query, page) async =>
              const Failure('Too many requests', kind: ErrorKind.rateLimited),
        ),
      );
      final sub = container.listen(searchResultsProvider('cat'), (_, _) {});
      try {
        await container.read(searchResultsProvider('cat').future);
      } catch (_) {
        // checked below
      }

      final error = sub.read().error! as AppException;
      expect(error.kind, ErrorKind.rateLimited);
    });

    test('each query is its own provider', () async {
      final repo = FakePhotoRepository();
      final container = containerWith(repo);

      container.listen(searchResultsProvider('cat'), (_, _) {});
      container.listen(searchResultsProvider('dog'), (_, _) {});

      await container.read(searchResultsProvider('cat').future);
      await container.read(searchResultsProvider('dog').future);
      await container.read(searchResultsProvider('cat').future); // cached

      expect(repo.searchCalls, [('cat', 1), ('dog', 1)]);
    });

    test('when nobody listens any more, the request is cancelled', () async {
      final repo = FakePhotoRepository(
        onSearch: (query, page) => FakePhotoRepository.never(),
      );
      final container = containerWith(repo);
      final sub = container.listen(searchResultsProvider('cat'), (_, _) {});
      final token = repo.searchTokens.single!;
      expect(token.isCancelled, isFalse);

      sub.close(); // e.g. the user typed another query
      await container.pump(); // lets Riverpod run the scheduled dispose

      expect(token.isCancelled, isTrue);
    });
  });

  group('RecentSearches', () {
    test('newest first, no duplicates (any case), at most 5', () {
      final container = containerWith();
      final recent = container.read(recentSearchesProvider.notifier);

      for (final q in ['a', 'b', 'c', 'd', 'e', 'f', 'B']) {
        recent.add(q);
      }

      expect(container.read(recentSearchesProvider), ['B', 'f', 'e', 'd', 'c']);
    });

    test('clear empties the list', () {
      final container = containerWith();
      container.read(recentSearchesProvider.notifier)
        ..add('cat')
        ..clear();
      expect(container.read(recentSearchesProvider), isEmpty);
    });
  });
}
