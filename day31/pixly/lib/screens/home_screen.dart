import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixly/config/assets.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/utils/links.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/shimmer_grid.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 12,
          children: [
            SvgPicture.asset(AppAssets.logo, width: 32, height: 32),
            const Flexible(
              child: Text(AppConstants.appName, overflow: .ellipsis),
            ),
          ],
        ),
        actions: [
          // Pexels asks apps using its API to show a prominent link back.
          TextButton(
            onPressed: () => openLink(context, AppConstants.pexelsUrl),
            child: const Text('Photos by Pexels'),
          ),
        ],
      ),
      body: const _PhotosBody(),
    );
  }
}

class _PhotosBody extends StatelessWidget {
  const _PhotosBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhotosProvider>();
    final photos = provider.photos;

    if (provider.isLoading && photos.isEmpty) {
      return const ShimmerGrid();
    }

    if (provider.error != null && photos.isEmpty) {
      return EmptyState(
        title: 'Something went wrong',
        message: provider.error!,
        action: FilledButton.icon(
          onPressed: () => context.read<PhotosProvider>().loadCurated(),
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      );
    }

    if (photos.isEmpty) {
      return EmptyState(
        title: 'No photos yet',
        message: 'Beautiful photos from Pexels will show up here soon.',
        action: FilledButton.icon(
          onPressed: () => context.read<PhotosProvider>().loadCurated(),
          icon: const Icon(Icons.refresh),
          label: const Text('Reload'),
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: PhotoGrid(
            photos: photos,
            onLoadMore: context.read<PhotosProvider>().loadMore,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: Center(child: _LoadMoreStatus(provider: provider)),
        ),
      ],
    );
  }

  Future<void> _refresh(BuildContext context) async {
    final provider = context.read<PhotosProvider>();

    await provider.loadCurated();

    // The screen may be gone by the time the request finishes.
    if (!context.mounted) return;

    // The old photos are still on screen, so show the error in a SnackBar.
    if (provider.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.error!)));
    }
  }
}

/// Small floating status at the bottom: a spinner while the next page loads,
/// or a retry button if it failed.
class _LoadMoreStatus extends StatelessWidget {
  const _LoadMoreStatus({required this.provider});

  final PhotosProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.loadMoreError != null) {
      return FilledButton.tonalIcon(
        onPressed: provider.retryLoadMore,
        icon: const Icon(Icons.refresh),
        label: const Text("Couldn't load more. Retry"),
      );
    }

    if (provider.isLoadingMore) {
      return const Card(
        shape: CircleBorder(),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
