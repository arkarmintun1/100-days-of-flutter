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
  } on FirebaseAIException catch (e, stackTrace) {
    log('Gemini error', error: e, stackTrace: stackTrace);
    throw AiFailure(switch (e) {
      QuotaExceeded() => 'Too many requests. Try again later.',
      ServiceApiNotEnabled() ||
      InvalidApiKey() => "AI Logic isn't set up in this Firebase project.",
      _ => "The AI request failed. Try again.",
    });
  } on FirebaseAISdkException catch (e, stackTrace) {
    // The SDK couldn't parse the answer.
    log('Odd answer from Gemini', error: e, stackTrace: stackTrace);
    throw const AiFailure("The AI's answer didn't make sense. Try again.");
  } on FirebaseException catch (e, stackTrace) {
    // Getting the App Check token failed, before anything was sent.
    log('App Check failed', error: e, stackTrace: stackTrace);
    throw const AiFailure("Couldn't verify this app.");
  } on http.ClientException catch (e, stackTrace) {
    log('Gemini request failed', error: e, stackTrace: stackTrace);
    throw const NetworkFailure("Couldn't reach the AI. Check your connection.");
  }
}

/// User text goes between tags like `<question>...</question>`. Without
/// `<` and `>`, it can't close the tag and pretend to be the prompt.
String withoutTags(String text) => text.replaceAll(RegExp('[<>]'), '');
