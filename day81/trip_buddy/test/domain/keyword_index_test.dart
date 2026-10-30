import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/keyword_index.dart';

void main() {
  test('tokenize keeps words and numbers, lowercase', () {
    expect(tokenize('Flight SQ321 lands at 18:05!'), [
      'flight',
      'sq321',
      'lands',
      'at',
      '18',
      '05',
    ]);
  });

  final index = KeywordIndex([
    (item: 'out', text: 'Flight SQ321 lands at Changi on 13 Dec.'),
    (item: 'back', text: 'Flight SQ322 departs Changi on 19 Dec.'),
    (item: 'hotel', text: 'Hotel check-in from 3 pm.'),
  ]);

  test('an exact flight number finds only its flight', () {
    final results = index.search('When does SQ321 land?');

    expect(results.map((r) => r.item), ['out']);
  });

  test('rare words count more than common ones', () {
    // "flight" is in two texts, "sq322" in one.
    final results = index.search('flight SQ322');

    expect(results.first.item, 'back');
    expect(results.map((r) => r.item), containsAll(['out', 'back']));
  });

  test('no shared word, no result', () {
    expect(index.search('where do I sleep'), isEmpty);
  });
}
