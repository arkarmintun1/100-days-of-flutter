import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/search_provider.dart';
import 'package:pixly/router/app_router.dart';
import 'package:pixly/widgets/empty_state.dart';
import 'package:pixly/widgets/load_more_status.dart';
import 'package:pixly/widgets/photo_grid.dart';
import 'package:pixly/widgets/shimmer_grid.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Start with the last query, e.g. when coming back from a detail screen.
    _controller = TextEditingController(
      text: context.read<SearchProvider>().query,
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
    context.read<SearchProvider>().search(query);
  }

  void _clear() {
    _controller.clear();
    context.read<SearchProvider>().clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SearchProvider>();

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
          onChanged: provider.onQueryChanged,
          onSubmitted: _searchFor,
        ),
      ),
      body: _SearchBody(onRecentTap: _searchFor),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({required this.onRecentTap});

  final ValueChanged<String> onRecentTap;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    final photos = provider.photos;

    if (provider.query.isEmpty) {
      return _RecentSearches(
        searches: provider.recentSearches,
        onTap: onRecentTap,
        onClear: provider.clearRecentSearches,
      );
    }

    if (provider.isLoading && photos.isEmpty) {
      return const ShimmerGrid();
    }

    if (provider.error != null && photos.isEmpty) {
      return EmptyState(
        title: 'Something went wrong',
        message: provider.error!,
        action: FilledButton.icon(
          onPressed: () => provider.search(provider.query),
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      );
    }

    if (photos.isEmpty) {
      return EmptyState(
        title: 'No results',
        message: 'No photos found for "${provider.query}". Try another word.',
      );
    }

    return Stack(
      children: [
        PhotoGrid(
          // A new grid (scrolled to the top) for every new query.
          key: ValueKey(provider.query),
          photos: photos,
          onLoadMore: provider.loadMore,
          onPhotoTap: (photo) => _openDetail(context, photo),
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
    context.go(AppRoutes.searchPhoto(photo.id), extra: photo);
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
