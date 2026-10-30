import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:spendbook/data/ai/gemini_category_suggester.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';

/// The real firebase_ai SDK, with a fake HTTP client instead of the
/// network: it checks what we send and how we read what comes back.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks(); // Firebase without a real project

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  late List<http.Request> requests;

  GeminiCategorySuggester suggester(http.Response Function() answer) {
    requests = [];
    final client = MockClient((request) async {
      requests.add(request);
      return answer();
    });
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.8-flash',
      httpClient: client,
    );
    return GeminiCategorySuggester(model);
  }

  /// A generateContent answer in the Gemini API's JSON shape.
  http.Response gemini(String text) => http.Response(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'role': 'model',
            'parts': [
              {'text': text},
            ],
          },
          'finishReason': 'STOP',
        },
      ],
    }),
    200,
    headers: {'content-type': 'application/json'},
  );

  test('sends the title and reads the one-word answer', () async {
    final result = await suggester(
      () => gemini('Transport.\n'),
    ).suggest('Grab to the airport');

    expect(result.getRight().toNullable(), ExpenseCategory.transport);
    final request = requests.single;
    expect(
      request.url.path,
      endsWith('/models/gemini-3.8-flash:generateContent'),
    );
    expect(request.body, contains('Grab to the airport'));
  });

  test('an answer that is not a category is an AiFailure', () async {
    final result = await suggester(
      () => gemini('It looks like a taxi ride, so probably transport.'),
    ).suggest('Grab to the airport');

    expect(result.getLeft().toNullable(), isA<AiFailure>());
  });

  test('over the quota (429) is an AiFailure with a clear message', () async {
    final result = await suggester(
      () => http.Response(
        jsonEncode({
          'error': {
            'code': 429,
            'message': 'Resource has been exhausted (e.g. check quota).',
            'status': 'RESOURCE_EXHAUSTED',
          },
        }),
        429,
      ),
    ).suggest('Coffee');

    expect(
      result.getLeft().toNullable(),
      isA<AiFailure>().having(
        (f) => f.message,
        'message',
        'Too many requests. Try again later.',
      ),
    );
  });

  test('no connection is a NetworkFailure', () async {
    final result = await suggester(
      () => throw http.ClientException('Failed host lookup'),
    ).suggest('Coffee');

    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });
}
