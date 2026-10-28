import 'package:flutter/material.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/utils/color_utils.dart';
import 'package:pixly/utils/links.dart';
import 'package:pixly/widgets/photo_card.dart';
import 'package:pixly/widgets/photo_image.dart';

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = colorFromHex(photo.avgColor);

    return Scaffold(
      appBar: AppBar(title: const Text('Photo')),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: photo.aspectRatio,
            child: Hero(
              tag: photoHeroTag(photo),
              child: PhotoImage(
                url: photo.src.large2x,
                // Usually already loaded by the grid, so it can show right away.
                thumbnailUrl: photo.src.medium,
                placeholderColor: color,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 12,
              children: [
                Text(
                  photo.alt.isEmpty ? 'Untitled' : photo.alt,
                  style: textTheme.titleLarge,
                ),
                // Credit the photographer and link back to Pexels.
                InkWell(
                  onTap: () => openLink(context, photo.photographerUrl),
                  child: Text(
                    'Photo by ${photo.photographer} on Pexels',
                    style: textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.photo_size_select_large),
                      label: Text('${photo.width} × ${photo.height}'),
                    ),
                    Chip(
                      avatar: CircleAvatar(backgroundColor: color),
                      label: Text(photo.avgColor),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => openLink(context, photo.url),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('View on Pexels'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
