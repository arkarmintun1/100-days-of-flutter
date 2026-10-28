import 'package:flutter/foundation.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/repositories/photo_repository.dart';

/// Holds the curated photos and tells listeners when they change.
class PhotosProvider extends ChangeNotifier {
  PhotosProvider(this._repository);

  final PhotoRepository _repository;

  List<Photo> _photos = [];
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  List<Photo> get photos => List.unmodifiable(_photos);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurated() async {
    if (_isLoading) return; // already loading, ignore extra taps
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.curated();
    if (_disposed) return; // the screen went away while we were waiting

    switch (result) {
      case Success(:final data):
        _photos = data.photos;
      case Failure(:final message):
        _error = message;
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
