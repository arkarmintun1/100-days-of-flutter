import 'dart:async';
import 'dart:typed_data';

import 'package:trip_buddy/domain/trip_memory.dart';

/// Trip Buddy's memory in a list, for widget tests.
class FakeTripMemory implements TripMemory {
  final _documents = <TripDocument>[];
  final _chunks = <Chunk>[];
  final _changes = StreamController<void>.broadcast();
  var _nextId = 1;

  List<Chunk> get chunks => List.unmodifiable(_chunks);

  @override
  Stream<List<TripDocument>> watchDocuments() async* {
    yield List.of(_documents);
    await for (final _ in _changes.stream) {
      yield List.of(_documents);
    }
  }

  @override
  Future<void> addDocument({
    required String title,
    required DateTime addedAt,
    required List<({String text, Float32List vector})> chunks,
  }) async {
    final id = _nextId++;
    _documents.insert(
      0,
      TripDocument(
        id: id,
        title: title,
        addedAt: addedAt,
        chunkCount: chunks.length,
      ),
    );
    for (final (:text, :vector) in chunks) {
      _chunks.add(
        Chunk(
          id: _nextId++,
          documentId: id,
          documentTitle: title,
          text: text,
          vector: vector,
        ),
      );
    }
    _changes.add(null);
  }

  @override
  Future<List<Chunk>> allChunks() async => List.of(_chunks);

  @override
  Future<void> deleteDocument(int id) async {
    _documents.removeWhere((d) => d.id == id);
    _chunks.removeWhere((c) => c.documentId == id);
    _changes.add(null);
  }
}
