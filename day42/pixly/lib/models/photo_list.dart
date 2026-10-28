import 'package:pixly/models/photo.dart';

extension PhotoListX on List<Photo> {
  /// This list followed by the photos in [more] that it doesn't have yet.
  ///
  /// Pexels' lists can change between two page requests, so a new page
  /// may repeat photos we already show. Duplicates would also break the
  /// Hero tags, which must be unique on a screen.
  List<Photo> plusNew(Iterable<Photo> more) {
    final ids = {for (final photo in this) photo.id};
    return [...this, ...more.where((photo) => ids.add(photo.id))];
  }
}
