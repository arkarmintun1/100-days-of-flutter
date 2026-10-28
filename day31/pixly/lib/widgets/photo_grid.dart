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

class PhotoGrid extends StatefulWidget {
  const PhotoGrid({super.key, required this.photos, this.onLoadMore});

  final List<Photo> photos;

  /// Called when the user scrolls close to the end of the grid.
  final VoidCallback? onLoadMore;

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
    return GridView.builder(
      controller: _controller,
      // Lets RefreshIndicator work even when the photos don't fill the screen.
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: widget.photos.length,
      gridDelegate: photoGridDelegate,
      itemBuilder: (context, index) => PhotoCard(photo: widget.photos[index]),
    );
  }
}
