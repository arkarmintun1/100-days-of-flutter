import 'package:characters/characters.dart';

/// Splits a long text into chunks of at most [maxChars] UTF-16 code units,
/// the way `String.length` counts (Day 76). A single character longer
/// than that (an emoji with maxChars: 1) is kept whole in its own chunk.
///
/// A blank line starts a new section: a chunk never mixes two sections.
/// Chunks end at sentence boundaries where possible. A chunk starts with
/// the last sentence of the one before (overlap) when both still fit, so
/// a fact split over two sentences is often whole in one chunk.
List<String> chunkText(String text, {int maxChars = 600}) {
  if (maxChars <= 0) {
    throw ArgumentError.value(maxChars, 'maxChars', 'must be positive');
  }
  return [
    for (final section in text.split(RegExp(r'\n\s*\n')))
      ..._chunkSection(section, maxChars),
  ];
}

List<String> _chunkSection(String text, int maxChars) {
  final sentences = [
    for (final sentence in _sentences(text))
      // A "sentence" longer than a chunk (e.g. a table row without
      // dots) is cut by words.
      if (sentence.length > maxChars)
        ..._byWords(sentence, maxChars)
      else
        sentence,
  ];

  final chunks = <String>[];
  var current = <String>[];
  var length = 0;
  for (final sentence in sentences) {
    final extra = current.isEmpty ? sentence.length : sentence.length + 1;
    if (length + extra > maxChars && current.isNotEmpty) {
      chunks.add(current.join(' '));
      // Overlap: start the next chunk with the last sentence, if both
      // still fit.
      final last = current.last;
      final keep = last.length + 1 + sentence.length <= maxChars;
      current = keep ? [last] : [];
      length = keep ? last.length : 0;
    }
    length += current.isEmpty ? sentence.length : sentence.length + 1;
    current.add(sentence);
  }
  if (current.isNotEmpty) chunks.add(current.join(' '));
  return chunks;
}

/// Sentences, and lines (lists and tables have no dots), without empty
/// ones. Whitespace inside is collapsed to single spaces. A sentence ends
/// at . ! ? and at Burmese's ။ (pote ma).
Iterable<String> _sentences(String text) => text
    .split(RegExp(r'\n|(?<=[.!?])\s+|(?<=။)\s*'))
    .map((s) => s.trim().replaceAll(RegExp(r'\s+'), ' '))
    .where((s) => s.isNotEmpty);

Iterable<String> _byWords(String sentence, int maxChars) sync* {
  var line = '';
  for (final word in sentence.split(' ')) {
    if (line.isNotEmpty && line.length + 1 + word.length > maxChars) {
      yield line;
      line = '';
    }
    // A single "word" longer than a chunk (e.g. a long URL, or Burmese
    // text, which has few spaces) is cut.
    var rest = word;
    while (rest.length > maxChars) {
      if (line.isNotEmpty) {
        yield line;
        line = '';
      }
      final piece = _start(rest, maxChars);
      yield piece;
      rest = rest.substring(piece.length);
    }
    line = line.isEmpty ? rest : '$line $rest';
  }
  if (line.isNotEmpty) yield line;
}

/// The longest start of [text] that fits in [maxChars] without cutting a
/// character in two. `substring` counts UTF-16 code units: an emoji is
/// two of them, and a Burmese syllable is a consonant with vowel signs
/// after it. `characters` counts what a reader sees as one character
/// (grapheme clusters).
String _start(String text, int maxChars) {
  var end = 0;
  for (final character in text.characters) {
    if (end + character.length > maxChars) break;
    end += character.length;
  }
  // One "character" longer than a chunk (unlikely): keep it whole.
  return end == 0 ? text.characters.first : text.substring(0, end);
}
