import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/booking.dart';
import 'package:trip_buddy/domain/failures.dart';

import '../helpers/fake_answer_writer.dart';
import '../helpers/fake_chat_writer.dart';
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
}
