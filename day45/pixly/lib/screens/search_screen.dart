import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/core/app_exception.dart';
import 'package:pixly/models/photo_feed.dart';
import 'package:pixly/providers/search.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:pixly/widgets/error_view.dart';
import 'package:pixly/widgets/load_more_status.dart';
import 'package:pixly/widgets/pexels_link.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/shimmer_grid.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Start with the last query, e.g. when coming back from a detail screen.
    _controller = TextEditingController(
      text: ref.read(searchQueryProvider).text,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchFor(String query) {
    _controller.text = query;
    FocusScope.of(context).unfocus(); // hide the keyboard
    ref.read(searchQueryProvider.notifier).submit(query);
  }

  void _clear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          controller: _controller,
          hintText: 'Search Pexels photos',
          leading: const Icon(Icons.search),
          trailing: [
            // Rebuilds only this button when the text changes.
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => _controller.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      tooltip: 'Clear',
                      icon: const Icon(Icons.close),
                      onPressed: _clear,
                    ),
            ),
          ],
          elevation: const WidgetStatePropertyAll(0),
          textInputAction: TextInputAction.search,
          onChanged: ref.read(searchQueryProvider.notifier).onChanged,
          onSubmitted: _searchFor,
        ),
        // Search results come from the Pexels API, so link back here too.
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Align(alignment: .centerRight, child: PexelsLink()),
        ),
      ),
      body: _SearchBody(onRecentTap: _searchFor),
    );
  }
}

class _SearchBody extends ConsumerWidget {
  const _SearchBody({required this.onRecentTap});

  final ValueChanged<String> onRecentTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(searchQueryProvider);

    if (input.text.isEmpty) {
      return _RecentSearches(
        searches: ref.watch(recentSearchesProvider),
        onTap: onRecentTap,
        onClear: ref.read(recentSearchesProvider.notifier).clear,
      );
    }

    // Still typing: the request starts after the pause.
    if (input.text != input.query) return const ShimmerGrid();

    final query = input.query;
    final resultsProvider = searchResultsProvider(query);

    // Remember queries that worked, when their first page arrives.
    ref.listen(resultsProvider, (previous, next) {
      if (next is AsyncData && previous is! AsyncData) {
        ref.read(recentSearchesProvider.notifier).add(query);
      }
    });

    return switch (ref.watch(resultsProvider)) {
      AsyncValue(value: final feed?) when feed.photos.isNotEmpty =>
        _ResultsGrid(query: query, feed: feed),
      AsyncValue(value: _?) => EmptyState(
        title: 'No results',
        message: 'No photos found for "$query". Try another word.',
      ),
      // After "Try again" it stays an AsyncError until the new result.
      AsyncError(:final error, isLoading: false) => ErrorView(
        kind: AppException.from(error).kind,
        message: AppException.from(error).message,
        onRetry: () => ref.invalidate(resultsProvider),
      ),
      _ => const ShimmerGrid(),
    };
  }
}

class _ResultsGrid extends ConsumerWidget {
  const _ResultsGrid({required this.query, required this.feed});

  final String query;
  final PhotoFeed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(searchResultsProvider(query).notifier);

    return Stack(
      children: [
        PhotoGrid(
          // A new grid (scrolled to the top) for every new query.
          key: ValueKey(query),
          photos: feed.photos,
          onLoadMore: notifier.loadMore,
          onPhotoTap: (photo) =>
              context.go(AppRoutes.searchPhoto(photo.id), extra: photo),
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
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.searches,
    required this.onTap,
    required this.onClear,
  });

  final List<String> searches;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return const EmptyState(
        title: 'Search photos',
        message: 'Find photos from Pexels by typing a word like "coffee".',
      );
    }

    return ListView(
      children: [
        ListTile(
          title: Text(
            'Recent searches',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: TextButton(onPressed: onClear, child: const Text('Clear')),
        ),
        for (final query in searches)
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(query),
            onTap: () => onTap(query),
          ),
      ],
    );
  }
}
