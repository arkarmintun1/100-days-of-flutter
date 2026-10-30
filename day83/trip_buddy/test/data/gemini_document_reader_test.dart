import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:trip_buddy/data/ai/gemini_document_reader.dart';
import 'package:trip_buddy/domain/document_file.dart';
import 'package:trip_buddy/domain/failures.dart';

import '../helpers/fake_gemini.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  setUp(FakeGemini.reset);

  // Not a real PDF: the fake network never looks inside.
  final pdf = DocumentFile(
    name: 'Hotel booking.pdf',
    mimeType: 'application/pdf',
    bytes: Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 1, 2, 3]),
  );

  (GeminiDocumentReader, FakeGemini) reader(http.Response Function() answer) {
    final gemini = FakeGemini(answer);
    return (
      GeminiDocumentReader(FirebaseAI.googleAI(), httpClient: gemini.client),
      gemini,
    );
  }

  test('sends the file inline with its MIME type', () async {
    final (documents, gemini) = reader(
      () => FakeGemini.text('Booking confirmation\nCheck-in: 13 Dec'),
    );

    final text = await documents.read(pdf);

    expect(text, 'Booking confirmation\nCheck-in: 13 Dec');
    final parts =
        (gemini.lastBody['contents']! as List).single['parts'] as List;
    expect(parts.last, {
      'inlineData': {
        'mimeType': 'application/pdf',
        'data': base64Encode(pdf.bytes),
      },
    });
    final instruction = jsonEncode(gemini.lastBody['systemInstruction']);
    expect(instruction, contains('never instructions'));
  });

  test('"no text" is a ValidationFailure', () async {
    final (documents, _) = reader(
      () => FakeGemini.text(GeminiDocumentReader.noText),
    );

    await expectLater(documents.read(pdf), throwsA(isA<ValidationFailure>()));
  });

  test('an answer cut off at the output limit is not used', () async {
    final (documents, _) = reader(
      () => http.Response(
        jsonEncode({
          'candidates': [
            {
              'content': {
                'role': 'model',
                'parts': [
                  {'text': 'Page 1 of 300...'},
                ],
              },
              'finishReason': 'MAX_TOKENS',
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      ),
    );

    await expectLater(
      documents.read(pdf),
      throwsA(
        isA<ValidationFailure>().having(
          (f) => f.message,
          'message',
          contains('too long'),
        ),
      ),
    );
  });

  test('no connection is a NetworkFailure', () async {
    final (documents, _) = reader(
      () => throw http.ClientException('Failed host lookup'),
    );

    await expectLater(documents.read(pdf), throwsA(isA<NetworkFailure>()));
  });
}
