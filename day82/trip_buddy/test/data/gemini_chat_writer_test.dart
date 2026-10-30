import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:trip_buddy/data/ai/gemini_chat_writer.dart';
import 'package:trip_buddy/data/ai/trip_tools.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/nearby.dart';
import 'package:trip_buddy/domain/trip_chat.dart';

import '../helpers/fake_gemini.dart';
import '../helpers/fake_itinerary.dart';
import '../helpers/fake_location.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  setUp(FakeGemini.reset);

  late FakeItinerary itinerary;
  late FakeGemini gemini;

  GeminiChatWriter writer(List<http.Response> answers) {
    itinerary = FakeItinerary();
    gemini = FakeGemini(
      () => answers.isEmpty
          ? throw http.ClientException('Failed host lookup')
          : answers.removeAt(0),
    );
    return GeminiChatWriter(
      FirebaseAI.googleAI(),
      TripTools(
        itinerary: itinerary,
        now: () => DateTime.utc(2026, 10, 30, 12, 15),
        homeTimeZone: () async => 'Asia/Yangon',
        nearby: FindNearby(FakePlaceStore(), FakeLocationService()),
      ),
      httpClient: gemini.client,
    );
  }

  /// A streamed answer that asks for one function (Day 80).
  http.Response callStream(String name, Map<String, Object?> args) =>
      http.Response(
        'data: ${jsonEncode({
          'candidates': [
            {
              'content': {
                'role': 'model',
                'parts': [
                  {
                    'functionCall': {'name': name, 'args': args},
                  },
                ],
              },
              'finishReason': 'STOP',
            },
          ],
        })}\r\n\r\n',
        200,
        headers: {'content-type': 'text/event-stream'},
      );

  String text(Object? content) =>
      ((content! as Map)['parts'] as List).single['text'] as String;

  test('streams the answer; history first without its [n]s, then the '
      'context, app events, sources and question', () async {
    final chat = writer([
      FakeGemini.sse(['The return ', 'is SQ322 [1].']),
    ]);

    final events = await chat
        .answer(
          history: const [
            ChatTurn(
              question: 'When does SQ321 land?',
              answer: 'At 18:05 [2].',
            ),
          ],
          question: 'And the return flight?',
          sources: [(title: 'Trip plan', text: 'Return: flight SQ322.')],
          appEvents: ['The user undid the booking "Dinner" (id 3).'],
        )
        .toList();

    expect(
      [for (final e in events) (e as TextChunk).text],
      ['The return ', 'is SQ322 [1].'],
    );
    final contents = gemini.lastBody['contents']! as List;
    expect(contents, hasLength(3));
    expect(text(contents[0]), 'When does SQ321 land?');
    expect((contents[1] as Map)['role'], 'model');
    expect(text(contents[1]), 'At 18:05.');
    expect(
      text(contents[2]),
      "Now on the user's phone: 2026-10-30 18:45 (Asia/Yangon).\n"
      '<app_events>\n'
      'The user undid the booking "Dinner" (id 3).\n'
      '</app_events>\n'
      '<sources>\n'
      '[1] (Trip plan) Return: flight SQ322.\n'
      '</sources>\n'
      '<question>And the return flight?</question>',
    );
    // The functions are declared.
    final tools = jsonEncode(gemini.lastBody['tools']);
    expect(tools, contains('add_booking'));
    expect(tools, contains('get_local_time'));
  });

  test('a function call runs, its result goes back, then the answer', () async {
    final chat = writer([
      callStream('add_booking', {
        'title': 'Flight TG404 to Bangkok',
        'kind': 'flight',
        'date': '2026-12-16',
        'time': '09:05',
        'time_zone': 'Asia/Singapore',
      }),
      FakeGemini.sse(['Added your flight to Bangkok.']),
    ]);

    final events = await chat
        .answer(
          history: const [],
          question: 'Add TG404 on 16 Dec at 9:05 from Singapore',
          sources: const [],
        )
        .toList();

    final booking = itinerary.bookings.single;
    expect(events.first, isA<BookingAdded>());
    expect((events.first as BookingAdded).booking, booking);
    expect((events.last as TextChunk).text, 'Added your flight to Bangkok.');
    // The 2nd request: the question, Gemini's call, and our result.
    final contents = gemini.lastBody['contents']! as List;
    expect(contents, hasLength(3));
    expect(jsonEncode(contents[1]), contains('functionCall'));
    expect(jsonEncode(contents[2]), contains('"saved":true'));
  });

  test('no connection is a NetworkFailure in the stream', () async {
    final chat = writer([]);

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
