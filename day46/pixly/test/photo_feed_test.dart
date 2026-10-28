import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/models/photo_feed.dart';
import 'package:pixly/models/photos_page.dart';

import 'helpers/fake_adapter.dart';

PhotosPage page(String name) => PhotosPage.fromJson(FakeAdapter.fixture(name));

void main() {
  test('two feeds with the same data are equal', () {
    final a = PhotoFeed.firstPage(page('curated_page1'));
    final b = PhotoFeed.firstPage(page('curated_page1'));
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('loading the next page appends it and clears the loading flag', () {
    final feed = PhotoFeed.firstPage(page('curated_page1')).loadingMore();
    expect(feed.isLoadingMore, isTrue);
    expect(feed.canLoadMore, isFalse);

    final next = feed.withNextPage(page('curated_page2'));
    expect(next.photos, hasLength(24));
    expect(next.page, 2);
    expect(next.isLoadingMore, isFalse);
  });

  test('copyWith can set the error back to null', () {
    final failed = PhotoFeed.firstPage(
      page('curated_page1'),
    ).loadingMore().withLoadMoreError('No connection');
    expect(failed.loadMoreError, 'No connection');
    expect(failed.isLoadingMore, isFalse);

    final cleared = failed.withoutLoadMoreError();
    expect(cleared.loadMoreError, isNull);
    expect(cleared.canLoadMore, isTrue);
    expect(cleared, PhotoFeed.firstPage(page('curated_page1')));
  });
}
