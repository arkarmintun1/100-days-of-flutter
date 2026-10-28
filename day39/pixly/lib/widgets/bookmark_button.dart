import 'package:flutter/material.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/bookmarks_provider.dart';
import 'package:provider/provider.dart';

/// A bookmark icon that fills in when [photo] is bookmarked.
class BookmarkButton extends StatelessWidget {
  const BookmarkButton({super.key, required this.photo, this.color});

  final Photo photo;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when *this* photo's bookmark state changes.
    final isBookmarked = context.select<BookmarksProvider, bool>(
      (bookmarks) => bookmarks.isBookmarked(photo.id),
    );

    return IconButton(
      tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
      color: color,
      icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      onPressed: () async {
        // Read these before the await: on the Bookmarks tab this button is
        // removed from the tree as soon as the bookmark is removed.
        final bookmarks = context.read<BookmarksProvider>();
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
