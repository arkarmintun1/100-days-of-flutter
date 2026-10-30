import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/trip_place.dart';

/// The trip's places on a Google Map (Day 81): one marker each, colored
/// by kind. Moves to [selected] when it changes.
class PlacesMap extends StatefulWidget {
  const PlacesMap({super.key, required this.places, this.selected});

  final List<TripPlace> places;
  final TripPlace? selected;

  @override
  State<PlacesMap> createState() => _PlacesMapState();
}

class _PlacesMapState extends State<PlacesMap> {
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(PlacesMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected case final place? when place != oldWidget.selected) {
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(place.latitude, place.longitude), 16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.places.firstOrNull;
    return GoogleMap(
      // The map needs a start: the first place, at city zoom.
      initialCameraPosition: CameraPosition(
        target: first == null
            ? const LatLng(0, 0)
            : LatLng(first.latitude, first.longitude),
        zoom: first == null ? 1 : 12,
      ),
      onMapCreated: (controller) => _controller = controller,
      markers: {
        for (final (i, place) in widget.places.indexed)
          Marker(
            markerId: MarkerId('$i'),
            position: LatLng(place.latitude, place.longitude),
            // Shown when the marker is tapped.
            infoWindow: InfoWindow(
              title: place.found.name,
              snippet: place.found.address,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              switch (place.found.kind) {
                PlaceKind.hotel => BitmapDescriptor.hueAzure,
                PlaceKind.food => BitmapDescriptor.hueOrange,
                PlaceKind.sight => BitmapDescriptor.hueGreen,
                PlaceKind.airport ||
                PlaceKind.station => BitmapDescriptor.hueViolet,
                PlaceKind.other => BitmapDescriptor.hueRed,
              },
            ),
          ),
      },
    );
  }
}
