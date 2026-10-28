import 'package:flutter/material.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/utils/color_utils.dart';
import 'package:pixly/widgets/photo_image.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    final overlay = context.pixlyColors.photoOverlay;

    return Card(
      margin: EdgeInsets.zero,
      child: Stack(
        fit: .expand,
        children: [
          PhotoImage(
            url: photo.src.medium,
            placeholderColor: colorFromHex(photo.avgColor),
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
        ],
      ),
    );
  }
}
