import 'package:flutter/foundation.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/repositories/photo_repository.dart';

/// Holds the curated photos, page by page, and tells listeners when they
/// change.
class PhotosProvider extends ChangeNotifier {
  PhotosProvider(this._repository);

  final PhotoRepository _repository;

  List<Photo> _photos = [];
  int _page = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String? _loadMoreError;
  int _generation = 0;
  bool _disposed = false;

  List<Photo> get photos => List.unmodifiable(_photos);
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  String? get loadMoreError => _loadMoreError;

  /// The already-loaded photo with this [id], if any.
  Photo? photoById(int id) {
    for (final photo in _photos) {
      if (photo.id == id) return photo;
    }
    return null;
  }

  /// Loads page 1. Used for the first load, "Try again" and pull-to-refresh.
  Future<void> loadCurated() async {
    if (_isLoading) return;
    _generation++; // a loadMore() that is still running is now out of date
    _isLoading = true;
    _isLoadingMore = false;
    _error = null;
    _loadMoreError = null;
    notifyListeners();

    final result = await _repository.curated();
    if (_disposed) return;

    switch (result) {
      case Success(:final data):
        _photos = data.photos;
        _page = data.page;
        _hasMore = data.hasMore;
      case Failure(:final message):
        _error = message; // photos we already had stay on screen
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Loads the next page and adds it to the end of [photos].
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore || _photos.isEmpty) return;
    if (_loadMoreError != null) return; // wait for retryLoadMore()

    final generation = _generation;
    _isLoadingMore = true;
    notifyListeners();

    final result = await _repository.curated(page: _page + 1);
    if (_disposed || generation != _generation) return;

    switch (result) {
      case Success(:final data):
        // The curated list can change between requests, so skip photos
        // we already have.
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

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
