import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../domain/failures.dart';

// Shared by the Gemini classes (Day 71): one place for the error messages.

/// User text goes between tags like <title>...</title>. Without < and >,
/// it can't close the tag and pretend to be part of the prompt.
String withoutTags(String text) => text.replaceAll(RegExp('[<>]'), '');

/// An error the AI service (or the SDK) reported.
AiFailure aiFailure(Object error, StackTrace stackTrace) {
  log('Gemini error', error: error, stackTrace: stackTrace);
  return AiFailure(switch (error) {
    QuotaExceeded() => 'Too many requests. Try again later.',
    // Getting the App Check token failed before the request was even sent:
    // offline with no saved token, or an App Check setup problem (e.g. an
    // unregistered debug token).
    FirebaseException() => appCheckFailed.message,
    ServiceApiNotEnabled() ||
    InvalidApiKey() => "AI Logic isn't set up in this Firebase project.",
    _ => "The AI couldn't answer. Try again.",
  });
}

/// The model answered, but not in the shape we asked for.
AiFailure unexpectedAnswer(Object? answer) {
  log('Unexpected answer from Gemini: $answer');
  return const AiFailure("The AI's answer didn't make sense. Try again.");
}

/// No App Check token (Day 72): see [aiFailure]. One constant, so the
/// receipt scan can tell it apart from the other AI failures.
const appCheckFailed = AiFailure("Couldn't verify this app. Try again.");

const noConnection = NetworkFailure(
  "Couldn't reach the AI. Check your connection.",
);
