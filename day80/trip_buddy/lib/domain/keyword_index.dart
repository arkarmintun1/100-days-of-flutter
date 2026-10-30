import 'dart:math';

import 'similarity.dart';

/// Lowercase words and numbers: "Flight SQ321!" → [flight, sq321].
List<String> tokenize(String text) => RegExp(
  r'[\p{L}\p{M}\p{N}]+',
  unicode: true,
).allMatches(text.toLowerCase()).map((m) => m[0]!).toList();

/// Keyword search with BM25, the ranking classic search engines use
/// (Day 76).
///
/// A word scores more when it appears often in a text (with diminishing
/// returns), when it is rare across all texts, and when the text is short.
class KeywordIndex<T> {
  KeywordIndex(Iterable<({T item, String text})> texts) {
    for (final (:item, :text) in texts) {
      final tokens = tokenize(text);
      final counts = <String, int>{};
      for (final token in tokens) {
        counts[token] = (counts[token] ?? 0) + 1;
      }
      _docs.add((item: item, length: tokens.length, counts: counts));
      for (final token in counts.keys) {
        _docsWith[token] = (_docsWith[token] ?? 0) + 1;
      }
    }
    _averageLength = _docs.isEmpty
        ? 0
        : _docs.map((d) => d.length).reduce((a, b) => a + b) / _docs.length;
  }

  // The usual BM25 settings: k1 limits how much repeating a word counts,
  // b how much a long text is penalized.
  static const _k1 = 1.2, _b = 0.75;

  final _docs = <({T item, int length, Map<String, int> counts})>[];
  final _docsWith = <String, int>{};
  late final double _averageLength;

  /// Texts that contain at least one word of [query], best first.
  List<Scored<T>> search(String query, {int top = 10}) {
    final terms = tokenize(query).toSet();
    final scored = <Scored<T>>[];
    for (final doc in _docs) {
      var score = 0.0;
      for (final term in terms) {
        final count = doc.counts[term];
        if (count == null) continue;
        final n = _docsWith[term]!;
        final idf = log(1 + (_docs.length - n + 0.5) / (n + 0.5));
        score +=
            idf *
            (count * (_k1 + 1)) /
            (count + _k1 * (1 - _b + _b * doc.length / _averageLength));
      }
      if (score > 0) scored.add((item: doc.item, score: score));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(top).toList();
  }
}
