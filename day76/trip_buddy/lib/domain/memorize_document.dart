import 'chunker.dart';
import 'embedder.dart';
import 'failures.dart';
import 'trip_memory.dart';

/// Chunk → embed → store: how a document gets into Trip Buddy's memory
/// (Day 76). Throws a Failure.
class MemorizeDocument {
  MemorizeDocument(this._memory, this._embedder, {required this.now});

  final TripMemory _memory;
  final Embedder _embedder;
  final DateTime Function() now;

  Future<void> call({required String title, required String text}) async {
    final chunks = chunkText(text);
    if (title.trim().isEmpty || chunks.isEmpty) {
      throw const ValidationFailure('A document needs a title and text.');
    }
    // Embedded as documents: the model makes vectors for stored text.
    final vectors = await _embedder.embed(chunks, EmbedKind.document);
    await _memory.addDocument(
      title: title.trim(),
      addedAt: now(),
      chunks: [
        for (final (i, text) in chunks.indexed)
          (text: text, vector: vectors[i]),
      ],
    );
  }
}
