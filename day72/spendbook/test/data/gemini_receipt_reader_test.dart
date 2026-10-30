import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/ai/gemini_receipt_reader.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_gemini.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // Not a real JPEG: the fake network never looks inside.
  final photo = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0, 1, 2, 3]);

  (GeminiReceiptReader, FakeGemini) reader(Map<String, Object?> answer) {
    final gemini = FakeGemini(() => FakeGemini.text(jsonEncode(answer)));
    return (
      GeminiReceiptReader(
        FirebaseAI.googleAI(),
        httpClient: gemini.client,
        readBytes: (_) async => photo,
      ),
      gemini,
    );
  }

  test('sends the photo with its MIME type and reads the fields', () async {
    final (ai, gemini) = reader({
      'merchant': 'Kopi Corner',
      'total': '10.25',
      'currency': 'SGD',
      'date': '2026-10-27',
      'category': 'food',
    });

    final draft = (await ai.read('/tmp/receipt.jpg')).getRight().toNullable()!;

    expect(draft.merchant, 'Kopi Corner');
    expect(draft.total, '10.25');
    expect(draft.currency, 'SGD');
    expect(draft.date, DateTime(2026, 10, 27));
    expect(draft.category, ExpenseCategory.food);

    final parts =
        (gemini.lastBody['contents']! as List).single['parts'] as List;
    expect(parts.first, {'text': 'Read this receipt.'});
    expect(parts.last, {
      'inlineData': {'mimeType': 'image/jpeg', 'data': base64Encode(photo)},
    });
    // Only the category is required: the rest may be unreadable.
    final schema =
        (gemini.lastBody['generationConfig']! as Map)['responseSchema'] as Map;
    expect(schema['required'], ['category']);
  });

  test('values that look wrong are dropped, not guessed', () async {
    final (ai, _) = reader({
      'merchant': '  ',
      'total': 'about 10 dollars',
      'currency': 'S\$',
      'date': '2026-02-30', // there's no February 30th
      'category': 'groceries', // not one of ours
    });

    final draft = (await ai.read('/tmp/receipt.png')).getRight().toNullable()!;

    expect(draft.merchant, isNull);
    expect(draft.total, isNull);
    expect(draft.currency, isNull);
    expect(draft.date, isNull);
    expect(draft.category, isNull);
  });

  test('commas and lower case are cleaned up', () async {
    final (ai, _) = reader({'total': '1,028.40', 'currency': 'usd'});

    final draft = (await ai.read('/tmp/receipt.webp')).getRight().toNullable()!;

    expect(draft.total, '1028.40');
    expect(draft.currency, 'USD');
  });

  test('a comma that is not a thousands separator is dropped', () async {
    for (final total in ['10,25', '1,02,840.00', '1,0284.40', ',5']) {
      final (ai, _) = reader({'total': total});

      final draft = (await ai.read(
        '/tmp/receipt.jpg',
      )).getRight().toNullable()!;

      expect(draft.total, isNull, reason: total);
    }
  });

  test('a format Gemini does not take is rejected before sending', () async {
    final (ai, _) = reader({});

    final result = await ai.read('/tmp/receipt.heic');

    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
  });
}
