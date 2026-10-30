import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/failures.dart';
import '../../domain/map_trip_places.dart';
import '../../domain/trip_place.dart';
import '../providers/dependencies.dart';

/// Day 81: the places in your documents, on a map.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  /// Null until the user asks: reading every document costs a Gemini
  /// request each, so it doesn't happen just because the tab exists.
  Future<PlaceMap>? _places;
  TripPlace? _selected;

  /// True while a search runs: each costs Gemini requests and geocoder
  /// calls, so another one waits until it's done.
  var _finding = false;

  void _find() {
    if (_finding) return;
    final places = ref.read(mapTripPlacesProvider)();
    // FutureBuilder starts listening on the next frame. A quick failure
    // (no documents) would come first and be reported as unhandled: this
    // listener handles it, and FutureBuilder still gets the error.
    places.then((_) {}, onError: (Object _) {}).whenComplete(() {
      if (mounted) setState(() => _finding = false);
    });
    setState(() {
      _finding = true;
      _selected = null;
      _places = places;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          if (_places != null)
            IconButton(
              tooltip: 'Find again',
              icon: const Icon(Icons.refresh),
              onPressed: _finding ? null : _find,
            ),
        ],
      ),
      body: _places == null
          ? Center(
              child: FilledButton.icon(
                onPressed: _finding ? null : _find,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Find places in my documents'),
              ),
            )
          : FutureBuilder(
              future: _places,
              builder: (context, snapshot) => switch (snapshot) {
                AsyncSnapshot(:final error?) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      error is Failure
                          ? error.message
                          : 'Something went wrong.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AsyncSnapshot(:final data?) => _PlacesView(
                  data,
                  selected: _selected,
                  onSelect: (place) => setState(() => _selected = place),
                ),
                _ => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Reading your documents...'),
                    ],
                  ),
                ),
              },
            ),
    );
  }
}

class _PlacesView extends ConsumerWidget {
  const _PlacesView(this.map, {required this.selected, required this.onSelect});

  final PlaceMap map;
  final TripPlace? selected;
  final void Function(TripPlace place) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (map.placed.isEmpty && map.notFound.isEmpty) {
      return const Center(child: Text('No places found in your documents.'));
    }
    return Column(
      children: [
        // The map is a platform view: tests swap it for a placeholder.
        Expanded(child: ref.watch(placesMapProvider)(map.placed, selected)),
        Expanded(
          child: ListView(
            children: [
              for (final place in map.placed)
                ListTile(
                  selected: place == selected,
                  leading: Icon(_icon(place.found.kind)),
                  title: Text(place.found.name),
                  subtitle: Text(
                    '${place.found.address} · ${place.found.documentTitle}',
                  ),
                  onTap: () => onSelect(place),
                ),
              if (map.notFound.isNotEmpty) ...[
                const ListTile(
                  title: Text("Couldn't place on the map"),
                  dense: true,
                ),
                for (final place in map.notFound)
                  ListTile(
                    leading: const Icon(Icons.location_off_outlined),
                    title: Text(place.name),
                    subtitle: Text(place.address),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static IconData _icon(PlaceKind kind) => switch (kind) {
    PlaceKind.hotel => Icons.hotel,
    PlaceKind.food => Icons.restaurant,
    PlaceKind.sight => Icons.photo_camera_outlined,
    PlaceKind.airport => Icons.flight,
    PlaceKind.station => Icons.train,
    PlaceKind.other => Icons.place_outlined,
  };
}
