import 'embedder.dart';
import 'hybrid_search.dart';
import 'trip_memory.dart';

/// Finds the chunks that best answer [question] (Day 76). Throws a
/// Failure.
class SearchMemory {
  SearchMemory(this._memory, this._embedder);

  final TripMemory _memory;
  final Embedder _embedder;

  Future<List<SearchHit>> call(String question, {int top = 5}) async {
    final chunks = await _memory.allChunks();
    // Nothing memorized yet: no need to embed the question.
    if (chunks.isEmpty) return [];
    final [vector] = await _embedder.embed([question], EmbedKind.query);
    return hybridSearch(
      question: question,
      questionVector: vector,
      chunks: chunks,
      top: top,
    );
  }
}
