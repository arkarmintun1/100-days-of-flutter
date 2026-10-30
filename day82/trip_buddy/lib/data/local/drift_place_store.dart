import 'dart:developer';

import '../../domain/failures.dart';
import '../../domain/nearby.dart';
import '../../domain/trip_place.dart';
import 'trip_database.dart';

/// The map's places in SQLite (Day 82).
class DriftPlaceStore implements PlaceStore {
  DriftPlaceStore(this._db);

  final TripDatabase _db;

  @override
  Future<List<TripPlace>> load() async {
    try {
      final rows = await _db.select(_db.places).get();
      return [
        for (final row in rows)
          TripPlace(
            FoundPlace(
              name: row.name,
              kind: row.kind,
              address: row.address,
              documentTitle: row.documentTitle,
            ),
            latitude: row.latitude,
            longitude: row.longitude,
          ),
      ];
    } on Exception catch (e, stackTrace) {
      log('Reading places failed', error: e, stackTrace: stackTrace);
      throw const StorageFailure("Couldn't read the saved places.");
    }
  }

  @override
  Future<void> save(List<TripPlace> places) async {
    try {
      // All or nothing: never half the old places and half the new.
      await _db.transaction(() async {
        await _db.delete(_db.places).go();
        await _db.batch((batch) {
          batch.insertAll(_db.places, [
            for (final p in places)
              PlacesCompanion.insert(
                name: p.found.name,
                kind: p.found.kind,
                address: p.found.address,
                documentTitle: p.found.documentTitle,
                latitude: p.latitude,
                longitude: p.longitude,
              ),
          ]);
        });
      });
    } on Exception catch (e, stackTrace) {
      log('Saving places failed', error: e, stackTrace: stackTrace);
      throw const StorageFailure("Couldn't save the places.");
    }
  }
}
