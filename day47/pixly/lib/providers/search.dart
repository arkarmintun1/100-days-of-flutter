import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pixly/core/app_exception.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo_feed.dart';
import 'package:pixly/providers/cache_for.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

/// What the user typed ([text]) and the query that is searched ([query]).
/// They differ while the user is still typing.
typedef SearchInput = ({String text, String query});

/// The search box: waits for a short pause in typing before it sets [query].
@Riverpod(keepAlive: true)
class SearchQuery extends _$SearchQuery {
  static const debounce = Duration(milliseconds: 500);

  Timer? _timer;

  @override
  SearchInput build() {
    ref.onDispose(() => _timer?.cancel());
    return (text: '', query: '');
  }

  /// Call on every keystroke.
  void onChanged(String value) {
    _timer?.cancel();
    final text = value.trim();
    if (text.isEmpty) return clear();

    state = (text: text, query: state.query);
    if (text != state.query) {
      _timer = Timer(debounce, () => state = (text: text, query: text));
    }
  }

  /// Searches right away (keyboard search button, a recent search).
  void submit(String value) {
    _timer?.cancel();
    final text = value.trim();
    if (text.isEmpty) return;
    state = (text: text, query: text);
  }

  void clear() {
    _timer?.cancel();
    state = (text: '', query: '');
  }
}

/// The results for one [query], page by page.
///
/// One provider per query (a "family"). It is autoDispose: when the query
/// changes, nothing listens to the old one any more, so it is disposed and
/// its request is cancelled. Results that loaded are kept for
/// [cacheDuration] from when they loaded.
@riverpod
class SearchResults extends _$SearchResults {
  @override
  Future<PhotoFeed> build(String query) async {
    // The Ref of this build: after the await, `this.ref` may already be the
    // Ref of a newer build (see CuratedPhotos.loadMore).
    final ref = this.ref;
    final result = await ref
        .watch(photoRepositoryProvider)
        .search(query, cancelToken: _cancelOnDispose());
    switch (result) {
      case Success(:final data):
        // Going back to this query in the next 5 minutes shows these
        // results right away. Only results that loaded are kept: a request
        // that is still running is cancelled as before when the query
        // changes.
        if (ref.mounted) ref.cacheFor(cacheDuration);
        return PhotoFeed.firstPage(data);
      case Failure():
        throw result.exception;
    }
  }

  /// Loads the next page of results for this query.
  Future<void> loadMore() async {
    final feed = state.value;
    if (feed == null || state.isLoading || !feed.canLoadMore) return;

    final ref = this.ref; // see CuratedPhotos.loadMore
    state = AsyncData(feed.loadingMore());

    final result = await ref
        .read(photoRepositoryProvider)
        .search(query, page: feed.page + 1, cancelToken: _cancelOnDispose());
    if (!ref.mounted) return;

    state = AsyncData(switch (result) {
      Success(:final data) => feed.withNextPage(data),
      Failure(:final message) => feed.withLoadMoreError(message),
    });
  }

  Future<void> retryLoadMore() async {
    final feed = state.value;
    // Only after a failed page, and not while the first page reloads.
    if (feed == null || state.isLoading || feed.loadMoreError == null) return;
    state = AsyncData(feed.withoutLoadMoreError());
    await loadMore();
  }

  /// A CancelToken that is cancelled when this provider is disposed (or
  /// rebuilt), so Dio stops a request nobody is waiting for.
  CancelToken _cancelOnDispose() {
    final token = CancelToken();
    ref.onDispose(token.cancel);
    return token;
  }
}

/// The last searches that loaded (with or without photos), newest first.
@Riverpod(keepAlive: true)
class RecentSearches extends _$RecentSearches {
  static const max = 5;

  @override
  List<String> build() => const [];

  void add(String query) {
    state = [
      query,
      for (final q in state)
        if (q.toLowerCase() != query.toLowerCase()) q,
    ].take(max).toList();
  }

  void clear() => state = const [];
}
