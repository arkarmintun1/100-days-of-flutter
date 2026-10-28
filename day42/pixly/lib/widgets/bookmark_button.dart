import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/bookmarks_notifier.dart';

/// A bookmark icon that fills in when [photo] is bookmarked.
class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.photo, this.color});

  final Photo photo;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuilds only when *this* photo's bookmark state changes.
    final isBookmarked = ref.watch(
      bookmarksProvider.select(
        (photos) => photos.any((p) => p.id == photo.id),
      ),
    );

    return IconButton(
      tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
      color: color,
      icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      onPressed: () async {
        // Read these before the await: on the Bookmarks tab this button is
        // removed from the tree as soon as the bookmark is removed.
        final bookmarks = ref.read(bookmarksProvider.notifier);
        final messenger = ScaffoldMessenger.of(context);

        final saved = await bookmarks.toggle(photo);
        if (!saved) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                "Couldn't save your bookmarks. Recent changes may be lost "
                'when you close Pixly.',
              ),
            ),
          );
        }
      },
    );
  }
}
