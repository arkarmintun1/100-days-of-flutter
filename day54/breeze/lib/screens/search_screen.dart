import 'package:breeze/core/app_exception.dart';
import 'package:breeze/models/place.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the city search on top of the current screen.
void openSearch(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => const SearchScreen()));

/// Search for a city by name; tapping a result shows its weather.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  /// What was searched (on submit, not on every key: the free plan has a
  /// call limit, and a city name is short to type).
  String _query = '';

  void _pick(Place place) {
    ref.read(selectedPlaceProvider.notifier).select(place);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search for a city',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (text) => setState(() => _query = text),
        ),
      ),
      body: _query.trim().isEmpty
          ? const Center(child: Text('Type a city name, e.g. Mandalay'))
          : _Results(query: _query, onPick: _pick),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.onPick});

  final String query;
  final ValueChanged<Place> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = placeSearchProvider(query);
    return switch (ref.watch(provider)) {
      AsyncData(value: []) => Center(child: Text('No places called "$query".')),
      AsyncData(value: final places) => ListView(
        children: [
          for (final place in places)
            ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(place.name),
              subtitle: Text(place.label),
              onTap: () => onPick(place),
            ),
        ],
      ),
      AsyncError(:final error, isLoading: false) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppException.from(error).message),
            TextButton(
              onPressed: () => ref.invalidate(provider),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
