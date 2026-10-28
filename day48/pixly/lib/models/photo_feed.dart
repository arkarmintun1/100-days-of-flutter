import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photo_list.dart';
import 'package:pixly/models/photos_page.dart';

part 'photo_feed.freezed.dart';

/// Everything the Home grid shows: the photos loaded so far and the state
/// of the next page. Immutable: every change makes a new PhotoFeed.
@freezed
abstract class PhotoFeed with _$PhotoFeed {
  const PhotoFeed._();

  const factory PhotoFeed({
    required List<Photo> photos,
    required int page,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
    String? loadMoreError,

    /// True when page 1 couldn't be loaded and these are the photos saved
    /// on the device last time (Day 48).
    @Default(false) bool isStale,
  }) = _PhotoFeed;

  /// The feed after the first page arrives.
  factory PhotoFeed.firstPage(PhotosPage page) =>
      PhotoFeed(photos: page.photos, page: page.page, hasMore: page.hasMore);

  /// The photos and page saved on the device by Riverpod's offline
  /// persistence. Loading state and errors are not saved.
  factory PhotoFeed.fromSavedJson(Map<String, dynamic> json) => PhotoFeed(
    photos: [
      for (final photo in json['photos'] as List<dynamic>)
        Photo.fromJson(photo as Map<String, dynamic>),
    ],
    page: json['page'] as int,
    hasMore: json['has_more'] as bool,
  );

  Map<String, dynamic> toSavedJson() => {
    'photos': [for (final photo in photos) photo.toJson()],
    'page': page,
    'has_more': hasMore,
  };

  /// Whether loadMore() should ask for the next page now.
  bool get canLoadMore => hasMore && !isLoadingMore && loadMoreError == null;

  /// The already-loaded photo with this [id], if any.
  Photo? photoById(int id) {
    for (final photo in photos) {
      if (photo.id == id) return photo;
    }
    return null;
  }

  PhotoFeed loadingMore() => copyWith(isLoadingMore: true, loadMoreError: null);

  PhotoFeed withNextPage(PhotosPage next) => copyWith(
    photos: photos.plusNew(next.photos),
    page: next.page,
    hasMore: next.hasMore,
    isLoadingMore: false,
  );

  PhotoFeed withLoadMoreError(String message) =>
      copyWith(isLoadingMore: false, loadMoreError: message);

  PhotoFeed withoutLoadMoreError() => copyWith(loadMoreError: null);

  /// No next page loading or failed: what a refresh starts from.
  PhotoFeed withoutPendingPage() =>
      copyWith(isLoadingMore: false, loadMoreError: null);
}
