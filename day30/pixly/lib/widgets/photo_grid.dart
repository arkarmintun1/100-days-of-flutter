import 'package:flutter/material.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/widgets/photo_card.dart';

/// The grid layout shared by the photo grid and its shimmer skeleton.
const photoGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  childAspectRatio: 0.75,
);

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key, required this.photos});

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: photos.length,
      gridDelegate: photoGridDelegate,
      itemBuilder: (context, index) => PhotoCard(photo: photos[index]),
    );
  }
}
