import 'dart:developer';
import 'dart:typed_data';

import 'package:drift/drift.dart';

import '../../domain/failures.dart';
import '../../domain/trip_memory.dart';
import 'trip_database.dart';

/// [TripMemory] in SQLite, with Drift (Day 76).
class DriftTripMemory implements TripMemory {
  DriftTripMemory(this._db);

  final TripDatabase _db;

  @override
  Stream<List<TripDocument>> watchDocuments() {
    final chunkCount = _db.chunks.id.count();
    final query =
        _db.select(_db.documents).join([
            leftOuterJoin(
              _db.chunks,
              _db.chunks.documentId.equalsExp(_db.documents.id),
            ),
          ])
          ..addColumns([chunkCount])
          ..groupBy([_db.documents.id])
          ..orderBy([OrderingTerm.desc(_db.documents.addedAt)]);
    return query
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              TripDocument(
                id: row.readTable(_db.documents).id,
                title: row.readTable(_db.documents).title,
                addedAt: row.readTable(_db.documents).addedAt,
                chunkCount: row.read(chunkCount) ?? 0,
              ),
          ],
        )
        .handleError(
          (Object e, StackTrace s) => throw _failure(e, s),
          test: (e) => e is Exception,
        );
  }

  @override
  Future<void> addDocument({
    required String title,
    required DateTime addedAt,
    required List<({String text, Float32List vector})> chunks,
  }) => _guard(
    // A transaction: a document is saved with all its chunks, or not at
    // all.
    () => _db.transaction(() async {
      final id = await _db
          .into(_db.documents)
          .insert(DocumentsCompanion.insert(title: title, addedAt: addedAt));
      await _db.batch((batch) {
        batch.insertAll(_db.chunks, [
          for (final (i, chunk) in chunks.indexed)
            ChunksCompanion.insert(
              documentId: id,
              position: i,
              content: chunk.text,
              embedding: chunk.vector,
            ),
        ]);
      });
    }),
  );

  @override
  Future<List<Chunk>> allChunks() => _guard(() async {
    final query = _db.select(_db.chunks).join([
      innerJoin(
        _db.documents,
        _db.documents.id.equalsExp(_db.chunks.documentId),
      ),
    ])..orderBy([OrderingTerm.asc(_db.chunks.id)]);
    return [
      for (final row in await query.get())
        Chunk(
          id: row.readTable(_db.chunks).id,
          documentId: row.readTable(_db.documents).id,
          documentTitle: row.readTable(_db.documents).title,
          text: row.readTable(_db.chunks).content,
          vector: row.readTable(_db.chunks).embedding,
        ),
    ];
  });

  @override
  Future<void> deleteDocument(int id) => _guard(
    () => _db.transaction(() async {
      await (_db.delete(
        _db.chunks,
      )..where((c) => c.documentId.equals(id))).go();
      await (_db.delete(_db.documents)..where((d) => d.id.equals(id))).go();
    }),
  );

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on Failure {
      rethrow;
    } on Exception catch (e, s) {
      // Drift and SQLite errors. (Bugs - Errors - are not caught.)
      throw _failure(e, s);
    }
  }

  static StorageFailure _failure(Object e, StackTrace s) {
    log('Database error', error: e, stackTrace: s);
    return const StorageFailure("Couldn't read or save your documents.");
  }
}
