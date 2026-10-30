import 'dart:math';
import 'dart:typed_data';

import 'chunker.dart';
import 'embedder.dart';
import 'failures.dart';
import 'trip_memory.dart';

/// Where adding a document is (Day 78), for a progress bar.
sealed class MemorizeStep {
  const MemorizeStep();
}

/// Gemini is copying out the file's text (Day 77).
final class Reading extends MemorizeStep {
  const Reading();
}

/// [done] of [total] chunks have their vectors.
final class Embedding extends MemorizeStep {
  const Embedding(this.done, this.total);
  final int done;
  final int total;
}

final class Saving extends MemorizeStep {
  const Saving();
}

/// Chunk → embed → store: how a document gets into Trip Buddy's memory
/// (Day 76). Throws a Failure.
class MemorizeDocument {
  MemorizeDocument(this._memory, this._embedder, {required this.now});

  final TripMemory _memory;
  final Embedder _embedder;
  final DateTime Function() now;

  /// Chunks per embedding request: progress moves after each batch. (The
  /// Cloud Function takes up to 50 texts per call.)
  static const batchSize = 20;

  Future<void> call({
    required String title,
    required String text,
    void Function(MemorizeStep step)? onStep,
  }) async {
    final chunks = chunkText(text);
    if (title.trim().isEmpty || chunks.isEmpty) {
      throw const ValidationFailure('A document needs a title and text.');
    }
    // Embedded as documents: the model makes vectors for stored text.
    // In batches, so a long document shows progress.
    final vectors = <Float32List>[];
    for (var start = 0; start < chunks.length; start += batchSize) {
      onStep?.call(Embedding(start, chunks.length));
      final end = min(start + batchSize, chunks.length);
      vectors.addAll(
        await _embedder.embed(chunks.sublist(start, end), EmbedKind.document),
      );
    }
    onStep?.call(Embedding(chunks.length, chunks.length));
    onStep?.call(const Saving());
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
