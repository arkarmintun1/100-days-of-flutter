import 'dart:convert';

import 'package:genui/genui.dart' show basicCatalogId;
import 'package:trip_buddy/domain/booking.dart';
import 'package:trip_buddy/domain/trip_chat.dart';

/// Streams prepared chunks instead of Gemini, for tests.
class FakeChatWriter implements ChatWriter {
  FakeChatWriter({
    this.chunks,
    this.reply,
    this.error,
    this.added = const [],
    this.hold,
  });

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

  /// Day 80: bookings "the model" added before answering.
  final List<Booking> added;

  final calls =
      <
        ({
          List<ChatTurn> history,
          String question,
          List<({String title, String text})> sources,
          List<String> appEvents,
        })
      >[];

  @override
  Stream<ChatEvent> answer({
    required List<ChatTurn> history,
    required String question,
    required List<({String title, String text})> sources,
    List<String> appEvents = const [],
  }) async* {
    calls.add((
      history: history,
      question: question,
      sources: sources,
      appEvents: appEvents,
    ));
    if (hold case final hold?) await hold;
    for (final booking in added) {
      yield BookingAdded(booking);
    }
    for (final chunk
        in chunks ?? [reply?.call(question, sources) ?? 'It says so [1].']) {
      yield TextChunk(chunk);
    }
    if (error case final error?) throw error;
  }
}

/// Day 83: the A2UI messages a model writes for one TripCountdown, each
/// in a ```json fence as GenUI's prompt asks (or [fenced]: false, one
/// JSON per line, as a model may write anyway).
List<String> countdownUi({
  required String title,
  required String startsAt,
  required String timeZone,
  String surfaceId = 'countdown',
  bool fenced = true,
}) => _a2ui(fenced, [
  '${jsonEncode({
    'version': 'v0.9',
    'createSurface': {'surfaceId': surfaceId, 'catalogId': basicCatalogId},
  })}\n',
  '${jsonEncode({
    'version': 'v0.9',
    'updateComponents': {
      'surfaceId': surfaceId,
      'components': [
        {'id': 'root', 'component': 'TripCountdown', 'title': title, 'startsAt': startsAt, 'timeZone': timeZone},
      ],
    },
  })}\n',
]);

/// One A2UI message per piece, fenced or as a JSON line.
List<String> _a2ui(bool fenced, List<String> lines) => [
  for (final line in lines) fenced ? '```json\n${line.trim()}\n```\n' : line,
];
