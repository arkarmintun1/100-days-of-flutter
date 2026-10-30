import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import '../../domain/failures.dart';

/// Runs a Gemini request and turns what can go wrong into Failures
/// (Day 78: shared by the document reader and the answer writer).
Future<T> askGemini<T>(Future<T> Function() request) async {
  try {
    return await request();
  } catch (e, stackTrace) {
    final failure = _failure(e, stackTrace);
    if (failure == null) rethrow;
    throw failure;
  }
}

/// The same for a streamed answer (Day 79).
Stream<T> askGeminiStream<T>(Stream<T> Function() request) async* {
  try {
    // Not `yield*`: it would pass the stream's errors straight on,
    // without reaching this catch.
    await for (final event in request()) {
      yield event;
    }
  } catch (e, stackTrace) {
    final failure = _failure(e, stackTrace);
    if (failure == null) rethrow;
    throw failure;
  }
}

/// A Failure for what Gemini (or the SDK, or the network) threw, or null
/// for anything else: a bug, which should stay a crash.
Failure? _failure(Object e, StackTrace stackTrace) {
  switch (e) {
    case final Failure failure:
      return failure; // ours already, e.g. "too long"
    case FirebaseAIException():
      log('Gemini error', error: e, stackTrace: stackTrace);
      return AiFailure(switch (e) {
        QuotaExceeded() => 'Too many requests. Try again later.',
        ServiceApiNotEnabled() ||
        InvalidApiKey() => "AI Logic isn't set up in this Firebase project.",
        _ => "The AI request failed. Try again.",
      });
    case FirebaseAISdkException():
      // The SDK couldn't parse the answer.
      log('Odd answer from Gemini', error: e, stackTrace: stackTrace);
      return const AiFailure("The AI's answer didn't make sense. Try again.");
    case FirebaseException():
      // Getting the App Check token failed, before anything was sent.
      log('App Check failed', error: e, stackTrace: stackTrace);
      return const AiFailure("Couldn't verify this app.");
    case http.ClientException():
      log('Gemini request failed', error: e, stackTrace: stackTrace);
      return const NetworkFailure(
        "Couldn't reach the AI. Check your connection.",
      );
    default:
      return null;
  }
}

/// User text goes between tags like `<question>...</question>`. Without
/// `<` and `>`, it can't close the tag and pretend to be the prompt.
String withoutTags(String text) => text.replaceAll(RegExp('[<>]'), '');
