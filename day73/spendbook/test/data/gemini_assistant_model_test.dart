import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:spendbook/data/ai/gemini_assistant_model.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_gemini.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  setUp(FakeGemini.reset);

  test('streams the chunks and remembers the conversation', () async {
    final gemini = FakeGemini(() => FakeGemini.sse(['Hello', ' there.']));
    final model = GeminiAssistantModel(
      FirebaseAI.googleAI(),
      instructions: 'You are a test.',
      httpClient: gemini.client,
    );

    expect(await model.send('Hi').toList(), ['Hello', ' there.']);
    await model.send('And now?').toList();

    expect(gemini.lastUrl.path, endsWith(':streamGenerateContent'));
    expect(gemini.lastUrl.queryParameters['alt'], 'sse');
    // The 2nd request carries the 1st question and answer, then the new one.
    final contents = gemini.bodies.last['contents']! as List;
    expect(contents, hasLength(3));
    expect((contents[1] as Map)['role'], 'model');
    expect(
      gemini.bodies.last['systemInstruction'].toString(),
      contains('You are a test.'),
    );
  });

  test('errors in the stream become Failures', () async {
    final gemini = FakeGemini(
      () => throw http.ClientException('Failed host lookup'),
    );
    final model = GeminiAssistantModel(
      FirebaseAI.googleAI(),
      instructions: 'x',
      httpClient: gemini.client,
    );

    await expectLater(model.send('Hi'), emitsError(isA<NetworkFailure>()));
  });
}
