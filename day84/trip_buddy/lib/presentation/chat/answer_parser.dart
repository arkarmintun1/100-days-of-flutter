import 'dart:async';

import 'package:a2ui_core/a2ui_core.dart' show CreateSurfaceMessage;
import 'package:genui/genui.dart';

/// Splits one chat answer into its text and its UI (Day 83), as it
/// streams: a new A2UI parser for every answer (Spendbook, Day 73).
class AnswerParser {
  AnswerParser(Catalog catalog, {required this.onChanged})
    : surfaces = SurfaceController(catalogs: [catalog]) {
    _events = _input.stream
        .transform(const A2uiParserTransformer())
        .listen(_onEvent, onError: _onError);
    // What the surfaces couldn't use (a repeated surface ID, a component
    // that doesn't fit the catalog...) is reported here, as a message for
    // the model. Trip Buddy has no buttons in its catalog, so everything
    // that arrives here is such an error.
    _reports = surfaces.onSubmit.listen(_onError);
  }

  /// This answer's surfaces. Every answer has its own, so a surface ID
  /// the model used before ("countdown") can't clash with an older one.
  final SurfaceController surfaces;

  /// Called whenever [text], [surfaceIds] or [error] changes.
  final void Function() onChanged;

  final _input = StreamController<String>();
  late final StreamSubscription<GenerationEvent> _events;
  late final StreamSubscription<ChatMessage> _reports;
  var _fed = 0;

  /// Backticks at the end of what arrived, kept until more comes: they
  /// may be the start of a ```json fence.
  var _held = '';

  /// The answer's text, without the A2UI JSON.
  var text = '';

  /// The answer's UI, in order.
  final surfaceIds = <String>[];

  /// The first thing in the answer that couldn't be shown: a malformed
  /// A2UI message, or one the surfaces couldn't use.
  Object? error;

  /// Takes the answer so far (each ChatReply has the whole text) and
  /// parses only what's new.
  void update(String answerSoFar) {
    if (answerSoFar.length <= _fed) return;
    var added = _held + answerSoFar.substring(_fed);
    _fed = answerSoFar.length;
    // GenUI 0.10.4's parser finds a ```json fence anywhere in what it
    // holds, but only half of one ("``") is passed on as text. Hold back
    // trailing backticks until the next piece shows what they are.
    // Exactly one or two: "```" already starts a fence the parser knows.
    final kept = added.replaceFirst(RegExp(r'(?<!`)`{1,2}$'), '');
    _held = added.substring(kept.length);
    added = kept;
    if (added.isEmpty) return;
    // Unfenced JSON (the prompt asks for fences, but a model may skip
    // them) is only found at the start of what the parser holds. Text and
    // a whole message in one piece would leave the message waiting, and if
    // nothing more came, it would be shown as text. So every `{` starts a
    // new piece.
    var start = 0;
    for (var i = 1; i < added.length; i++) {
      if (added[i] == '{') {
        _input.add(added.substring(start, i));
        start = i;
      }
    }
    _input.add(added.substring(start));
  }

  /// The answer is complete: text the parser was holding back comes out.
  void close() {
    if (_held.isNotEmpty) _input.add(_held);
    _held = '';
    _input.close();
  }

  void dispose() {
    _events.cancel();
    _reports.cancel();
    _input.close();
    surfaces.dispose();
  }

  void _onEvent(GenerationEvent event) {
    switch (event) {
      case TextEvent(text: final chunk):
        text += chunk;
      case A2uiMessageEvent(:final message):
        surfaces.handleMessage(message);
        // The same ID twice in one answer: one Surface (the controller
        // rejects the second, and two widgets with one key would clash).
        if (message case CreateSurfaceMessage(
          :final surfaceId,
        ) when !surfaceIds.contains(surfaceId)) {
          surfaceIds.add(surfaceId);
        }
    }
    onChanged();
  }

  void _onError(Object e) {
    // Only the first: a Surface reports a broken component every time it
    // builds, and onChanged rebuilds it.
    if (error != null) return;
    error = e;
    onChanged();
  }
}
