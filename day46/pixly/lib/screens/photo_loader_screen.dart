import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixly/core/app_exception.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/curated_photos.dart';
import 'package:pixly/providers/photo_by_id.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/widgets/error_view.dart';
import 'package:pixly/widgets/pexels_link.dart';

/// Shows [PhotoDetailScreen] for photo [id].
///
/// Coming from the grid we already have the [Photo] (passed as `extra`).
/// Opened from a link, we look for it in the loaded photos and, if it's not
/// there, ask Pexels for it with [photoByIdProvider].
class PhotoLoaderScreen extends ConsumerWidget {
  const PhotoLoaderScreen({super.key, required this.id, this.photo});

  final int id;
  final Photo? photo;

  /// The photo from Home's feed - but only if the feed was already loaded:
  /// reading curatedPhotosProvider would otherwise start loading it.
  Photo? _loadedPhoto(WidgetRef ref) {
    if (!ref.exists(curatedPhotosProvider)) return null;
    return ref.read(curatedPhotosProvider).value?.photoById(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final known = photo ?? _loadedPhoto(ref);
    if (known != null) return PhotoDetailScreen(photo: known);

    final provider = photoByIdProvider(id);
    return switch (ref.watch(provider)) {
      AsyncData(:final value) => PhotoDetailScreen(photo: value),
      // After "Try again" it stays an AsyncError (isLoading: true) until
      // the new result arrives: show the spinner meanwhile.
      AsyncError(:final error, isLoading: false) => Scaffold(
        appBar: AppBar(actions: const [PexelsLink()]),
        body: ErrorView(
          kind: AppException.from(error).kind,
          message: AppException.from(error).message,
          onRetry: () => ref.invalidate(provider),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(actions: const [PexelsLink()]),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}
