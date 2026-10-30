import 'package:trip_buddy/domain/trip_chat.dart';

/// Streams prepared chunks instead of Gemini, for tests.
class FakeChatWriter implements ChatWriter {
  FakeChatWriter({this.chunks, this.reply, this.error, this.hold});

  /// The answer, in pieces, like a stream from Gemini.
  final List<String>? chunks;

  /// Or: builds the answer from the question and the numbered sources.
  final String Function(
    String question,
    List<({String title, String text})> sources,
  )?
  reply;

  /// Thrown after the chunks. Not final: a test can fix the "network".
  Object? error;

  /// If set, the answer only starts when this completes.
  final Future<void>? hold;

  final calls =
      <
        ({
          List<ChatTurn> history,
          String question,
          List<({String title, String text})> sources,
        })
      >[];

  @override
  Stream<String> answer({
    required List<ChatTurn> history,
    required String question,
    required List<({String title, String text})> sources,
  }) async* {
    calls.add((history: history, question: question, sources: sources));
    if (hold case final hold?) await hold;
    for (final chunk
        in chunks ?? [reply?.call(question, sources) ?? 'It says so [1].']) {
      yield chunk;
    }
    if (error case final error?) throw error;
  }
}
