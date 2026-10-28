import 'package:flutter/material.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/repositories/photo_repository.dart';
import 'package:pixly/screens/photo_detail_screen.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:provider/provider.dart';

/// Shows [PhotoDetailScreen] for photo [id].
///
/// Coming from the grid we already have the [Photo] (passed as `extra`).
/// Opened from a link, we look for it in the loaded photos and, if it's not
/// there, ask Pexels for it.
class PhotoLoaderScreen extends StatefulWidget {
  const PhotoLoaderScreen({super.key, required this.id, this.photo});

  final int id;
  final Photo? photo;

  @override
  State<PhotoLoaderScreen> createState() => _PhotoLoaderScreenState();
}

class _PhotoLoaderScreenState extends State<PhotoLoaderScreen> {
  Photo? _photo;
  Future<Result<Photo>>? _request;

  @override
  void initState() {
    super.initState();
    _photo =
        widget.photo ?? context.read<PhotosProvider>().photoById(widget.id);
    // Create the Future once, not in build(), so rebuilds don't refetch.
    if (_photo == null) {
      _request = context.read<PhotoRepository>().photo(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photo;
    if (photo != null) return PhotoDetailScreen(photo: photo);

    return FutureBuilder(
      future: _request,
      builder: (context, snapshot) {
        return switch (snapshot.data) {
          Success(:final data) => PhotoDetailScreen(photo: data),
          Failure(:final message) => Scaffold(
            appBar: AppBar(),
            body: EmptyState(title: 'Photo not available', message: message),
          ),
          null => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
        };
      },
    );
  }
}
