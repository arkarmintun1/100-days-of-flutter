import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/search_provider.dart';

import 'helpers/fake_repository.dart';

void main() {
  test('typing quickly sends one request, after the pause', () {
    fakeAsync((async) {
      final repo = FakePhotoRepository();
      final provider = SearchProvider(repo);

      for (final text in ['c', 'ca', 'cat']) {
        provider.onQueryChanged(text);
        async.elapse(const Duration(milliseconds: 100)); // fast typing
      }
      // 100 ms after the last key: still waiting.
      expect(repo.searchCalls, isEmpty);

      async.elapse(const Duration(milliseconds: 400)); // 500 ms pause
      async.flushMicrotasks();

      expect(repo.searchCalls, [('cat', 1)]);
      expect(provider.query, 'cat');
      expect(provider.photos, hasLength(12));
    });
  });

  test('spaces around the query are ignored', () {
    fakeAsync((async) {
      final repo = FakePhotoRepository();
      final provider = SearchProvider(repo);

      provider.onQueryChanged('  coffee  ');
      async.elapse(SearchProvider.defaultDebounce);
      async.flushMicrotasks();

      expect(repo.searchCalls, [('coffee', 1)]);
    });
  });

  test('clearing the text clears the results without a request', () {
    fakeAsync((async) {
      final repo = FakePhotoRepository();
      final provider = SearchProvider(repo);
      provider.onQueryChanged('cat');
      async.elapse(SearchProvider.defaultDebounce);
      async.flushMicrotasks();

      provider.onQueryChanged('');
      async.elapse(SearchProvider.defaultDebounce);
      async.flushMicrotasks();

      expect(repo.searchCalls, [('cat', 1)]);
      expect(provider.query, isEmpty);
      expect(provider.photos, isEmpty);
    });
  });

  test('search() skips the wait (keyboard search button)', () async {
    final repo = FakePhotoRepository();
    final provider = SearchProvider(repo);

    provider.onQueryChanged('ca');
    await provider.search('cat');

    expect(repo.searchCalls, [('cat', 1)]);
  });

  test('searching the same query again does not send a new request', () async {
    final repo = FakePhotoRepository();
    final provider = SearchProvider(repo);

    await provider.search('cat');
    await provider.search('cat');

    expect(repo.searchCalls, [('cat', 1)]);
  });

  test('a slow answer for an old query is ignored', () async {
    final slowCat = Completer<Result<PhotosPage>>();
    final repo = FakePhotoRepository(
      onSearch: (query, page) => query == 'cat'
          ? slowCat.future
          : Future.value(FakePhotoRepository.fixturePage('curated_page1')),
    );
    final provider = SearchProvider(repo);

    final cat = provider.search('cat'); // still waiting...
    await provider.search('dog'); // ...when the user searches again
    slowCat.complete(FakePhotoRepository.fixturePage('search_nature'));
    await cat;

    expect(provider.query, 'dog');
    expect(provider.photos.first.id, 1001); // dog's results, not cat's
    expect(provider.recentSearches, ['dog']);
  });

  test(
    'an old answer that arrives while the user is still typing is ignored',
    () {
      fakeAsync((async) {
        final slowCat = Completer<Result<PhotosPage>>();
        final repo = FakePhotoRepository(
          onSearch: (query, page) => query == 'cat'
              ? slowCat.future
              : Future.value(FakePhotoRepository.fixturePage('curated_page1')),
        );
        final provider = SearchProvider(repo);

        provider.search('cat'); // request sent, still waiting...
        provider.onQueryChanged('dog'); // ...user types, debounce not done yet
        slowCat.complete(FakePhotoRepository.fixturePage('search_nature'));
        async.flushMicrotasks();

        expect(provider.query, 'dog');
        expect(provider.photos, isEmpty); // cat's photos were not shown
        expect(provider.isLoading, isTrue);

        async.elapse(SearchProvider.defaultDebounce);
        async.flushMicrotasks();

        expect(repo.searchCalls, [('cat', 1), ('dog', 1)]);
        expect(provider.photos.first.id, 1001); // dog's results
      });
    },
  );

  test('a search with no results is not sent again', () async {
    final repo = FakePhotoRepository(
      onSearch: (query, page) async =>
          Success(PhotosPage(page: 1, perPage: 20, photos: const [])),
    );
    final provider = SearchProvider(repo);

    await provider.search('qwerty');
    await provider.search('qwerty');

    expect(repo.searchCalls, [('qwerty', 1)]);
    expect(provider.isLoading, isFalse);
  });

  test('"Try again" after an error sends the request again', () async {
    var fail = true;
    final repo = FakePhotoRepository(
      onSearch: (query, page) async => fail
          ? const Failure('No internet')
          : FakePhotoRepository.fixturePage('search_nature'),
    );
    final provider = SearchProvider(repo);

    await provider.search('cat');
    expect(provider.error, 'No internet');

    fail = false;
    await provider.search('cat');

    expect(repo.searchCalls, [('cat', 1), ('cat', 1)]);
    expect(provider.error, isNull);
    expect(provider.photos, hasLength(12));
  });

  test('loadMore asks for the next page of the same query', () async {
    final repo = FakePhotoRepository(
      onSearch: (query, page) async => FakePhotoRepository.fixturePage(
        page == 1 ? 'curated_page1' : 'curated_page2',
      ),
    );
    final provider = SearchProvider(repo);

    await provider.search('cat');
    await provider.loadMore();

    expect(repo.searchCalls, [('cat', 1), ('cat', 2)]);
    expect(provider.photos, hasLength(24));
  });

  test('recent searches: newest first, no duplicates, at most 5', () async {
    final provider = SearchProvider(FakePhotoRepository());

    for (final q in ['a', 'b', 'c', 'B', 'd', 'e', 'f']) {
      await provider.search(q);
    }

    expect(provider.recentSearches, ['f', 'e', 'd', 'B', 'c']);
  });

  test('a failed search is not added to recent searches', () async {
    final provider = SearchProvider(
      FakePhotoRepository(
        onSearch: (query, page) async => const Failure('No internet'),
      ),
    );

    await provider.search('cat');

    expect(provider.error, 'No internet');
    expect(provider.recentSearches, isEmpty);
  });

  test('dispose cancels a search that is still waiting', () {
    fakeAsync((async) {
      final repo = FakePhotoRepository();
      final provider = SearchProvider(repo);

      provider.onQueryChanged('cat');
      provider.dispose();
      async.elapse(const Duration(seconds: 1));

      expect(repo.searchCalls, isEmpty);
    });
  });
}
