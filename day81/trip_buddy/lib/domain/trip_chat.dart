import 'answer.dart';
import 'ask_trip.dart';
import 'booking.dart';
import 'failures.dart';
import 'hybrid_search.dart';
import 'search_memory.dart';

/// One question and its answer, for the chat's history.
class ChatTurn {
  const ChatTurn({required this.question, required this.answer});
  final String question;
  final String answer;
}

/// What a chat writer streams (Day 80): text, or something it did.
sealed class ChatEvent {
  const ChatEvent();
}

final class TextChunk extends ChatEvent {
  const TextChunk(this.text);
  final String text;
}

final class BookingAdded extends ChatEvent {
  const BookingAdded(this.booking);
  final Booking booking;
}

/// Writes an answer as it is generated (Day 79), from numbered sources
/// and the chat so far, and may run app functions (Day 80). Throws a
/// Failure in the stream.
abstract interface class ChatWriter {
  Stream<ChatEvent> answer({
    required List<ChatTurn> history,
    required String question,
    required List<({String title, String text})> sources,
    List<String> appEvents = const [],
  });
}

/// An answer so far, and the bookings added while answering (Day 80).
class ChatReply extends Answer {
  const ChatReply({
    required super.text,
    required super.sources,
    this.added = const [],
  });

  final List<Booking> added;
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

  /// Day 80: what the user did outside the chat (an Undo), told to the
  /// model with the next question (Spendbook, Day 74).
  final _appEvents = <String>[];

  /// Questions and answers sent with each new question. More context,
  /// more tokens on every message: the oldest ones are left out.
  static const maxHistory = 6;

  /// The answer as it grows: every event has the text so far. Throws a
  /// Failure in the stream; a failed question is not kept in the history.
  Stream<ChatReply> ask(String question) async* {
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
    // Day 80: no documents is fine now: the model can still add bookings
    // and tell the time. It's told it has no sources.
    final history = _history.length > maxHistory
        ? _history.sublist(_history.length - maxHistory)
        : List.of(_history);
    final events = List.of(_appEvents);
    var answer = '';
    final added = <Booking>[];
    try {
      await for (final event in _writer.answer(
        history: history,
        question: text,
        sources: _numbered(hits),
        appEvents: events,
      )) {
        switch (event) {
          case TextChunk(:final text):
            answer += text;
          case BookingAdded(:final booking):
            added.add(booking);
        }
        yield ChatReply(text: answer, sources: hits, added: List.of(added));
      }
    } catch (_) {
      // Bookings saved before the answer failed stay saved. Tell the model
      // with the next question, so trying again doesn't add them twice.
      if (conversation == _conversation) {
        for (final booking in added) {
          _appEvents.add(
            'Before your last answer failed, the app saved the booking '
            '"${booking.title}" (id ${booking.id}).',
          );
        }
      }
      rethrow;
    }
    // "New chat" while answering: this turn belongs to the old chat.
    if (conversation != _conversation) return;
    _history.add(ChatTurn(question: text, answer: answer));
    _appEvents.removeRange(0, events.length); // the model knows now
  }

  /// The user undid a booking the model added: tell it next time.
  void noteUndone(Booking booking) => _appEvents.add(
    'The user undid the booking "${booking.title}" (id ${booking.id}): '
    'it was deleted.',
  );

  /// Starts over: the next question has no history.
  void clear() {
    _conversation++;
    _history.clear();
    _appEvents.clear();
  }

  static List<({String title, String text})> _numbered(List<SearchHit> hits) =>
      [
        for (final hit in hits)
          (title: hit.chunk.documentTitle, text: hit.chunk.text),
      ];
}
