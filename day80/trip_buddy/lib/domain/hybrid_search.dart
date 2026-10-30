import 'dart:typed_data';

import 'keyword_index.dart';
import 'similarity.dart';
import 'trip_memory.dart';

/// A chunk found for a question, and how it was found.
class SearchHit {
  const SearchHit({
    required this.chunk,
    required this.score,
    required this.byMeaning,
    required this.byKeyword,
  });

  final Chunk chunk;

  /// The fused score: only useful to compare hits of one search.
  final double score;
  final bool byMeaning;
  final bool byKeyword;
}

/// Vector search finds meaning ("place to stay" → hotel); keyword search
/// finds exact words ("SQ321", which looks a lot like "SQ322" to an
/// embedding model). Hybrid search runs both and merges the two rankings
/// with Reciprocal Rank Fusion (Day 76).
List<SearchHit> hybridSearch({
  required String question,
  required Float32List questionVector,
  required List<Chunk> chunks,
  int top = 5,
  int candidates = 10,
}) {
  final byMeaning = rankBySimilarity(questionVector, [
    for (final chunk in chunks) (item: chunk, vector: chunk.vector),
  ], top: candidates);
  final byKeyword = KeywordIndex([
    for (final chunk in chunks)
      (item: chunk, text: '${chunk.documentTitle}\n${chunk.text}'),
  ]).search(question, top: candidates);

  // RRF: each list adds 1 / (k + rank). Only ranks count, so the two
  // different kinds of scores never have to be compared. k = 60 is the
  // value from the paper that introduced RRF.
  const k = 60;
  final fused = <Chunk, double>{};
  final found = <Chunk, ({bool meaning, bool keyword})>{};
  for (final (rank, hit) in byMeaning.indexed) {
    fused[hit.item] = (fused[hit.item] ?? 0) + 1 / (k + rank + 1);
    found[hit.item] = (meaning: true, keyword: false);
  }
  for (final (rank, hit) in byKeyword.indexed) {
    fused[hit.item] = (fused[hit.item] ?? 0) + 1 / (k + rank + 1);
    found[hit.item] = (
      meaning: found[hit.item]?.meaning ?? false,
      keyword: true,
    );
  }

  final hits = [
    for (final MapEntry(key: chunk, value: score) in fused.entries)
      SearchHit(
        chunk: chunk,
        score: score,
        byMeaning: found[chunk]!.meaning,
        byKeyword: found[chunk]!.keyword,
      ),
  ]..sort((a, b) => b.score.compareTo(a.score));
  return hits.take(top).toList();
}
