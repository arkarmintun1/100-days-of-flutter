import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/ai/gemini_insight_writer.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/summarize_month.dart';

import '../helpers/fake_gemini.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  final october = DateTime(2026, 10);
  final expenses = [
    Expense(
      id: '1',
      title: 'Groceries',
      amountCents: 4520,
      category: ExpenseCategory.food,
      date: DateTime(2026, 10, 27),
    ),
    Expense(
      id: '2',
      title: 'Bus card top-up',
      amountCents: 2000,
      category: ExpenseCategory.transport,
      date: DateTime(2026, 10, 26),
    ),
  ];
  final summary = const SummarizeMonth()(expenses, year: 2026, month: 10);

  test('sends the month as data and reads the JSON answer', () async {
    final gemini = FakeGemini(
      () => FakeGemini.text(
        jsonEncode({
          'headline': 'Food leads your October',
          'tip': 'Plan two home-cooked dinners a week.',
        }),
      ),
    );
    final writer = GeminiInsightWriter(
      FirebaseAI.googleAI(),
      httpClient: gemini.client,
    );

    final result = await writer.write(
      month: october,
      summary: summary,
      biggest: expenses,
      budgetCents: 50000,
    );

    final insight = result.getRight().toNullable()!;
    expect(insight.headline, 'Food leads your October');
    expect(insight.tip, 'Plan two home-cooked dinners a week.');

    final body = gemini.lastBody;
    expect(jsonEncode(body['systemInstruction']), contains('money coach'));
    final config = body['generationConfig']! as Map;
    expect(config['responseMimeType'], 'application/json');
    final schema = config['responseSchema']! as Map;
    expect((schema['properties']! as Map).keys, ['headline', 'tip']);
    // Firebase AI Logic: every property is required unless listed as
    // optional.
    expect(schema['required'], ['headline', 'tip']);

    final prompt = jsonEncode(gemini.lastBody['contents']);
    expect(prompt, contains('Month: October 2026'));
    expect(prompt, contains(r'Total: $65.20'));
    expect(prompt, contains(r'Budget: $500.00'));
    expect(prompt, contains(r'food $45.20, transport $20.00'));
    expect(prompt, contains(r'- $45.20 Groceries'));
  });

  test('a missing field is an AiFailure', () async {
    final gemini = FakeGemini(
      () => FakeGemini.text(jsonEncode({'headline': 'Hi'})),
    );
    final writer = GeminiInsightWriter(
      FirebaseAI.googleAI(),
      httpClient: gemini.client,
    );

    final result = await writer.write(
      month: october,
      summary: summary,
      biggest: expenses,
    );

    expect(result.getLeft().toNullable(), isA<AiFailure>());
  });
}
