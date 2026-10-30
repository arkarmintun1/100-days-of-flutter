import 'hybrid_search.dart';

/// Writes an answer to a question from numbered sources only (Day 78).
/// Throws a Failure.
abstract interface class AnswerWriter {
  /// [sources] are numbered from 1 in the prompt; the answer cites them
  /// as [1], [2]...
  Future<String> write({
    required String question,
    required List<({String title, String text})> sources,
  });
}

/// An answer, and the sources it was given: [1] is `sources[0]`.
class Answer {
  const Answer({required this.text, required this.sources});

  final String text;
  final List<SearchHit> sources;

  /// The source numbers the text cites, in order of first use. Numbers
  /// that point at no source (a model can invent [7]) are left out.
  List<int> get cited => citations(text, sources.length);
}

/// "[1]", "[2][3]" and "[1, 2]" in [text], as numbers from 1 to [count].
List<int> citations(String text, int count) => [
  ...{
    for (final match in RegExp(r'\[(\d+(?:\s*,\s*\d+)*)\]').allMatches(text))
      for (final number in match[1]!.split(','))
        if (int.tryParse(number.trim()) case final n? when n >= 1 && n <= count)
          n,
  },
];
