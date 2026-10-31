import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import '../../domain/failures.dart';
import '../../domain/repositories/assistant_model.dart';
import 'ai_errors.dart';
import 'assistant_tools.dart';

/// A Gemini chat (Day 73) that can call app functions (Day 74).
class GeminiAssistantModel implements AssistantModel {
  GeminiAssistantModel(
    FirebaseAI ai, {
    required String instructions,
    AssistantTools? tools,
    http.Client? httpClient,
  }) : _tools = tools {
    _model = ai.generativeModel(
      model: 'gemini-3.8-flash',
      systemInstruction: Content.system(instructions),
      tools: tools == null
          ? null
          : [Tool.functionDeclarations(tools.declarations)],
      httpClient: httpClient,
    );
    _chat = _model.startChat();
  }

  final AssistantTools? _tools;
  late final GenerativeModel _model;

  /// Keeps the history: every message is sent with the ones before it.
  late ChatSession _chat;
  final _actions = StreamController<AssistantAction>.broadcast();

  /// Model → function call → app → result → model... at most this often
  /// for one message, so a confused model can't loop forever.
  static const maxToolRounds = 5;

  @override
  Stream<AssistantAction> get actions => _actions.stream;

  var _closed = false;

  @override
  void close() {
    _closed = true;
    _actions.close();
  }

  @override
  Stream<String> send(String message) async* {
    _tools?.newMessage();
    final historyLength = _chat.history.length;
    // What this message has already done in the app.
    final saved = <ExpenseAdded>[];
    void report(AssistantAction action) {
      if (action case final ExpenseAdded added) saved.add(added);
      if (!_actions.isClosed) _actions.add(action);
    }

    try {
      var response = await _chat.sendMessage(Content.text(message));
      // The agent loop: while Gemini asks for functions, run them and
      // send the results back. It then answers with what happened.
      for (var round = 0; response.functionCalls.isNotEmpty; round++) {
        final tools = _tools;
        if (tools == null || round == maxToolRounds) {
          throw const AiFailure("The assistant couldn't finish. Try again.");
        }
        // Several calls in one answer (parallel function calling): run
        // them one by one, in order, so a read after an add sees the new
        // expense. Then answer them together, matched by name and id.
        final calls = response.functionCalls.toList();
        final results = <Map<String, Object?>>[];
        for (final call in calls) {
          // The screen closed while we waited for Gemini: run nothing
          // more. (Cancelling the stream doesn't stop this function while
          // it waits at an `await`; it only stops at the next `yield`.)
          if (_closed) return;
          results.add(await tools.run(call, report));
        }
        response = await _chat.sendMessage(
          Content.functionResponses([
            for (final (i, call) in calls.indexed)
              FunctionResponse(call.name, results[i], id: call.id),
          ]),
        );
      }
      yield response.text ?? '';
    } catch (e, stackTrace) {
      // The history may now end with a function call nobody answered.
      // Gemini expects an answer to it, so the next message would fail:
      // start again from the history before this message. If something
      // was already saved, keep this message with a note of it, so a
      // "try again" doesn't add the same expense twice.
      _chat = _model.startChat(
        history: [
          ..._chat.history.take(historyLength),
          if (saved.isNotEmpty) ...[
            Content.text(message),
            Content.model([TextPart(_savedNote(saved))]),
          ],
        ],
      );
      final failure = switch (e) {
        final Failure failure => failure,
        http.ClientException() => noConnection,
        FirebaseAIException() ||
        FirebaseAISdkException() ||
        FirebaseException() => aiFailure(e, stackTrace),
        _ => null,
      };
      if (failure == null) rethrow;
      if (saved.isEmpty) throw failure;
      // Tell the user what did happen: the expense (with its Undo) is
      // already in the chat.
      final what = saved.length == 1
          ? 'The expense above was saved'
          : 'The ${saved.length} expenses above were saved';
      throw AiFailure(
        "$what, but the answer didn't finish. ${failure.message}",
      );
    }
  }

  /// For the history: what an unfinished answer already did.
  static String _savedNote(List<ExpenseAdded> saved) => [
    'Before an error cut this answer off, these expenses were saved:',
    for (final ExpenseAdded(:expense) in saved)
      '- "${expense.title}", ${(expense.amountCents / 100).toStringAsFixed(2)} '
          'USD, ${expense.category.name}, id ${expense.id}',
  ].join('\n');
}
