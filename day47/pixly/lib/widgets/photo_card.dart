import 'package:flutter/material.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/utils/color_utils.dart';
import 'package:pixly/widgets/bookmark_button.dart';
import 'package:pixly/widgets/photo_image.dart';

/// The same tag on the grid card and the detail screen links the two images
/// for the Hero animation. It must be unique on each screen.
String photoHeroTag(Photo photo) => 'photo-${photo.id}';

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key, required this.photo, this.onTap});

  final Photo photo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final overlay = context.pixlyColors.photoOverlay;

    return Card(
      margin: EdgeInsets.zero,
      child: Stack(
        fit: .expand,
        children: [
          Hero(
            tag: photoHeroTag(photo),
            child: PhotoImage(
              url: photo.src.medium,
              placeholderColor: colorFromHex(photo.avgColor),
            ),
          ),
          // Dark gradient at the bottom so the white name is readable.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  colors: [overlay.withValues(alpha: 0), overlay],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
                child: Text(
                  photo.photographer,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: .w600,
                  ),
                ),
              ),
            ),
          ),
          // On top of everything so the ripple shows over the photo.
          Positioned.fill(
            child: Material(
              type: .transparency,
              child: InkWell(onTap: onTap),
            ),
          ),
          // After the InkWell so it sits above it and gets its own taps.
          Positioned(
            top: 4,
            right: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(color: overlay, shape: .circle),
              child: BookmarkButton(photo: photo, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
