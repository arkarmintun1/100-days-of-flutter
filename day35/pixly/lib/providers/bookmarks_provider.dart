import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/storage/bookmarks_storage.dart';

/// The photos the user bookmarked, newest first, saved on the device.
class BookmarksProvider extends ChangeNotifier {
  BookmarksProvider(this._storage) {
    _photos = _load();
  }

  final BookmarksStorage _storage;
  List<Photo> _photos = [];

  List<Photo> get photos => List.unmodifiable(_photos);

  bool isBookmarked(int id) => _photos.any((photo) => photo.id == id);

  /// Bookmarks [photo], or removes it if it is already bookmarked.
  ///
  /// Returns false if saving failed. The change still shows in the app, and
  /// because every save writes the whole list, the next successful save
  /// stores it too.
  Future<bool> toggle(Photo photo) async {
    _photos = isBookmarked(photo.id) ? _without(photo.id) : [photo, ..._photos];
    // Update the UI right away, then save in the background.
    notifyListeners();

    try {
      await _storage.write([
        for (final photo in _photos) jsonEncode(photo.toJson()),
      ]);
      return true;
    } on Exception {
      return false;
    }
  }

  List<Photo> _without(int id) => _photos.where((p) => p.id != id).toList();

  List<Photo> _load() {
    final photos = <Photo>[];
    for (final item in _storage.read()) {
      try {
        photos.add(Photo.fromJson(jsonDecode(item) as Map<String, dynamic>));
      } on FormatException {
        // Not valid JSON: skip it instead of losing every bookmark.
      } on TypeError {
        // Valid JSON, but not the shape of a Photo: skip it too.
      }
    }
    return photos;
  }
}
