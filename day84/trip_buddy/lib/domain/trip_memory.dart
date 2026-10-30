import 'dart:typed_data';

/// A document the user added (Day 76; uploads come on Day 77).
class TripDocument {
  const TripDocument({
    required this.id,
    required this.title,
    required this.addedAt,
    required this.chunkCount,
  });

  final int id;
  final String title;
  final DateTime addedAt;
  final int chunkCount;
}

/// A piece of a document: small enough to embed and to put in a prompt.
class Chunk {
  const Chunk({
    required this.id,
    required this.documentId,
    required this.documentTitle,
    required this.text,
    required this.vector,
  });

  final int id;
  final int documentId;
  final String documentTitle;
  final String text;
  final Float32List vector;
}

/// Where documents and their vectors are kept: Trip Buddy's "memory".
/// Throws a StorageFailure when the database fails.
abstract interface class TripMemory {
  Stream<List<TripDocument>> watchDocuments();

  /// Saves a document with its chunks, all or nothing.
  Future<void> addDocument({
    required String title,
    required DateTime addedAt,
    required List<({String text, Float32List vector})> chunks,
  });

  Future<List<Chunk>> allChunks();

  Future<void> deleteDocument(int id);
}
