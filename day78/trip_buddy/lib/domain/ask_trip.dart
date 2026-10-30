import 'answer.dart';
import 'failures.dart';
import 'search_memory.dart';

/// Retrieval-augmented generation (Day 78): find the chunks that match
/// the question (Day 76), then let the model answer from them only.
/// Throws a Failure.
class AskTrip {
  AskTrip(this._search, this._writer);

  final SearchMemory _search;
  final AnswerWriter _writer;

  /// What the model is told to say when the sources don't have the
  /// answer, and what we say when there are no sources at all.
  static const notFound = "I couldn't find that in your documents.";

  /// How many chunks go into the prompt: enough to cover a question
  /// whose answer is in two places, few enough to keep the prompt small.
  static const top = 5;

  Future<Answer> call(String question) async {
    final text = question.trim();
    if (text.isEmpty) throw const ValidationFailure('Ask a question.');
    final hits = await _search(text, top: top);
    // Nothing memorized: don't ask the model (it would only guess).
    if (hits.isEmpty) return const Answer(text: notFound, sources: []);
    final answer = await _writer.write(
      question: text,
      sources: [
        for (final hit in hits)
          (title: hit.chunk.documentTitle, text: hit.chunk.text),
      ],
    );
    return Answer(text: answer, sources: hits);
  }
}
