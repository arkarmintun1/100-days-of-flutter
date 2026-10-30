import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/sample_guide.dart';
import 'package:trip_buddy/domain/booking.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/memorize_document.dart';
import 'package:trip_buddy/domain/search_memory.dart';
import 'package:trip_buddy/domain/trip_chat.dart';

import '../helpers/fake_chat_writer.dart';
import '../helpers/fake_embedder.dart';
import '../helpers/fake_trip_memory.dart';

void main() {
  late FakeTripMemory memory;
  late FakeEmbedder embedder;

  setUp(() async {
    memory = FakeTripMemory();
    embedder = FakeEmbedder();
    await MemorizeDocument(memory, embedder, now: () => DateTime(2026, 10, 30))(
      title: sampleGuideTitle,
      text: sampleGuide,
    );
  });

  TripChat chat(FakeChatWriter writer) =>
      TripChat(SearchMemory(memory, embedder), writer);

  test('the answer arrives piece by piece, with its sources', () async {
    final trip = chat(
      FakeChatWriter(chunks: ['It lands ', 'at 18:05 ', '[1].']),
    );

    final answers = await trip.ask('When does SQ321 land?').toList();

    expect(answers.map((a) => a.text), [
      'It lands ',
      'It lands at 18:05 ',
      'It lands at 18:05 [1].',
    ]);
    expect(answers.last.cited, [1]);
    expect(answers.last.sources.first.chunk.text, contains('SQ321'));
  });

  test('the next question gets the history, and a search with the '
      'question before it', () async {
    final writer = FakeChatWriter(chunks: ['18:05 [1].']);
    final trip = chat(writer);

    await trip.ask('When does SQ321 land?').drain<void>();
    await trip.ask('And the return flight?').drain<void>();

    final second = writer.calls.last;
    expect(second.question, 'And the return flight?');
    expect(second.history.single.question, 'When does SQ321 land?');
    expect(second.history.single.answer, '18:05 [1].');
    final (searched, _) = embedder.calls.last;
    expect(searched, ['When does SQ321 land? And the return flight?']);
  });

  test('only the last ${TripChat.maxHistory} questions go along', () async {
    final writer = FakeChatWriter(chunks: ['OK [1].']);
    final trip = chat(writer);

    for (var i = 1; i <= TripChat.maxHistory + 2; i++) {
      await trip.ask('Question $i about the hotel?').drain<void>();
    }

    final history = writer.calls.last.history;
    expect(history, hasLength(TripChat.maxHistory));
    expect(history.first.question, 'Question 2 about the hotel?');
  });

  test('a failed answer is not kept in the history', () async {
    final failing = FakeChatWriter(
      chunks: ['It lands'],
      error: const NetworkFailure("Couldn't reach the AI."),
    );
    final trip = TripChat(SearchMemory(memory, embedder), failing);

    await expectLater(
      trip.ask('When does SQ321 land?'),
      emitsThrough(emitsError(isA<NetworkFailure>())),
    );
    failing.error = null; // back online
    await trip.ask('Hello?').drain<void>();

    expect(failing.calls.last.history, isEmpty);
  });

  test('Day 80: with no documents the model is still asked, with no '
      'sources (it can tell the time)', () async {
    final writer = FakeChatWriter(chunks: ["It's 20:15 in Singapore."]);
    final trip = TripChat(SearchMemory(FakeTripMemory(), embedder), writer);

    final answers = await trip.ask('What time is it in Singapore?').toList();

    expect(writer.calls.single.sources, isEmpty);
    expect(answers.last.text, "It's 20:15 in Singapore.");
  });

  test('bookings the model adds come with the answer', () async {
    final booking = Booking(
      id: 7,
      title: 'Flight SQ321',
      kind: BookingKind.flight,
      startsAt: DateTime(2026, 12, 12, 21, 40),
      timeZone: 'Europe/London',
    );
    final trip = chat(FakeChatWriter(chunks: ['Added [1].'], added: [booking]));

    final answers = await trip.ask('Add my flight SQ321').toList();

    expect(answers.last.added, [booking]);
    expect(answers.last.text, 'Added [1].');
  });

  test('an Undo is told to the model once, with the next question', () async {
    final booking = Booking(
      id: 7,
      title: 'Flight SQ321',
      kind: BookingKind.flight,
      startsAt: DateTime(2026, 12, 12, 21, 40),
      timeZone: 'Europe/London',
    );
    final writer = FakeChatWriter(chunks: ['OK.']);
    final trip = chat(writer);

    trip.noteUndone(booking);
    await trip.ask('What is on my itinerary?').drain<void>();
    await trip.ask('And now?').drain<void>();

    expect(writer.calls.first.appEvents, [
      'The user undid the booking "Flight SQ321" (id 7): it was deleted.',
    ]);
    expect(writer.calls.last.appEvents, isEmpty);
  });

  test('clear starts over', () async {
    final writer = FakeChatWriter(chunks: ['OK [1].']);
    final trip = chat(writer);
    await trip.ask('When does SQ321 land?').drain<void>();

    trip.clear();
    await trip.ask('Where do I sleep?').drain<void>();

    expect(writer.calls.last.history, isEmpty);
  });

  test('an answer that ends after clear() is not kept', () async {
    final hold = Completer<void>();
    final writer = FakeChatWriter(chunks: ['OK [1].'], hold: hold.future);
    final trip = chat(writer);
    // "New chat" while the answer is still on its way.
    final first = trip.ask('When does SQ321 land?').drain<void>();
    await pumpEventQueue();
    trip.clear();
    hold.complete();
    await first;

    await trip.ask('Where do I sleep?').drain<void>();
    expect(writer.calls.last.history, isEmpty);
  });

  test(
    'bookings saved before a failure are told to the model next time',
    () async {
      final booking = Booking(
        id: 7,
        title: 'Flight SQ321',
        kind: BookingKind.flight,
        startsAt: DateTime(2026, 12, 12, 21, 40),
        timeZone: 'Europe/London',
      );
      final writer = FakeChatWriter(
        chunks: ['Adding it'],
        added: [booking],
        error: const NetworkFailure("Couldn't reach the AI."),
      );
      final trip = chat(writer);

      await expectLater(
        trip.ask('Add SQ321 on 12 Dec at 21:40 from London').toList(),
        throwsA(isA<NetworkFailure>()),
      );
      writer.error = null;
      await trip.ask('Did it work?').drain<void>();

      expect(
        writer.calls.last.appEvents.single,
        contains('"Flight SQ321" (id 7)'),
      );
    },
  );
}
