import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/config/assets.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/core/app_exception.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photo_feed.dart';
import 'package:pixly/providers/curated_photos.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:pixly/widgets/error_view.dart';
import 'package:pixly/widgets/load_more_status.dart';
import 'package:pixly/widgets/pexels_link.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/shimmer_grid.dart';
import 'package:pixly/widgets/theme_mode_button.dart';

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
        const PexelsLink(),
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

class _PhotosBody extends ConsumerWidget {
  const _PhotosBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side effect, not UI: when a refresh fails while photos are on screen,
    // show the error in a SnackBar (the photos stay).
    ref.listen(curatedPhotosProvider, (previous, next) {
      // Not while a new refresh is running: it is still an AsyncError then.
      if (next case AsyncError(
        :final error,
        isLoading: false,
      ) when next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppException.from(error).message)),
        );
      }
    });

    final feed = ref.watch(curatedPhotosProvider);

    return switch (feed) {
      // Photos to show - also while refreshing or after a failed refresh.
      AsyncValue(value: final feed?) when feed.photos.isNotEmpty => _PhotosGrid(
        feed: feed,
      ),
      // A first page with no photos at all.
      AsyncValue(value: _?) => _MessageView(
        child: EmptyState(
          title: 'No photos yet',
          message: 'Beautiful photos from Pexels will show up here soon.',
          action: FilledButton.icon(
            onPressed: () => ref.invalidate(curatedPhotosProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
          ),
        ),
      ),
      // isLoading: after "Try again" the state stays an AsyncError (with
      // isLoading true) until the new result arrives: show the shimmer.
      AsyncError(:final error, isLoading: false) => _MessageView(
        child: ErrorView(
          kind: AppException.from(error).kind,
          message: AppException.from(error).message,
          // Throws the old state away and runs build() again.
          onRetry: () => ref.invalidate(curatedPhotosProvider),
        ),
      ),
      // The first page is loading.
      _ => const CustomScrollView(
        slivers: [
          _HomeAppBar(),
          // Fills the rest of the screen with the shimmer skeleton.
          SliverFillRemaining(child: ShimmerGrid()),
        ],
      ),
    };
  }
}

class _PhotosGrid extends ConsumerWidget {
  const _PhotosGrid({required this.feed});

  final PhotoFeed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(curatedPhotosProvider.notifier);

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: PhotoGrid(
            headerSlivers: const [_HomeAppBar(), _CuratedIntro()],
            photos: feed.photos,
            onLoadMore: notifier.loadMore,
            onPhotoTap: (photo) => _openDetail(context, photo),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: Center(
            child: LoadMoreStatus(
              isLoadingMore: feed.isLoadingMore,
              error: feed.loadMoreError,
              onRetry: notifier.retryLoadMore,
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

  Future<void> _refresh(WidgetRef ref) async {
    try {
      // Keeps the refresh spinner until the new first page is in.
      await ref.read(curatedPhotosProvider.notifier).refresh();
    } catch (_) {
      // Nothing to do here: the error is now in the provider's state and
      // the ref.listen above shows it in a SnackBar.
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
