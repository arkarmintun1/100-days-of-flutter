import 'package:flutter/material.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/widgets/photo_card.dart';

/// The grid layout shared by the photo grid and its shimmer skeleton.
///
/// Tiles are about 240 wide (the delegate picks enough columns for that),
/// so the number of columns follows the space: 2 on a phone, more on a
/// tablet or desktop.
const photoGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 240,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  childAspectRatio: 0.75,
);

class PhotoGrid extends StatefulWidget {
  const PhotoGrid({
    super.key,
    required this.photos,
    this.onLoadMore,
    this.onPhotoTap,
    this.headerSlivers = const [],
  });

  final List<Photo> photos;

  /// Called with the photo the user tapped.
  final ValueChanged<Photo>? onPhotoTap;

  /// Called when the user scrolls close to the end of the grid.
  final VoidCallback? onLoadMore;

  /// Slivers shown above the photos (e.g. a SliverAppBar). They scroll
  /// together with the grid as one list.
  final List<Widget> headerSlivers;

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  /// Start loading when less than this many pixels are left below.
  static const _loadMoreThreshold = 600.0;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _checkAfterLayout();
  }

  @override
  void didUpdateWidget(PhotoGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // New data arrived (maybe a page that only had photos we already had),
    // so check again whether the screen is full.
    _checkAfterLayout();
  }

  void _onScroll() {
    final position = _controller.position;
    // Before the first layout (e.g. in a tab that isn't visible yet) the
    // grid's size is unknown, so there is nothing to measure.
    if (!position.hasContentDimensions) return;
    if (position.extentAfter < _loadMoreThreshold) {
      widget.onLoadMore?.call();
    }
  }

  /// If the photos don't fill the screen (a tall tablet, a short page), the
  /// user can't scroll, so the listener above never runs. Check once after
  /// the grid has been laid out.
  void _checkAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.hasClients) _onScroll();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      // Lets RefreshIndicator work even when the photos don't fill the screen.
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        ...widget.headerSlivers,
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid.builder(
            itemCount: widget.photos.length,
            gridDelegate: photoGridDelegate,
            itemBuilder: (context, index) {
              final photo = widget.photos[index];
              return PhotoCard(
                photo: photo,
                onTap: widget.onPhotoTap == null
                    ? null
                    : () => widget.onPhotoTap!(photo),
              );
            },
          ),
        ),
      ],
    );
  }
}
