import 'dart:async';

import 'package:a2ui_core/a2ui_core.dart' show A2uiMessage;
import 'package:genui/genui.dart';

/// GenUI's [Transport], with a new A2UI parser for every answer (Day 73).
///
/// GenUI's A2uiTransportAdapter keeps one parser for the whole chat. An
/// answer that stops in the middle of a JSON message would stay in its
/// buffer, and the next answer would be read as part of it.
class AnswerTransport implements Transport {
  AnswerTransport({required this._onSend});

  final Future<void> Function(ChatMessage message) _onSend;
  final _text = StreamController<String>.broadcast();
  final _messages = StreamController<A2uiMessage>.broadcast();

  /// The answer being read, so [cancel] can stop it.
  StreamSubscription<GenerationEvent>? _answer;
  Completer<void>? _reading;

  @override
  Stream<String> get incomingText => _text.stream;

  @override
  Stream<A2uiMessage> get incomingMessages => _messages.stream;

  /// The Conversation calls this for typed questions and for taps on
  /// buttons in a generated surface.
  @override
  Future<void> sendRequest(ChatMessage message) => _onSend(message);

  /// Reads one answer to its end, with a parser of its own. Completes
  /// with an [A2uiValidationException] for a malformed A2UI message, or
  /// with the model's error.
  Future<void> read(Stream<String> answer) {
    final reading = _reading = Completer<void>();
    _answer = answer
        .expand(piecesAtBraces)
        .transform(const A2uiParserTransformer())
        .listen(
          (event) {
            switch (event) {
              case TextEvent(:final text):
                _text.add(text);
              case A2uiMessageEvent(:final message):
                _messages.add(message);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            _answer = null;
            if (!reading.isCompleted) reading.completeError(error, stackTrace);
          },
          onDone: () {
            _answer = null;
            if (!reading.isCompleted) reading.complete();
          },
          // The first error ends the answer.
          cancelOnError: true,
        );
    return reading.future;
  }

  /// Stops reading the current answer (the screen is gone): nothing more
  /// reaches the UI. It doesn't abort the request: firebase_ai's
  /// ChatSession still reads the response to its end in the background.
  void cancel() {
    final answer = _answer;
    _answer = null;
    if (_reading case final reading? when !reading.isCompleted) {
      reading.complete();
    }
    unawaited(answer?.cancel());
  }

  @override
  void dispose() {
    cancel();
    _text.close();
    _messages.close();
  }
}

/// Cuts a chunk of the answer before every `{`: "a {b} {c}" becomes
/// "a ", "{b} ", "{c}".
///
/// GenUI's prompt asks for each message in a ```json fence, and genui
/// 0.10.4's parser finds a fence anywhere in what it holds. JSON without
/// a fence (a model may skip it) is only found at the start: a chunk with
/// text and a whole unfenced message would leave the message waiting for
/// more, and if it was the last chunk, it would come out as text.
Iterable<String> piecesAtBraces(String chunk) sync* {
  var start = 0;
  for (var i = 1; i < chunk.length; i++) {
    if (chunk[i] == '{') {
      yield chunk.substring(start, i);
      start = i;
    }
  }
  yield chunk.substring(start);
}
