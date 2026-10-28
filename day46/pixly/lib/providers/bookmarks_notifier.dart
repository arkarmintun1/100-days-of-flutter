import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/storage/bookmarks_storage.dart';

/// The bookmarked photos, newest first, saved on the device.
final bookmarksProvider = NotifierProvider<BookmarksNotifier, List<Photo>>(
  BookmarksNotifier.new,
);

class BookmarksNotifier extends Notifier<List<Photo>> {
  @override
  List<Photo> build() => _load(ref.watch(bookmarksStorageProvider));

  bool isBookmarked(int id) => state.any((photo) => photo.id == id);

  /// Bookmarks [photo], or removes it if it is already bookmarked.
  ///
  /// Returns false if saving failed. The change still shows in the app, and
  /// because every save writes the whole list, the next successful save
  /// stores it too.
  Future<bool> toggle(Photo photo) async {
    final storage = ref.read(bookmarksStorageProvider);

    // Never change the list in place (state.add/remove): give Riverpod a
    // new list, so it can see that the state changed.
    state = isBookmarked(photo.id)
        ? [
            for (final p in state)
              if (p.id != photo.id) p,
          ]
        : [photo, ...state];

    try {
      await storage.write([
        for (final photo in state) jsonEncode(photo.toJson()),
      ]);
      return true;
    } on Exception {
      return false;
    }
  }

  static List<Photo> _load(BookmarksStorage storage) {
    final photos = <Photo>[];
    for (final item in storage.read()) {
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
