import 'package:flutter/material.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:shimmer/shimmer.dart';

/// Grey placeholder tiles with a moving shine, shown while photos load.
class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.pixlyColors;

    return Shimmer.fromColors(
      baseColor: colors.shimmerBase,
      highlightColor: colors.shimmerHighlight,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: photoGridDelegate,
        itemBuilder: (context, index) => DecoratedBox(
          decoration: BoxDecoration(
            // Any opaque colour works: Shimmer paints its gradient over it.
            color: colors.shimmerBase,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
