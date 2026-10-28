import 'package:flutter/foundation.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photo_list.dart';
import 'package:pixly/models/photos_page.dart';

/// Everything the Home grid shows: the photos loaded so far and the state
/// of the next page. Immutable: every change makes a new PhotoFeed.
@immutable
class PhotoFeed {
  const PhotoFeed({
    required this.photos,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  /// The feed after the first page arrives.
  factory PhotoFeed.firstPage(PhotosPage page) =>
      PhotoFeed(photos: page.photos, page: page.page, hasMore: page.hasMore);

  final List<Photo> photos;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  /// Whether loadMore() should ask for the next page now.
  bool get canLoadMore => hasMore && !isLoadingMore && loadMoreError == null;

  /// The already-loaded photo with this [id], if any.
  Photo? photoById(int id) {
    for (final photo in photos) {
      if (photo.id == id) return photo;
    }
    return null;
  }

  PhotoFeed loadingMore() => PhotoFeed(
    photos: photos,
    page: page,
    hasMore: hasMore,
    isLoadingMore: true,
  );

  PhotoFeed withNextPage(PhotosPage next) => PhotoFeed(
    photos: photos.plusNew(next.photos),
    page: next.page,
    hasMore: next.hasMore,
  );

  PhotoFeed withLoadMoreError(String message) => PhotoFeed(
    photos: photos,
    page: page,
    hasMore: hasMore,
    loadMoreError: message,
  );

  PhotoFeed withoutLoadMoreError() =>
      PhotoFeed(photos: photos, page: page, hasMore: hasMore);

  /// No next page loading or failed: what a refresh starts from.
  PhotoFeed withoutPendingPage() =>
      PhotoFeed(photos: photos, page: page, hasMore: hasMore);
}
