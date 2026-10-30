import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:trip_buddy/data/ai/gemini_chat_writer.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/trip_chat.dart';

import '../helpers/fake_gemini.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  setUp(FakeGemini.reset);

  (GeminiChatWriter, FakeGemini) writer(http.Response Function() answer) {
    final gemini = FakeGemini(answer);
    return (
      GeminiChatWriter(FirebaseAI.googleAI(), httpClient: gemini.client),
      gemini,
    );
  }

  test('streams the answer; history goes first, without its [n]s', () async {
    final (chat, gemini) = writer(
      () => FakeGemini.sse(['The return ', 'is SQ322 [1].']),
    );

    final chunks = await chat
        .answer(
          history: const [
            ChatTurn(
              question: 'When does SQ321 land?',
              answer: 'At 18:05 [2].',
            ),
          ],
          question: 'And the return flight?',
          sources: [(title: 'Trip plan', text: 'Return: flight SQ322.')],
        )
        .toList();

    expect(chunks, ['The return ', 'is SQ322 [1].']);
    final contents = gemini.lastBody['contents']! as List;
    String text(int i) =>
        ((contents[i] as Map)['parts'] as List).single['text'] as String;
    expect(contents, hasLength(3));
    expect((contents[0] as Map)['role'], 'user');
    expect(text(0), 'When does SQ321 land?');
    expect((contents[1] as Map)['role'], 'model');
    expect(text(1), 'At 18:05.');
    expect(
      text(2),
      '<sources>\n'
      '[1] (Trip plan) Return: flight SQ322.\n'
      '</sources>\n'
      '<question>And the return flight?</question>',
    );
  });

  test('no connection is a NetworkFailure in the stream', () async {
    final (chat, _) = writer(
      () => throw http.ClientException('Failed host lookup'),
    );

    await expectLater(
      chat.answer(
        history: const [],
        question: 'Hi?',
        sources: [(title: 'A', text: 'B')],
      ),
      emitsError(isA<NetworkFailure>()),
    );
  });
}
