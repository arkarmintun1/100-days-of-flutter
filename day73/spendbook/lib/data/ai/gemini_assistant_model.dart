import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import '../../domain/repositories/assistant_model.dart';
import 'ai_errors.dart';

/// A Gemini chat, streamed (Day 73). [instructions] come from the
/// presentation layer: for GenUI they describe the widgets it may use.
class GeminiAssistantModel implements AssistantModel {
  GeminiAssistantModel(
    FirebaseAI ai, {
    required String instructions,
    http.Client? httpClient,
  }) : _chat = ai
           .generativeModel(
             model: 'gemini-3.8-flash',
             systemInstruction: Content.system(instructions),
             httpClient: httpClient,
           )
           .startChat();

  /// Keeps the history: every message is sent with the ones before it.
  final ChatSession _chat;

  @override
  Stream<String> send(String message) => _chat
      .sendMessageStream(Content.text(message))
      .map((response) => response.text ?? '')
      .handleError((Object error, StackTrace stackTrace) {
        // The stream's errors become Failures, like everywhere else.
        throw switch (error) {
          http.ClientException() => noConnection,
          FirebaseAIException() ||
          FirebaseAISdkException() ||
          FirebaseException() => aiFailure(error, stackTrace),
          _ => error,
        };
      });
}
