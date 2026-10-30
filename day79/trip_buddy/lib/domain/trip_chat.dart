import 'answer.dart';
import 'ask_trip.dart';
import 'failures.dart';
import 'search_memory.dart';

/// One question and its answer, for the chat's history.
class ChatTurn {
  const ChatTurn({required this.question, required this.answer});
  final String question;
  final String answer;
}

/// Writes an answer as it is generated (Day 79), from numbered sources
/// and the chat so far. Throws a Failure in the stream.
abstract interface class ChatWriter {
  Stream<String> answer({
    required List<ChatTurn> history,
    required String question,
    required List<({String title, String text})> sources,
  });
}

/// A conversation about the trip (Day 79): RAG on every question, and
/// the earlier questions and answers as context.
class TripChat {
  TripChat(this._search, this._writer);

  final SearchMemory _search;
  final ChatWriter _writer;
  final _history = <ChatTurn>[];

  /// Goes up with every clear(): an answer still on its way from before
  /// "New chat" isn't kept in the new conversation.
  var _conversation = 0;

  /// Questions and answers sent with each new question. More context,
  /// more tokens on every message: the oldest ones are left out.
  static const maxHistory = 6;

  /// The answer as it grows: every event has the text so far. Throws a
  /// Failure in the stream; a failed question is not kept in the history.
  Stream<Answer> ask(String question) async* {
    final text = question.trim();
    if (text.isEmpty) throw const ValidationFailure('Ask a question.');
    final conversation = _conversation;
    // A follow-up like "and the return flight?" says little alone: search
    // with the question before it too.
    final previous = _history.isEmpty ? null : _history.last.question;
    final hits = await _search(
      previous == null ? text : '$previous $text',
      top: AskTrip.top,
    );
    // "New chat" while searching: don't ask the model at all.
    if (conversation != _conversation) return;
    if (hits.isEmpty) {
      yield const Answer(text: AskTrip.notFound, sources: []);
      return; // nothing to talk about: not kept either
    }
    final history = _history.length > maxHistory
        ? _history.sublist(_history.length - maxHistory)
        : List.of(_history);
    var answer = '';
    await for (final chunk in _writer.answer(
      history: history,
      question: text,
      sources: [
        for (final hit in hits)
          (title: hit.chunk.documentTitle, text: hit.chunk.text),
      ],
    )) {
      answer += chunk;
      yield Answer(text: answer, sources: hits);
    }
    // "New chat" while answering: this turn belongs to the old chat.
    if (conversation != _conversation) return;
    _history.add(ChatTurn(question: text, answer: answer));
  }

  /// Starts over: the next question has no history.
  void clear() {
    _conversation++;
    _history.clear();
  }
}
