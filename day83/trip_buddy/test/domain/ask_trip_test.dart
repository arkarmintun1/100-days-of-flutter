import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/sample_guide.dart';
import 'package:trip_buddy/domain/answer.dart';
import 'package:trip_buddy/domain/ask_trip.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/memorize_document.dart';
import 'package:trip_buddy/domain/search_memory.dart';

import '../helpers/fake_answer_writer.dart';
import '../helpers/fake_embedder.dart';
import '../helpers/fake_trip_memory.dart';

void main() {
  late FakeTripMemory memory;
  late FakeEmbedder embedder;
  late FakeAnswerWriter writer;
  late AskTrip ask;

  setUp(() {
    memory = FakeTripMemory();
    embedder = FakeEmbedder();
    writer = FakeAnswerWriter(
      answer: (sources) =>
          'It lands at 18:05 [${FakeAnswerWriter.numberOf(sources, 'SQ321')}].',
    );
    ask = AskTrip(SearchMemory(memory, embedder), writer);
  });

  Future<void> memorizeGuide() => MemorizeDocument(
    memory,
    embedder,
    now: () => DateTime(2026, 10, 30),
  )(title: sampleGuideTitle, text: sampleGuide);

  test('the best chunks go to the writer, numbered, with titles', () async {
    await memorizeGuide();

    final answer = await ask('When does SQ321 land?');

    final (question, sources) = writer.calls.single;
    expect(question, 'When does SQ321 land?');
    expect(sources, hasLength(AskTrip.top));
    expect(sources.first.title, sampleGuideTitle);
    // The flight is the best hit (its number matches as a keyword).
    expect(sources.first.text, contains('SQ321'));
    expect(answer.text, 'It lands at 18:05 [1].');
    expect(answer.cited, [1]);
    expect(answer.sources[0].chunk.text, contains('SQ321'));
  });

  test('with no documents, the model is not asked', () async {
    final answer = await ask('When does SQ321 land?');

    expect(answer.text, AskTrip.notFound);
    expect(answer.cited, isEmpty);
    expect(writer.calls, isEmpty);
  });

  test('an empty question is not asked', () async {
    await expectLater(ask('  '), throwsA(isA<ValidationFailure>()));
  });

  group('citations', () {
    test('finds [1], [2][3] and [1, 2], in order, once each', () {
      expect(citations('A [2]. B [1][3]. C [1, 2].', 3), [2, 1, 3]);
    });

    test('drops numbers that point at no source', () {
      expect(citations('A [0]. B [4]. C [99999999999999999999].', 3), isEmpty);
    });

    test('no brackets, no citations', () {
      expect(citations(AskTrip.notFound, 5), isEmpty);
    });
  });

  test('memorizing reports each batch of chunks', () async {
    // 45 short sections: 45 chunks, embedded 20 at a time.
    final text = [for (var i = 1; i <= 45; i++) 'Note $i.'].join('\n\n');
    final steps = <MemorizeStep>[];

    await MemorizeDocument(memory, embedder, now: () => DateTime(2026, 10, 30))(
      title: 'Notes',
      text: text,
      onStep: steps.add,
    );

    expect(embedder.calls.map((c) => c.$1.length), [20, 20, 5]);
    expect(
      [
        for (final step in steps)
          switch (step) {
            Reading() => 'reading',
            Embedding(:final done, :final total) => '$done/$total',
            Saving() => 'saving',
          },
      ],
      ['0/45', '20/45', '40/45', '45/45', 'saving'],
    );
  });
}
