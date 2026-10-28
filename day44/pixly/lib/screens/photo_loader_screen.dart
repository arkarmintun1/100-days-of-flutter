import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/providers/curated_photos.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/widgets/error_view.dart';
import 'package:pixly/widgets/pexels_link.dart';

/// Shows [PhotoDetailScreen] for photo [id].
///
/// Coming from the grid we already have the [Photo] (passed as `extra`).
/// Opened from a link, we look for it in the loaded photos and, if it's not
/// there, ask Pexels for it.
class PhotoLoaderScreen extends ConsumerStatefulWidget {
  const PhotoLoaderScreen({super.key, required this.id, this.photo});

  final int id;
  final Photo? photo;

  @override
  ConsumerState<PhotoLoaderScreen> createState() => _PhotoLoaderScreenState();
}

class _PhotoLoaderScreenState extends ConsumerState<PhotoLoaderScreen> {
  Photo? _photo;
  Future<Result<Photo>>? _request;

  @override
  void initState() {
    super.initState();
    _photo = widget.photo ?? _loadedPhoto();
    // Create the Future once, not in build(), so rebuilds don't refetch.
    if (_photo == null) {
      // ref is available in initState: read once, don't listen.
      _request = ref.read(photoRepositoryProvider).photo(widget.id);
    }
  }

  /// The photo from Home's feed - but only if the feed was already loaded:
  /// reading curatedPhotosProvider would otherwise start loading it.
  Photo? _loadedPhoto() {
    if (!ref.exists(curatedPhotosProvider)) return null;
    return ref.read(curatedPhotosProvider).value?.photoById(widget.id);
  }

  void _retry() {
    setState(() {
      _request = ref.read(photoRepositoryProvider).photo(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photo;
    if (photo != null) return PhotoDetailScreen(photo: photo);

    return FutureBuilder(
      future: _request,
      builder: (context, snapshot) {
        // After "Try again" the snapshot still holds the old Failure while
        // the new request runs, so only use data from a finished Future.
        final result = snapshot.connectionState == ConnectionState.done
            ? snapshot.data
            : null;
        return switch (result) {
          Success(:final data) => PhotoDetailScreen(photo: data),
          Failure(:final message, :final kind) => Scaffold(
            appBar: AppBar(actions: const [PexelsLink()]),
            body: ErrorView(kind: kind, message: message, onRetry: _retry),
          ),
          null => Scaffold(
            appBar: AppBar(actions: const [PexelsLink()]),
            body: const Center(child: CircularProgressIndicator()),
          ),
        };
      },
    );
  }
}
