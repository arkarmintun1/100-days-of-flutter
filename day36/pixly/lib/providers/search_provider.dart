import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/repositories/photo_repository.dart';

/// Searches Pexels as the user types, waiting for a short pause first.
class SearchProvider extends ChangeNotifier {
  SearchProvider(this._repository, {this.debounce = defaultDebounce});

  static const defaultDebounce = Duration(milliseconds: 500);
  static const maxRecentSearches = 5;

  final PhotoRepository _repository;

  /// How long typing has to pause before a request is sent.
  final Duration debounce;

  Timer? _debounceTimer;
  String _query = '';
  List<Photo> _photos = [];
  int _page = 0;
  bool _hasMore = false;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _requestSent = false; // page 1 of the current query was requested
  bool _loaded = false; // page 1 of the current query arrived successfully
  String? _error;
  String? _loadMoreError;
  final List<String> _recentSearches = [];
  int _generation = 0;
  bool _disposed = false;

  /// The query being searched or shown ('' = nothing searched).
  String get query => _query;
  List<Photo> get photos => List.unmodifiable(_photos);
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  String? get loadMoreError => _loadMoreError;
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  /// Call on every keystroke. The request is only sent after [debounce]
  /// passes with no new keystroke.
  void onQueryChanged(String text) {
    _debounceTimer?.cancel();
    final query = text.trim();

    if (query.isEmpty) {
      clear();
      return;
    }

    // A new query: show loading now and ignore answers to older queries.
    if (query != _query) _startQuery(query);

    if (!_requestSent) {
      _debounceTimer = Timer(debounce, _fetchFirstPage);
    }
  }

  /// Searches right away, e.g. when the user presses the keyboard's
  /// search button or taps a recent search.
  Future<void> search(String text) async {
    _debounceTimer?.cancel();
    final query = text.trim();
    if (query.isEmpty) return;

    if (query != _query) {
      _startQuery(query);
    } else if (_requestSent && _error == null) {
      return; // already loading or showing results for this query
    }

    await _fetchFirstPage();
  }

  void _startQuery(String query) {
    _generation++; // answers to older queries are now out of date
    _query = query;
    _photos = [];
    _page = 0;
    _hasMore = false;
    _isLoading = true;
    _isLoadingMore = false;
    _requestSent = false;
    _loaded = false;
    _error = null;
    _loadMoreError = null;
    notifyListeners();
  }

  Future<void> _fetchFirstPage() async {
    final generation = _generation;
    final query = _query;
    _requestSent = true;
    if (!_isLoading || _error != null) {
      _isLoading = true; // e.g. "Try again" after an error
      _error = null;
      notifyListeners();
    }

    final result = await _repository.search(query);

    // The user typed something else while we were waiting.
    if (_disposed || generation != _generation) return;

    switch (result) {
      case Success(:final data):
        _photos = data.photos;
        _page = data.page;
        _hasMore = data.hasMore;
        _loaded = true;
        _addRecentSearch(query);
      case Failure(:final message):
        _error = message;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Loads the next page of results for the current query.
  Future<void> loadMore() async {
    if (!_loaded || _isLoadingMore || !_hasMore) return;
    if (_loadMoreError != null) return; // wait for retryLoadMore()

    final generation = _generation;
    _isLoadingMore = true;
    notifyListeners();

    final result = await _repository.search(_query, page: _page + 1);
    if (_disposed || generation != _generation) return;

    switch (result) {
      case Success(:final data):
        final ids = _photos.map((photo) => photo.id).toSet();
        _photos = [
          ..._photos,
          ...data.photos.where((photo) => ids.add(photo.id)),
        ];
        _page = data.page;
        _hasMore = data.hasMore;
      case Failure(:final message):
        _loadMoreError = message;
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> retryLoadMore() {
    _loadMoreError = null;
    return loadMore();
  }

  /// Clears the query and results (recent searches stay).
  void clear() {
    _debounceTimer?.cancel();
    _generation++; // ignore a request that is still running
    _query = '';
    _photos = [];
    _page = 0;
    _hasMore = false;
    _isLoading = false;
    _isLoadingMore = false;
    _requestSent = false;
    _loaded = false;
    _error = null;
    _loadMoreError = null;
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  void _addRecentSearch(String query) {
    _recentSearches.removeWhere((q) => q.toLowerCase() == query.toLowerCase());
    _recentSearches.insert(0, query);
    if (_recentSearches.length > maxRecentSearches) {
      _recentSearches.removeLast();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }
}
