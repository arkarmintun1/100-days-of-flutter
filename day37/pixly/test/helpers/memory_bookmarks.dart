import 'package:flutter/widgets.dart';
import 'package:pixly/providers/bookmarks_provider.dart';
import 'package:pixly/storage/bookmarks_storage.dart';
import 'package:provider/provider.dart';

/// Keeps bookmarks in a list instead of on the device.
class MemoryBookmarksStorage implements BookmarksStorage {
  MemoryBookmarksStorage([List<String>? items]) : items = items ?? [];

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

/// Puts a BookmarksProvider (in memory) above [child].
Widget withBookmarks(Widget child, {BookmarksProvider? bookmarks}) {
  return ChangeNotifierProvider.value(
    value: bookmarks ?? BookmarksProvider(MemoryBookmarksStorage()),
    child: child,
  );
}
