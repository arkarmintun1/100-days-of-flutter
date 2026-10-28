import 'dart:convert';

import 'package:pixly/models/photo.dart';
import 'package:pixly/storage/bookmarks_storage.dart';

/// Keeps bookmarks in a list instead of on the device.
class MemoryBookmarksStorage implements BookmarksStorage {
  MemoryBookmarksStorage([List<String>? items]) : items = items ?? [];

  /// Already holds [photos] (first = newest), like after a restart.
  MemoryBookmarksStorage.withPhotos(List<Photo> photos)
    : items = [for (final photo in photos) jsonEncode(photo.toJson())];

  List<String> items;
  int writes = 0;

  /// When true, every write fails like a full disk would.
  bool failWrites = false;

  /// Called at the start of every write (to check the order of events).
  void Function()? onWrite;

  @override
  List<String> read() => List.of(items);

  @override
  Future<void> write(List<String> items) async {
    onWrite?.call();
    writes++;
    if (failWrites) throw Exception('Could not write to storage');
    this.items = List.of(items);
  }
}
