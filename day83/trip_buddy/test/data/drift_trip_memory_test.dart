import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/local/drift_trip_memory.dart';
import 'package:trip_buddy/data/local/trip_database.dart';

void main() {
  late TripDatabase db;
  late DriftTripMemory memory;

  setUp(() {
    // An in-memory database per test (the file stays on the device).
    db = TripDatabase(NativeDatabase.memory());
    memory = DriftTripMemory(db);
  });
  tearDown(() => db.close());

  Float32List v(List<double> values) => Float32List.fromList(values);

  test('a document is saved with its chunks and vectors', () async {
    await memory.addDocument(
      title: 'Trip plan',
      addedAt: DateTime(2026, 10, 29),
      chunks: [
        (text: 'Flight SQ321 lands at 18:05.', vector: v([0.6, 0.8])),
        (text: 'Hotel check-in from 3 pm.', vector: v([1, 0])),
      ],
    );

    final chunks = await memory.allChunks();
    expect(chunks.map((c) => c.text), [
      'Flight SQ321 lands at 18:05.',
      'Hotel check-in from 3 pm.',
    ]);
    expect(chunks.first.documentTitle, 'Trip plan');
    // The vector survives the trip to bytes and back.
    expect(chunks.first.vector, [closeTo(0.6, 1e-6), closeTo(0.8, 1e-6)]);

    final [document] = await memory.watchDocuments().first;
    expect(document.title, 'Trip plan');
    expect(document.chunkCount, 2);
  });

  test('documents come newest first, with their chunk counts', () async {
    await memory.addDocument(
      title: 'Old',
      addedAt: DateTime(2026, 10, 1),
      chunks: [
        (text: 'a', vector: v([1])),
      ],
    );
    await memory.addDocument(
      title: 'New',
      addedAt: DateTime(2026, 10, 2),
      chunks: [
        (text: 'b', vector: v([1])),
        (text: 'c', vector: v([1])),
      ],
    );

    final documents = await memory.watchDocuments().first;
    expect(documents.map((d) => (d.title, d.chunkCount)), [
      ('New', 2),
      ('Old', 1),
    ]);
  });

  test('deleting a document deletes its chunks', () async {
    await memory.addDocument(
      title: 'Trip plan',
      addedAt: DateTime(2026, 10, 29),
      chunks: [
        (text: 'a', vector: v([1])),
      ],
    );
    final [document] = await memory.watchDocuments().first;

    await memory.deleteDocument(document.id);

    expect(await memory.allChunks(), isEmpty);
    expect(await memory.watchDocuments().first, isEmpty);
  });
}
