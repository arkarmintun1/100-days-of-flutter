import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Shows a network photo with disk caching, a colour placeholder while it
/// loads, and a fallback icon if it fails.
class PhotoImage extends StatelessWidget {
  const PhotoImage({
    super.key,
    required this.url,
    required this.placeholderColor,
    this.thumbnailUrl,
    this.fit = BoxFit.cover,
  });

  final String url;
  final Color placeholderColor;

  /// A smaller image (usually already cached) to show while [url] loads.
  final String? thumbnailUrl;
  final BoxFit fit;

  /// Tests swap this to serve local files instead of downloading.
  @visibleForTesting
  static BaseCacheManager? cacheManagerOverride;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: cacheManagerOverride,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => thumbnailUrl == null
          ? ColoredBox(color: placeholderColor)
          : PhotoImage(
              url: thumbnailUrl!,
              placeholderColor: placeholderColor,
              fit: fit,
            ),
      errorWidget: (context, url, error) => ColoredBox(
        color: placeholderColor,
        child: const Center(child: Icon(Icons.broken_image_outlined)),
      ),
    );
  }
}
