import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/distance.dart';
import '../../domain/failures.dart';
import '../../domain/map_trip_places.dart';
import '../../domain/nearby.dart';
import '../../domain/trip_place.dart';
import '../providers/dependencies.dart';

/// Day 81: the places in your documents, on a map.
/// Day 82: saved between app starts, and sorted by what's near you.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  /// The saved places first (Day 82): no Gemini request to open the map.
  /// Null inside means nothing is saved yet.
  late Future<PlaceMap?> _places = _saved();
  TripPlace? _selected;

  /// Day 82: the places with distances, when "Near me" is on.
  Future<List<NearbyPlace>>? _nearby;

  Future<PlaceMap?> _saved() async {
    final places = await ref.read(placeStoreProvider).load();
    return places.isEmpty ? null : PlaceMap(placed: places, notFound: const []);
  }

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
      _nearby = null;
      _places = places;
    });
  }

  void _toggleNearMe() {
    final nearby = _nearby == null ? ref.read(findNearbyProvider)() : null;
    nearby?.then((_) {}, onError: (Object _) {}); // as in _find
    // A block, not `=> _nearby = nearby`: that would return the Future,
    // and setState refuses callbacks that return one.
    setState(() {
      _nearby = nearby;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            tooltip: 'Find places again',
            icon: const Icon(Icons.refresh),
            onPressed: _finding ? null : _find,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _places,
        builder: (context, snapshot) => switch (snapshot) {
          AsyncSnapshot(:final error?) => _Message(error),
          AsyncSnapshot(connectionState: ConnectionState.done, :final data) =>
            data == null
                ? Center(
                    child: FilledButton.icon(
                      onPressed: _finding ? null : _find,
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Find places in my documents'),
                    ),
                  )
                : _PlacesView(
                    data,
                    selected: _selected,
                    nearby: _nearby,
                    onSelect: (place) => setState(() => _selected = place),
                    onToggleNearMe: _toggleNearMe,
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

class _Message extends ConsumerWidget {
  const _Message(this.error);

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.read(locationServiceProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error is Failure
                  ? (error as Failure).message
                  : 'Something went wrong.',
              textAlign: TextAlign.center,
            ),
            // Day 82: a way out, when settings can fix it (as in Day 50).
            if (error case LocationFailure(:final fix))
              switch (fix) {
                LocationFix.turnOnLocation => TextButton(
                  onPressed: location.openLocationSettings,
                  child: const Text('Open location settings'),
                ),
                LocationFix.allowInAppSettings => TextButton(
                  onPressed: location.openAppSettings,
                  child: const Text('Open app settings'),
                ),
                LocationFix.none => const SizedBox.shrink(),
              },
          ],
        ),
      ),
    );
  }
}

class _PlacesView extends ConsumerWidget {
  const _PlacesView(
    this.map, {
    required this.selected,
    required this.nearby,
    required this.onSelect,
    required this.onToggleNearMe,
  });

  final PlaceMap map;
  final TripPlace? selected;
  final Future<List<NearbyPlace>>? nearby;
  final void Function(TripPlace place) onSelect;
  final VoidCallback onToggleNearMe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (map.placed.isEmpty && map.notFound.isEmpty) {
      return const Center(child: Text('No places found in your documents.'));
    }
    return Column(
      children: [
        // The map is a platform view: tests swap it for a placeholder.
        Expanded(child: ref.watch(placesMapProvider)(map.placed, selected)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              label: const Text('Near me'),
              avatar: const Icon(Icons.near_me_outlined),
              selected: nearby != null,
              onSelected: (_) => onToggleNearMe(),
            ),
          ),
        ),
        Expanded(
          child: nearby == null
              ? _list(context, [
                  for (final p in map.placed) (place: p, meters: null),
                ])
              : FutureBuilder(
                  future: nearby,
                  builder: (context, snapshot) => switch (snapshot) {
                    AsyncSnapshot(:final error?) => _Message(error),
                    AsyncSnapshot(:final data?) => _list(context, [
                      for (final n in data) (place: n.place, meters: n.meters),
                    ]),
                    _ => const Center(child: CircularProgressIndicator()),
                  },
                ),
        ),
      ],
    );
  }

  Widget _list(
    BuildContext context,
    List<({TripPlace place, double? meters})> places,
  ) => ListView(
    children: [
      for (final (:place, :meters) in places)
        ListTile(
          selected: place == selected,
          leading: Icon(_icon(place.found.kind)),
          title: Text(place.found.name),
          subtitle: Text(
            '${place.found.address} · ${place.found.documentTitle}',
          ),
          trailing: meters == null ? null : Text(formatDistance(meters)),
          onTap: () => onSelect(place),
        ),
      if (map.notFound.isNotEmpty) ...[
        const ListTile(title: Text("Couldn't place on the map"), dense: true),
        for (final place in map.notFound)
          ListTile(
            leading: const Icon(Icons.location_off_outlined),
            title: Text(place.name),
            subtitle: Text(place.address),
          ),
      ],
    ],
  );

  static IconData _icon(PlaceKind kind) => switch (kind) {
    PlaceKind.hotel => Icons.hotel,
    PlaceKind.food => Icons.restaurant,
    PlaceKind.sight => Icons.photo_camera_outlined,
    PlaceKind.airport => Icons.flight,
    PlaceKind.station => Icons.train,
    PlaceKind.other => Icons.place_outlined,
  };
}
