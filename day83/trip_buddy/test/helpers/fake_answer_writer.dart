import 'package:trip_buddy/domain/answer.dart';

/// Answers without Gemini, for tests. By default it cites source [1].
class FakeAnswerWriter implements AnswerWriter {
  FakeAnswerWriter({this.answer, this.error});

  /// Builds the answer from the numbered sources, if set.
  final String Function(List<({String title, String text})> sources)? answer;
  final Object? error;

  final calls = <(String, List<({String title, String text})>)>[];

  @override
  Future<String> write({
    required String question,
    required List<({String title, String text})> sources,
  }) async {
    calls.add((question, sources));
    if (error case final error?) throw error;
    return answer?.call(sources) ?? 'Here is what your documents say [1].';
  }

  /// The number ([1], [2]...) of the first source that contains [text].
  static int numberOf(
    List<({String title, String text})> sources,
    String text,
  ) => sources.indexWhere((s) => s.text.contains(text)) + 1;
}
