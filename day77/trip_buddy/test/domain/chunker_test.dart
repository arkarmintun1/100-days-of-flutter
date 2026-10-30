import 'package:characters/characters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/chunker.dart';

void main() {
  test('maxChars must be positive', () {
    expect(() => chunkText('Hi.', maxChars: 0), throwsArgumentError);
    expect(() => chunkText('Hi.', maxChars: -1), throwsArgumentError);
  });

  test('a short text is one chunk', () {
    expect(chunkText('Hotel at 3 pm.  Flight at 9.'), [
      'Hotel at 3 pm. Flight at 9.',
    ]);
  });

  test('chunks end at sentences and stay under the limit', () {
    final text = [
      for (var i = 1; i <= 20; i++) 'Sentence number $i.',
    ].join(' ');

    final chunks = chunkText(text, maxChars: 60);

    expect(chunks.length, greaterThan(1));
    for (final chunk in chunks) {
      expect(chunk.length, lessThanOrEqualTo(60));
      expect(chunk, endsWith('.'));
    }
  });

  test('each chunk starts with the last sentence of the one before', () {
    final chunks = chunkText(
      'One one one. Two two two. Three three three. Four four four.',
      maxChars: 32,
    );

    expect(chunks, [
      'One one one. Two two two.',
      'Two two two. Three three three.',
      // "Three three three. Four four four." would be too long.
      'Four four four.',
    ]);
  });

  test('a blank line starts a new chunk; lines are sentences too', () {
    expect(chunkText('Flights\nSQ321 lands 18:05\n\nHotel\nCheck-in 3 pm'), [
      'Flights SQ321 lands 18:05',
      'Hotel Check-in 3 pm',
    ]);
  });

  test('a sentence longer than a chunk is cut by words', () {
    final long = List.filled(30, 'word').join(' '); // 149 characters

    final chunks = chunkText(long, maxChars: 50);

    expect(chunks.every((c) => c.length <= 50), isTrue);
    expect(chunks.join(' ').split(' '), hasLength(30));
  });

  test('a cut never splits a character: emoji', () {
    // 601 UTF-16 code units: the emoji is 2 of them.
    final text = '${'a' * 599}😀b';

    expect(chunkText(text), ['a' * 599, '😀b']);
  });

  test('a character longer than maxChars is kept whole', () {
    expect(chunkText('😀', maxChars: 1), ['😀']);
  });

  test('a cut never splits a character: Burmese', () {
    const text = 'မင်္ဂလာပါခင်ဗျာ'; // no spaces to cut at
    final whole = text.characters.toSet();

    for (final chunk in chunkText(text, maxChars: 5)) {
      // A vowel sign cut off its consonant would be a "character" of
      // its own, one the original text doesn't have.
      expect(whole, containsAll(chunk.replaceAll(' ', '').characters));
    }
  });

  test('a Burmese sentence ends at ။', () {
    expect(chunkText('ဟိုတယ်။လေဆိပ်။', maxChars: 10), ['ဟိုတယ်။', 'လေဆိပ်။']);
  });

  test('empty text has no chunks', () {
    expect(chunkText('  \n\n '), isEmpty);
  });
}
