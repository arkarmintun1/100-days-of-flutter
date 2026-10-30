import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/ai/gemini_place_finder.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/trip_place.dart';

import '../helpers/fake_gemini.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  setUp(FakeGemini.reset);

  (GeminiPlaceFinder, FakeGemini) finder(String answer) {
    final gemini = FakeGemini(() => FakeGemini.text(answer));
    return (
      GeminiPlaceFinder(FirebaseAI.googleAI(), httpClient: gemini.client),
      gemini,
    );
  }

  test('sends the document, reads the places from the JSON', () async {
    final (places, gemini) = finder(
      jsonEncode({
        'places': [
          {
            'name': 'Parkroyal Collection Pickering',
            'kind': 'hotel',
            'address': '3 Upper Pickering Street, Singapore',
          },
          {
            'name': 'Maxwell Food Centre',
            'kind': 'food',
            'address': 'Maxwell Food Centre, Singapore',
          },
        ],
      }),
    );

    final found = await places.find(
      title: 'Trip plan',
      text: 'Hotel: Parkroyal Collection Pickering, 3 Upper Pickering Street.',
    );

    expect(found.map((p) => (p.name, p.kind, p.documentTitle)), [
      ('Parkroyal Collection Pickering', PlaceKind.hotel, 'Trip plan'),
      ('Maxwell Food Centre', PlaceKind.food, 'Trip plan'),
    ]);
    final prompt =
        ((gemini.lastBody['contents']! as List).single['parts'] as List)
                .single['text']
            as String;
    expect(prompt, startsWith('<document title="Trip plan">\n'));
    final config = gemini.lastBody['generationConfig']! as Map;
    expect(config['responseMimeType'], 'application/json');
  });

  test('values that look wrong are skipped or made "other"', () async {
    final (places, _) = finder(
      jsonEncode({
        'places': [
          {'name': ' ', 'kind': 'hotel', 'address': 'Somewhere'},
          {'name': 'Night Safari', 'kind': 'zoo', 'address': 'Singapore'},
          {'name': 'No address', 'kind': 'sight'},
        ],
      }),
    );

    final found = await places.find(title: 'Guide', text: '...');

    expect(found.single.name, 'Night Safari');
    expect(found.single.kind, PlaceKind.other);
  });

  test('an answer that is not the JSON asked for is an AiFailure', () async {
    final (places, _) = finder('Here are the places: ...');

    await expectLater(
      places.find(title: 'Guide', text: '...'),
      throwsA(isA<AiFailure>()),
    );
  });
}
