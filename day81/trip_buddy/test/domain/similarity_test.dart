import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/similarity.dart';

Float32List v(List<double> values) => Float32List.fromList(values);

void main() {
  test('same direction is 1, opposite is -1, unrelated is 0', () {
    expect(cosineSimilarity(v([1, 2]), v([2, 4])), closeTo(1, 1e-6));
    expect(cosineSimilarity(v([1, 2]), v([-1, -2])), closeTo(-1, 1e-6));
    expect(cosineSimilarity(v([1, 0]), v([0, 3])), 0);
  });

  test('length does not matter, only direction', () {
    expect(cosineSimilarity(v([3, 4]), v([0.6, 0.8])), closeTo(1, 1e-6));
  });

  test('a zero vector is similar to nothing', () {
    expect(cosineSimilarity(v([0, 0]), v([1, 1])), 0);
  });

  test('vectors of different lengths are an error', () {
    expect(() => cosineSimilarity(v([1]), v([1, 2])), throwsArgumentError);
  });

  test('rankBySimilarity returns the closest items first', () {
    final ranked = rankBySimilarity(v([1, 0]), [
      (item: 'up', vector: v([0, 1])),
      (item: 'right', vector: v([1, 0])),
      (item: 'diagonal', vector: v([1, 1])),
    ], top: 2);

    expect(ranked.map((r) => r.item), ['right', 'diagonal']);
    expect(ranked.first.score, closeTo(1, 1e-6));
  });
}
