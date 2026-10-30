import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:trip_buddy/data/local/drift_itinerary.dart';
import 'package:trip_buddy/data/local/trip_database.dart';
import 'package:trip_buddy/domain/booking.dart';

void main() {
  test('bookings come back earliest first, at the same clock time', () async {
    final db = TripDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final itinerary = DriftItinerary(db);

    await itinerary.add(
      title: 'Return flight SQ322',
      kind: BookingKind.flight,
      startsAt: DateTime(2026, 12, 19, 23, 30),
      timeZone: 'Asia/Singapore',
    );
    final hotel = await itinerary.add(
      title: 'Parkroyal Collection Pickering',
      kind: BookingKind.hotel,
      startsAt: DateTime(2026, 12, 13, 15, 0),
      timeZone: 'Asia/Singapore',
    );

    final bookings = await itinerary.watchBookings().first;
    expect(bookings.map((b) => b.title), [
      'Parkroyal Collection Pickering',
      'Return flight SQ322',
    ]);
    expect(bookings.first.startsAt, DateTime(2026, 12, 13, 15, 0));

    await itinerary.delete(hotel.id);
    expect(await itinerary.watchBookings().first, hasLength(1));
  });

  test('a Day 76 database gets the new tables, documents kept', () async {
    final dir = Directory.systemTemp.createTempSync('trip_buddy_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/trip_buddy.sqlite');
    // Version 1, as Days 76–79 left it, with one document.
    final v1 = sqlite3.open(file.path);
    v1.execute('''
      CREATE TABLE documents (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        added_at INTEGER NOT NULL
      );
      CREATE TABLE chunks (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        document_id INTEGER NOT NULL REFERENCES documents (id),
        position INTEGER NOT NULL,
        content TEXT NOT NULL,
        embedding BLOB NOT NULL
      );
      CREATE INDEX chunks_document ON chunks (document_id);
      INSERT INTO documents (title, added_at) VALUES ('Trip plan', 1793000000);
    ''');
    v1.userVersion = 1;
    v1.close();

    final db = TripDatabase(NativeDatabase(file));
    final documents = await db.select(db.documents).get(); // migrates
    expect(documents.single.title, 'Trip plan');
    await DriftItinerary(db).add(
      title: 'Gardens by the Bay light show',
      kind: BookingKind.activity,
      startsAt: DateTime(2026, 12, 14, 19, 45),
      timeZone: 'Asia/Singapore',
    );
    await db.close();

    final after = sqlite3.open(file.path);
    // Day 82: version 3 (places) on top.
    expect(after.userVersion, 3);
    after.close();
  });
}
