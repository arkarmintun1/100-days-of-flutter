import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'trip_database.g.dart';

/// Stores a vector (Float32List) as bytes in a BLOB column (Day 76).
///
/// 768 numbers × 4 bytes = 3 KB per chunk. The bytes are in the device's
/// byte order (little-endian on every platform Flutter runs on).
class VectorConverter extends TypeConverter<Float32List, Uint8List> {
  const VectorConverter();

  @override
  Float32List fromSql(Uint8List fromDb) =>
      // Copied: a Float32List view needs an offset that is a multiple
      // of 4, which bytes from SQLite don't promise.
      Uint8List.fromList(fromDb).buffer.asFloat32List();

  @override
  Uint8List toSql(Float32List value) =>
      value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
}

@DataClassName('DocumentRow')
class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get addedAt => dateTime()();
}

@DataClassName('ChunkRow')
@TableIndex(name: 'chunks_document', columns: {#documentId})
class Chunks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId => integer().references(Documents, #id)();

  /// The chunk's place in its document: 0, 1, 2...
  IntColumn get position => integer()();
  TextColumn get content => text()();
  BlobColumn get embedding => blob().map(const VectorConverter())();
}

@DriftDatabase(tables: [Documents, Chunks])
class TripDatabase extends _$TripDatabase {
  /// Tests pass an in-memory database here.
  TripDatabase(super.executor);

  /// The app's database file on the device.
  TripDatabase.defaults() : super(driftDatabase(name: 'trip_buddy'));

  @override
  int get schemaVersion => 1;
}
