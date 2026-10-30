import 'dart:developer';

import 'failures.dart';
import 'nearby.dart';
import 'trip_memory.dart';
import 'trip_place.dart';

/// The places on the map, and the ones that couldn't be placed.
class PlaceMap {
  const PlaceMap({required this.placed, required this.notFound});

  final List<TripPlace> placed;
  final List<FoundPlace> notFound;
}

/// Documents → places → coordinates (Day 81). Throws a Failure.
class MapTripPlaces {
  MapTripPlaces(this._memory, this._finder, this._geocoder, this._store);

  final TripMemory _memory;
  final PlaceFinder _finder;
  final Geocoder _geocoder;

  /// Day 82: the result is saved for the next app start and "near me".
  final PlaceStore _store;

  /// Most text sent per document: a guide of a few pages. The chunks of
  /// a longer document after this are left out.
  static const maxChars = 20000;

  Future<PlaceMap> call() async {
    // Day 76 keeps chunks, not whole documents: put them back together.
    // (Chunks overlap by a sentence: a repeated sentence doesn't matter
    // for finding places.)
    // By id, not by title: two documents may have the same title.
    final byDocument = <int, ({String title, StringBuffer text})>{};
    for (final chunk in await _memory.allChunks()) {
      final document = byDocument.putIfAbsent(
        chunk.documentId,
        () => (title: chunk.documentTitle, text: StringBuffer()),
      );
      if (document.text.length + chunk.text.length <= maxChars) {
        document.text.writeln(chunk.text);
      }
    }
    if (byDocument.isEmpty) throw noDocuments;
    final found = <FoundPlace>[];
    final seen = <String>{};
    for (final (:title, :text) in byDocument.values) {
      for (final place in await _finder.find(title: title, text: '$text')) {
        // The same hotel in two documents: one marker.
        if (seen.add('${place.name}|${place.address}'.toLowerCase())) {
          found.add(place);
        }
      }
    }
    final placed = <TripPlace>[];
    final notFound = <FoundPlace>[];
    // One at a time: the phone's geocoder has a rate limit.
    for (final place in found) {
      final point = await _geocoder.locate(place.address);
      if (point == null) {
        notFound.add(place);
      } else {
        placed.add(
          TripPlace(
            place,
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      }
    }
    try {
      await _store.save(placed);
    } on Failure catch (e) {
      // This search (paid for) still shows. The saved places stay as they
      // were (a transaction): the earlier ones, if any.
      log("Couldn't save the places", error: e);
    }
    return PlaceMap(placed: placed, notFound: notFound);
  }
}

/// Nothing in the vault to read places from.
const noDocuments = ValidationFailure(
  'Add documents to the vault first: places come from them.',
);
