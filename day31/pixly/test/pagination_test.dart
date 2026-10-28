import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/photos_provider.dart';

import 'helpers/fake_repository.dart';

Future<Result<PhotosPage>> pages(int page) async => switch (page) {
  1 => FakePhotoRepository.fixturePage('curated_page1'),
  2 => FakePhotoRepository.fixturePage('curated_page2'),
  _ => FakePhotoRepository.fixturePage('curated_last_page'),
};

void main() {
  test('loadMore appends the next page', () async {
    final repo = FakePhotoRepository(onCurated: pages);
    final provider = PhotosProvider(repo);
    await provider.loadCurated();

    await provider.loadMore();

    expect(repo.curatedCalls, [1, 2]);
    expect(provider.photos, hasLength(24));
    expect(provider.photos.last.id, 1024);
    expect(provider.hasMore, isTrue);
    expect(provider.isLoadingMore, isFalse);
  });

  test('skips photos we already have and stops at the last page', () async {
    final repo = FakePhotoRepository(onCurated: pages);
    final provider = PhotosProvider(repo);
    await provider.loadCurated();
    await provider.loadMore(); // page 2
    await provider.loadMore(); // page 3: ids 1001-1004 again, no next_page

    expect(provider.photos, hasLength(24));
    expect(provider.hasMore, isFalse);

    await provider.loadMore(); // nothing left
    expect(repo.curatedCalls, [1, 2, 3]);
  });

  test('loadMore does nothing before the first page has loaded', () async {
    final repo = FakePhotoRepository(onCurated: pages);
    await PhotosProvider(repo).loadMore();
    expect(repo.curatedCalls, isEmpty);
  });

  test('two loadMore calls at once make one request', () async {
    final repo = FakePhotoRepository(onCurated: pages);
    final provider = PhotosProvider(repo);
    await provider.loadCurated();

    await Future.wait([provider.loadMore(), provider.loadMore()]);

    expect(repo.curatedCalls, [1, 2]);
  });

  test('a failed loadMore keeps the photos and waits for a retry', () async {
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
    final provider = PhotosProvider(repo);
    await provider.loadCurated();

    await provider.loadMore();
    expect(provider.loadMoreError, 'No internet');
    expect(provider.photos, hasLength(12));
    expect(provider.error, isNull);

    await provider.loadMore(); // scrolling again does not spam requests
    expect(repo.curatedCalls, [1, 2]);

    await provider.retryLoadMore();
    expect(provider.loadMoreError, isNull);
    expect(provider.photos, hasLength(24));
  });

  test('refreshing replaces the list and ignores an older loadMore', () async {
    final page2 = Completer<Result<PhotosPage>>();
    final repo = FakePhotoRepository(
      onCurated: (page) => page == 2 ? page2.future : pages(page),
    );
    final provider = PhotosProvider(repo);
    await provider.loadCurated();

    final more = provider.loadMore(); // still waiting for page 2...
    await provider.loadCurated(); // ...when the user pulls to refresh
    page2.complete(await pages(2));
    await more;

    expect(provider.photos, hasLength(12)); // page 2 was not appended
    expect(provider.isLoadingMore, isFalse);
  });

  test('a failed refresh keeps the photos already on screen', () async {
    var fail = false;
    final provider = PhotosProvider(
      FakePhotoRepository(
        onCurated: (page) async =>
            fail ? const Failure('No internet') : await pages(page),
      ),
    );
    await provider.loadCurated();

    fail = true;
    await provider.loadCurated();

    expect(provider.error, 'No internet');
    expect(provider.photos, hasLength(12));
  });
}
