import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/expense_category.dart';
import '../../domain/failures.dart';
import '../../domain/repositories/category_suggester.dart';

/// Asks Gemini (through Firebase AI Logic) for an expense's category.
class GeminiCategorySuggester implements CategorySuggester {
  GeminiCategorySuggester(this._model);

  final GenerativeModel _model;

  static final _names = ExpenseCategory.values.map((c) => c.name).join(', ');

  @override
  Future<Either<Failure, ExpenseCategory>> suggest(String title) async {
    try {
      final response = await _model.generateContent([
        Content.text(
          'Which category fits this expense: "$title"? '
          'Answer with one word from this list: $_names.',
        ),
      ]);
      // The model writes text, so it may add a dot or a capital letter.
      final answer = (response.text ?? '').trim().toLowerCase().replaceAll(
        RegExp(r'[^a-z]'),
        '',
      );
      final category = ExpenseCategory.values.asNameMap()[answer];
      if (category == null) {
        log('Unexpected category answer: ${response.text}');
        return left(const AiFailure("Couldn't suggest a category."));
      }
      return right(category);
    } on FirebaseAIException catch (e, stackTrace) {
      log('Gemini error', error: e, stackTrace: stackTrace);
      return left(
        AiFailure(switch (e) {
          QuotaExceeded() => 'Too many requests. Try again later.',
          ServiceApiNotEnabled() ||
          InvalidApiKey() => 'AI Logic isn\'t set up in this Firebase project.',
          _ => "Couldn't suggest a category.",
        }),
      );
    } on FirebaseAISdkException catch (e, stackTrace) {
      // The SDK couldn't read the server's answer.
      log('Gemini SDK error', error: e, stackTrace: stackTrace);
      return left(const AiFailure("Couldn't suggest a category."));
    } on FirebaseException catch (e, stackTrace) {
      // Getting the App Check token failed (e.g. an unregistered debug
      // token), before the request was even sent.
      log('Firebase error', error: e, stackTrace: stackTrace);
      return left(const AiFailure("Couldn't verify this app. Try again."));
    } on http.ClientException catch (e, stackTrace) {
      // No connection: package:http wraps the socket error.
      log('Gemini request failed', error: e, stackTrace: stackTrace);
      return left(
        const NetworkFailure("Couldn't reach the AI. Check your connection."),
      );
    }
  }
}
