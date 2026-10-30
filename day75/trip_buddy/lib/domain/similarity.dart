import 'dart:math';
import 'dart:typed_data';

/// How close two vectors point in the same direction (Day 75): 1 = the
/// same direction, 0 = perpendicular, -1 = opposite.
///
/// cos θ = (a · b) / (|a| × |b|)
double cosineSimilarity(Float32List a, Float32List b) {
  if (a.length != b.length) {
    throw ArgumentError('Vectors differ in length: ${a.length}, ${b.length}');
  }
  var dot = 0.0, lengthA = 0.0, lengthB = 0.0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    lengthA += a[i] * a[i];
    lengthB += b[i] * b[i];
  }
  if (lengthA == 0 || lengthB == 0) return 0;
  return dot / (sqrt(lengthA) * sqrt(lengthB));
}

/// A text with its score for one search.
typedef Scored<T> = ({T item, double score});

/// The [top] items most similar to [query], best first.
List<Scored<T>> rankBySimilarity<T>(
  Float32List query,
  Iterable<({T item, Float32List vector})> items, {
  int top = 3,
}) {
  final scored = [
    for (final (:item, :vector) in items)
      (item: item, score: cosineSimilarity(query, vector)),
  ]..sort((a, b) => b.score.compareTo(a.score));
  return scored.take(top).toList();
}
