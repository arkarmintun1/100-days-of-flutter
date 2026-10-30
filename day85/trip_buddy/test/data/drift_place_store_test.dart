import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/local/drift_place_store.dart';
import 'package:trip_buddy/data/local/trip_database.dart';
import 'package:trip_buddy/domain/trip_place.dart';

import '../helpers/fake_location.dart';

void main() {
  test('saving replaces the places, and they come back whole', () async {
    final db = TripDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = DriftPlaceStore(db);

    await store.save([testPlace('Old', PlaceKind.other, 1, 2)]);
    await store.save([
      testPlace('Maxwell Food Centre', PlaceKind.food, 1.2804, 103.8448),
    ]);

    final [place] = await store.load();
    expect(place.found.name, 'Maxwell Food Centre');
    expect(place.found.kind, PlaceKind.food);
    expect(place.found.documentTitle, 'Trip plan');
    expect((place.latitude, place.longitude), (1.2804, 103.8448));
  });
}
