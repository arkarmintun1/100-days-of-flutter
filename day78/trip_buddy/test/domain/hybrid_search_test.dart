import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/hybrid_search.dart';
import 'package:trip_buddy/domain/trip_memory.dart';

Chunk chunk(int id, String text, List<double> vector) => Chunk(
  id: id,
  documentId: 1,
  documentTitle: 'Trip plan',
  text: text,
  vector: Float32List.fromList(vector),
);

void main() {
  // To an embedding model, the two flights look almost the same.
  final outbound = chunk(1, 'Flight SQ321 lands at 18:05.', [1, 0.1]);
  final inbound = chunk(2, 'Flight SQ322 lands at 05:55.', [1, 0.12]);
  final hotel = chunk(3, 'Hotel check-in from 3 pm.', [0, 1]);
  final chunks = [outbound, inbound, hotel];

  test('an exact flight number wins with the keyword search', () {
    final hits = hybridSearch(
      question: 'When does SQ321 land?',
      // Closer to the inbound flight: meaning alone would pick it.
      questionVector: Float32List.fromList([1, 0.12]),
      chunks: chunks,
    );

    expect(hits.first.chunk, outbound);
    expect(hits.first.byMeaning, isTrue);
    expect(hits.first.byKeyword, isTrue);
  });

  test('meaning finds what shares no word with the question', () {
    final hits = hybridSearch(
      question: 'Where do I sleep?',
      questionVector: Float32List.fromList([0, 1]),
      chunks: chunks,
    );

    expect(hits.first.chunk, hotel);
    expect(hits.first.byKeyword, isFalse);
  });

  test('top limits the hits', () {
    final hits = hybridSearch(
      question: 'flight',
      questionVector: Float32List.fromList([1, 0]),
      chunks: chunks,
      top: 2,
    );

    expect(hits, hasLength(2));
  });
}
