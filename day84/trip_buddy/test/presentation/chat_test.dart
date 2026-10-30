import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart' show Surface, basicCatalogId;
import 'package:trip_buddy/domain/booking.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/time_zones.dart';
import 'package:trip_buddy/presentation/chat/trip_catalog.dart';

import '../helpers/fake_answer_writer.dart';
import '../helpers/fake_chat_writer.dart';
import '../helpers/fake_forecast.dart';
import '../helpers/fake_itinerary.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> openChatWithGuide(WidgetTester tester) async {
    await tester.tap(find.text('Add the sample guide'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
  }

  Future<void> send(WidgetTester tester, String question) async {
    await tester.enterText(find.byType(TextField).last, question);
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
  }

  testWidgets('a question gets an answer with its source', (tester) async {
    await tester.pumpWidget(
      testApp(
        chatWriter: FakeChatWriter(
          reply: (_, sources) =>
              'It lands at 18:05 '
              '[${FakeAnswerWriter.numberOf(sources, 'SQ321')}].',
        ),
      ),
    );
    await tester.pumpAndSettle();
    await openChatWithGuide(tester);

    await send(tester, 'When does SQ321 land?');

    expect(find.text('When does SQ321 land?'), findsOneWidget);
    expect(find.text('It lands at 18:05 [1].'), findsOneWidget);
    await tester.tap(find.text('[1] Singapore trip plan'));
    await tester.pumpAndSettle();
    // The bottom sheet shows the source itself.
    expect(find.textContaining('Seat 42K'), findsOneWidget);
  });

  testWidgets('a follow-up goes with the history', (tester) async {
    final writer = FakeChatWriter(chunks: ['OK [1].']);
    await tester.pumpWidget(testApp(chatWriter: writer));
    await tester.pumpAndSettle();
    await openChatWithGuide(tester);

    await send(tester, 'When does SQ321 land?');
    await send(tester, 'And the return flight?');

    expect(writer.calls.last.history.single.question, 'When does SQ321 land?');
    expect(find.text('OK [1].'), findsNWidgets(2));
  });

  testWidgets('a failure is shown, and the next question works', (
    tester,
  ) async {
    final writer = FakeChatWriter(
      chunks: ['OK [1].'],
      error: const NetworkFailure("Couldn't reach the AI."),
    );
    await tester.pumpWidget(testApp(chatWriter: writer));
    await tester.pumpAndSettle();
    await openChatWithGuide(tester);

    await send(tester, 'When does SQ321 land?');
    expect(find.text("Couldn't reach the AI."), findsOneWidget);

    writer.error = null;
    await send(tester, 'Where do I sleep?');
    expect(writer.calls.last.history, isEmpty);
  });

  testWidgets('new chat starts over', (tester) async {
    final writer = FakeChatWriter(chunks: ['OK [1].']);
    await tester.pumpWidget(testApp(chatWriter: writer));
    await tester.pumpAndSettle();
    await openChatWithGuide(tester);
    await send(tester, 'When does SQ321 land?');

    await tester.tap(find.byTooltip('New chat'));
    await tester.pumpAndSettle();
    expect(find.text('OK [1].'), findsNothing);

    await send(tester, 'Where do I sleep?');
    expect(writer.calls.last.history, isEmpty);
  });

  testWidgets('Day 80: a booking saved before a failure keeps its Undo', (
    tester,
  ) async {
    final flight = Booking(
      id: 1,
      title: 'Flight SQ322 to London',
      kind: BookingKind.flight,
      startsAt: DateTime(2026, 12, 19, 23, 30),
      timeZone: 'Asia/Singapore',
    );
    final writer = FakeChatWriter(
      chunks: ['Adding it'],
      added: [flight],
      error: const NetworkFailure("Couldn't reach the AI."),
    );
    await tester.pumpWidget(
      testApp(chatWriter: writer, itinerary: FakeItinerary([flight])),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    await send(tester, 'Add SQ322 on 19 Dec at 23:30 from Singapore');

    expect(find.text("Couldn't reach the AI."), findsOneWidget);
    expect(find.text('Added: Flight SQ322 to London'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
  });

  testWidgets('Day 80: an added booking can be undone, and the model is '
      'told', (tester) async {
    final flight = Booking(
      id: 1,
      title: 'Flight SQ322 to London',
      kind: BookingKind.flight,
      startsAt: DateTime(2026, 12, 19, 23, 30),
      timeZone: 'Asia/Singapore',
    );
    final itinerary = FakeItinerary([flight]);
    final writer = FakeChatWriter(chunks: ['Added.'], added: [flight]);
    await tester.pumpWidget(testApp(chatWriter: writer, itinerary: itinerary));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    await send(tester, 'Add SQ322 on 19 Dec at 23:30 from Singapore');
    expect(find.text('Added: Flight SQ322 to London'), findsOneWidget);
    expect(find.text('2026-12-19 23:30 · Asia/Singapore'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Removed: Flight SQ322 to London'), findsOneWidget);
    expect(itinerary.bookings, isEmpty);

    await send(tester, 'What is on my itinerary?');
    expect(writer.calls.last.appEvents.single, contains('undid'));
  });

  // Day 83: the text and the fenced A2UI messages in separate pieces, or
  // all in one (as Gemini's last chunk may have them); and unfenced JSON.
  List<String> countdownAnswer({bool fenced = true}) => [
    'SQ321 leaves London Heathrow on 12 Dec at 21:40 London time [1].\n',
    ...countdownUi(
      title: 'Flight SQ321 to Singapore',
      startsAt: '2026-12-12T21:40',
      timeZone: 'Europe/London',
      fenced: fenced,
    ),
  ];
  for (final (pieces, chunks) in [
    ('in pieces', countdownAnswer()),
    ('in one piece', [countdownAnswer().join()]),
    ('unfenced, in one piece', [countdownAnswer(fenced: false).join()]),
  ]) {
    testWidgets('Day 83: a countdown answer ($pieces) shows a card', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(chatWriter: FakeChatWriter(chunks: chunks)),
      );
      await tester.pumpAndSettle();
      await openChatWithGuide(tester);

      await send(tester, 'How long until my flight?');

      expect(
        find.text(
          'SQ321 leaves London Heathrow on 12 Dec at 21:40 London time [1].',
        ),
        findsOneWidget,
      );
      // The card, counting from the test clock to 21:40 in London.
      expect(find.text('Flight SQ321 to Singapore'), findsOneWidget);
      final left = timeUntil(
        DateTime(2026, 12, 12, 21, 40),
        'Europe/London',
        now: testNow,
      );
      expect(find.text(countdownText(left)), findsOneWidget);
      expect(find.text('12/12/2026 21:40 · Europe/London'), findsOneWidget);
      // No JSON on the screen, and the source chip is still there.
      expect(find.textContaining('createSurface'), findsNothing);
      expect(find.textContaining('```'), findsNothing);
      expect(find.text("Couldn't show part of the answer."), findsNothing);
      expect(find.text('[1] Singapore trip plan'), findsOneWidget);
    });
  }
  testWidgets('Day 83: the same surface ID twice in one answer', (
    tester,
  ) async {
    final card = countdownUi(
      title: 'Flight SQ321 to Singapore',
      startsAt: '2026-12-12T21:40',
      timeZone: 'Europe/London',
    );
    await tester.pumpWidget(
      testApp(chatWriter: FakeChatWriter(chunks: ['OK.\n', ...card, ...card])),
    );
    await tester.pumpAndSettle();
    await openChatWithGuide(tester);

    await send(tester, 'How long until my flight?');

    // One card, and the rejected second surface is reported.
    expect(find.byType(Surface), findsOneWidget);
    expect(find.text("Couldn't show part of the answer."), findsOneWidget);
  });

  testWidgets('Day 83: a component not in the catalog shows the error once', (
    tester,
  ) async {
    String fenced(Map<String, Object?> message) =>
        '```json\n${jsonEncode(message)}\n```\n';
    final writer = FakeChatWriter(
      chunks: [
        'OK.\n',
        fenced({
          'version': 'v0.9',
          'createSurface': {'surfaceId': 'ui', 'catalogId': basicCatalogId},
        }),
        // Button was taken out of Trip Buddy's catalog.
        fenced({
          'version': 'v0.9',
          'updateComponents': {
            'surfaceId': 'ui',
            'components': [
              {'id': 'root', 'component': 'Button', 'child': 'label'},
            ],
          },
        }),
      ],
    );
    await tester.pumpWidget(testApp(chatWriter: writer));
    await tester.pumpAndSettle();
    await openChatWithGuide(tester);

    // Settles: the error doesn't rebuild the chat over and over.
    await send(tester, 'How long until my flight?');

    expect(find.text('OK.'), findsOneWidget);
    expect(find.text("Couldn't show part of the answer."), findsOneWidget);
  });

  testWidgets('Day 83: two answers may use the same surface ID', (
    tester,
  ) async {
    final writer = FakeChatWriter(
      reply: (question, _) => [
        'OK.\n',
        ...countdownUi(
          title: 'Card for: $question',
          startsAt: '2026-12-12T21:40',
          timeZone: 'Europe/London',
        ),
      ].join(),
    );
    await tester.pumpWidget(testApp(chatWriter: writer));
    await tester.pumpAndSettle();
    await openChatWithGuide(tester);

    await send(tester, 'Until the flight?');
    await send(tester, 'And until check-in?');

    // Both cards, each with its own answer's data.
    expect(find.text('Card for: Until the flight?'), findsOneWidget);
    expect(find.text('Card for: And until check-in?'), findsOneWidget);
  });
  testWidgets('Day 84: a ForecastCard shows the forecast the app got', (
    tester,
  ) async {
    final forecast = FakeForecastService();
    final writer = FakeChatWriter(
      chunks: [
        'Expect drizzle and showers this weekend.\n',
        ...forecastUi(place: 'Singapore', from: '2026-10-31', to: '2026-11-01'),
      ],
    );
    await tester.pumpWidget(testApp(chatWriter: writer, forecast: forecast));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    await send(tester, 'Weather in Singapore this weekend?');

    expect(find.text('Weather in Singapore'), findsOneWidget);
    expect(find.text('Sat 31 Oct'), findsOneWidget);
    expect(find.text('Moderate drizzle'), findsOneWidget);
    expect(find.text('32° / 25°'), findsOneWidget);
    expect(find.text('Sun 1 Nov'), findsOneWidget);
    expect(find.text('Moderate rain showers'), findsOneWidget);
    expect(find.text('96%'), findsNWidgets(2));
    expect(find.text('Weather data by Open-Meteo.com'), findsOneWidget);
    expect(forecast.calls, hasLength(1));
  });

  testWidgets("Day 84: a forecast that can't load says why", (tester) async {
    final forecast = FakeForecastService()
      ..error = const NetworkFailure("Couldn't reach the weather service.");
    final writer = FakeChatWriter(
      chunks: forecastUi(
        place: 'Singapore',
        from: '2026-10-31',
        to: '2026-11-01',
      ),
    );
    await tester.pumpWidget(testApp(chatWriter: writer, forecast: forecast));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    await send(tester, 'Weather in Singapore this weekend?');

    expect(find.text("Couldn't reach the weather service."), findsOneWidget);

    // The network is back: "Try again" asks once more.
    forecast.error = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Sat 31 Oct'), findsOneWidget);
  });
}
