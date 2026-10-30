import 'dart:developer';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';

import '../../domain/embedder.dart';
import '../../domain/failures.dart';

/// Calls a callable function and returns its result's data.
typedef CallFunction = Future<Object?> Function(Map<String, Object?> data);

/// Gets embeddings from our `embedTexts` Cloud Function (Day 75).
///
/// The function holds the Gemini API key: the app only sends texts, with
/// an App Check token the Firebase SDK attaches.
class CloudEmbedder implements Embedder {
  CloudEmbedder(this._call);

  /// The real one: `FirebaseFunctions.instance.httpsCallable(...)`.
  CloudEmbedder.firebase(FirebaseFunctions functions)
    : this((data) async {
        final callable = functions.httpsCallable('embedTexts');
        return (await callable.call<Object?>(data)).data;
      });

  final CallFunction _call;

  /// The most texts the function accepts in one call (its input schema).
  static const maxTextsPerCall = 50;

  @override
  Future<List<Float32List>> embed(List<String> texts, EmbedKind kind) async {
    final vectors = <Float32List>[];
    for (var start = 0; start < texts.length; start += maxTextsPerCall) {
      final batch = texts.sublist(
        start,
        min(start + maxTextsPerCall, texts.length),
      );
      final data = await _send({'texts': batch, 'kind': kind.name});
      vectors.addAll(_vectors(data, batch.length));
    }
    return vectors;
  }

  Future<Object?> _send(Map<String, Object?> data) async {
    try {
      return await _call(data);
    } on FirebaseFunctionsException catch (e, stackTrace) {
      log('embedTexts failed', error: e, stackTrace: stackTrace);
      throw switch (e.code) {
        // No network: 'unavailable' on Android, 'unknown' on iOS/macOS.
        'unavailable' ||
        'unknown' ||
        'deadline-exceeded' => const NetworkFailure(
          "Couldn't reach the server. Check your connection.",
        ),
        // enforceAppCheck: a missing or invalid App Check token.
        'unauthenticated' => const AiFailure("Couldn't verify this app."),
        'resource-exhausted' => const AiFailure(
          'Too many requests. Try again later.',
        ),
        _ => const AiFailure("Search isn't available right now."),
      };
    }
  }

  /// The function's answer is JSON: check it, like any outside data.
  static List<Float32List> _vectors(Object? data, int count) {
    if (data case final List<Object?> list when list.length == count) {
      return [
        for (final item in list)
          if (item case final List<Object?> numbers
              when numbers.isNotEmpty && numbers.every((n) => n is num))
            Float32List.fromList([
              for (final n in numbers) (n! as num).toDouble(),
            ])
          else
            throw const AiFailure('The search server sent an odd answer.'),
      ];
    }
    throw const AiFailure('The search server sent an odd answer.');
  }
}
