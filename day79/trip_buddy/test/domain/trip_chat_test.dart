import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/sample_guide.dart';
import 'package:trip_buddy/domain/ask_trip.dart';
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

  test('no documents: "not found", and the model is not asked', () async {
    final writer = FakeChatWriter();
    final trip = TripChat(SearchMemory(FakeTripMemory(), embedder), writer);

    final answers = await trip.ask('When does SQ321 land?').toList();

    expect(answers.single.text, AskTrip.notFound);
    expect(writer.calls, isEmpty);
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
}
