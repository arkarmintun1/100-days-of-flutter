import 'dart:typed_data';

/// What a text is used for. Embedding models can make better vectors when
/// they know it: a stored passage and a short question are different.
enum EmbedKind { document, query }

/// Turns texts into embeddings: lists of numbers where texts with a
/// similar meaning get similar numbers (Day 75).
abstract interface class Embedder {
  /// One vector per text, in the same order. Throws a Failure.
  Future<List<Float32List>> embed(List<String> texts, EmbedKind kind);
}
