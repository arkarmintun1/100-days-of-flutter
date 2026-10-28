import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/config/assets.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/utils/links.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:pixly/widgets/load_more_status.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/shimmer_grid.dart';
import 'package:pixly/widgets/theme_mode_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No Scaffold.appBar: the app bar is a sliver inside the scroll view.
    return const Scaffold(body: _PhotosBody());
  }
}

/// A large title that shrinks into a normal app bar as the user scrolls.
class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
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
        const ThemeModeButton(),
      ],
    );
  }
}

/// A normal widget placed between the app bar and the grid.
class _CuratedIntro extends StatelessWidget {
  const _CuratedIntro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Text(
          'Curated by the Pexels team',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
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
      return const CustomScrollView(
        slivers: [
          _HomeAppBar(),
          // Fills the rest of the screen with the shimmer skeleton.
          SliverFillRemaining(child: ShimmerGrid()),
        ],
      );
    }

    if (provider.error != null && photos.isEmpty) {
      return _MessageView(
        child: EmptyState(
          title: 'Something went wrong',
          message: provider.error!,
          action: FilledButton.icon(
            onPressed: () => context.read<PhotosProvider>().loadCurated(),
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ),
      );
    }

    if (photos.isEmpty) {
      return _MessageView(
        child: EmptyState(
          title: 'No photos yet',
          message: 'Beautiful photos from Pexels will show up here soon.',
          action: FilledButton.icon(
            onPressed: () => context.read<PhotosProvider>().loadCurated(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
          ),
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: PhotoGrid(
            headerSlivers: const [_HomeAppBar(), _CuratedIntro()],
            photos: photos,
            onLoadMore: context.read<PhotosProvider>().loadMore,
            onPhotoTap: (photo) => _openDetail(context, photo),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: Center(
            child: LoadMoreStatus(
              isLoadingMore: provider.isLoadingMore,
              error: provider.loadMoreError,
              onRetry: provider.retryLoadMore,
            ),
          ),
        ),
      ],
    );
  }

  void _openDetail(BuildContext context, Photo photo) {
    // The Photo rides along as `extra`, so the detail screen can show it
    // right away without fetching it again.
    context.go(AppRoutes.photo(photo.id), extra: photo);
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

/// The app bar with a message (error or empty) centred below it.
class _MessageView extends StatelessWidget {
  const _MessageView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const _HomeAppBar(),
        // hasScrollBody: false - the child is a normal widget, not a list,
        // so it is sized to the space left and centred there.
        SliverFillRemaining(hasScrollBody: false, child: child),
      ],
    );
  }
}
