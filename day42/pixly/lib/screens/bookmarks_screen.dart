import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/providers/bookmarks_notifier.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:pixly/widgets/photo_grid.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: photos.isEmpty
          ? const EmptyState(
              title: 'No bookmarks yet',
              message: 'Tap the bookmark icon on a photo to save it here.',
            )
          : PhotoGrid(
              photos: photos,
              onPhotoTap: (photo) =>
                  context.go(AppRoutes.bookmarkPhoto(photo.id), extra: photo),
            ),
    );
  }
}
