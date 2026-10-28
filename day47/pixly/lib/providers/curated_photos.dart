import 'package:pixly/core/app_exception.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo_feed.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'curated_photos.g.dart';

/// The curated photos on Home, page by page.
///
/// keepAlive: the feed stays loaded while the app runs (Day 46).
@Riverpod(keepAlive: true)
class CuratedPhotos extends _$CuratedPhotos {
  /// Loads page 1. Runs on the first read, and again after
  /// ref.invalidate / ref.refresh (Try again, pull to refresh).
  @override
  Future<PhotoFeed> build() async {
    final result = await ref.watch(photoRepositoryProvider).curated();
    return switch (result) {
      Success(:final data) => PhotoFeed.firstPage(data),
      // Throwing puts the provider in AsyncError.
      Failure() => throw result.exception,
    };
  }

  /// Loads the next page and adds it to the end of the feed.
  Future<void> loadMore() async {
    final feed = state.value;
    // Nothing yet, first page or a refresh still loading, or nothing to do.
    if (feed == null || state.isLoading || !feed.canLoadMore) return;

    // The Ref of the current build. If the provider is refreshed while we
    // wait, this ref is no longer mounted and the page is out of date.
    final ref = this.ref;
    state = AsyncData(feed.loadingMore());

    final result = await ref
        .read(photoRepositoryProvider)
        .curated(page: feed.page + 1);
    if (!ref.mounted) return;

    state = AsyncData(switch (result) {
      Success(:final data) => feed.withNextPage(data),
      Failure(:final message) => feed.withLoadMoreError(message),
    });
  }

  Future<void> retryLoadMore() async {
    final feed = state.value;
    // Only after a failed page, and not while a refresh is running.
    if (feed == null || state.isLoading || feed.loadMoreError == null) return;
    state = AsyncData(feed.withoutLoadMoreError());
    await loadMore();
  }

  /// Pull to refresh: loads page 1 again. The photos on screen stay until
  /// the new page arrives - and also if the refresh fails.
  Future<void> refresh() async {
    // A next page that is still loading (or failed) belongs to the old
    // feed. Clear it first: a failed refresh keeps the feed as it is now,
    // and a "loading more" that never ends would block pagination.
    if (state.value case final feed?) {
      state = AsyncData(feed.withoutPendingPage());
    }
    // Runs build() again, like ref.invalidate(curatedPhotosProvider).
    ref.invalidateSelf();
    // Completes with the new first page, or throws if it failed.
    await future;
  }
}
