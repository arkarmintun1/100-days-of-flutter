import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/sample_guide.dart';
import 'package:trip_buddy/domain/embedder.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/memorize_document.dart';
import 'package:trip_buddy/domain/search_memory.dart';

import '../helpers/fake_embedder.dart';
import '../helpers/fake_trip_memory.dart';

void main() {
  late FakeTripMemory memory;
  late FakeEmbedder embedder;
  late MemorizeDocument memorize;
  late SearchMemory search;

  setUp(() {
    memory = FakeTripMemory();
    embedder = FakeEmbedder();
    memorize = MemorizeDocument(
      memory,
      embedder,
      now: () => DateTime(2026, 10, 29),
    );
    search = SearchMemory(memory, embedder);
  });

  test('memorize: chunks, embeds them as documents, saves them', () async {
    await memorize(title: sampleGuideTitle, text: sampleGuide);

    expect(memory.chunks.length, greaterThan(1));
    expect(memory.chunks.every((c) => c.text.length <= 600), isTrue);
    final (texts, kind) = embedder.calls.single;
    expect(kind, EmbedKind.document);
    expect(texts, memory.chunks.map((c) => c.text));
  });

  test('a document without text is not saved', () async {
    await expectLater(
      memorize(title: 'Empty', text: '  '),
      throwsA(isA<ValidationFailure>()),
    );
    expect(memory.chunks, isEmpty);
    expect(embedder.calls, isEmpty);
  });

  test('search embeds the question as a query', () async {
    await memorize(title: sampleGuideTitle, text: sampleGuide);

    final hits = await search('When does SQ321 land?');

    expect(hits.first.chunk.text, contains('SQ321'));
    // A record compares its fields with ==, and two lists are only ==
    // if they are the same object: check the fields one by one.
    final (texts, kind) = embedder.calls.last;
    expect(texts, ['When does SQ321 land?']);
    expect(kind, EmbedKind.query);
  });

  test('with nothing memorized, the question is not even embedded', () async {
    expect(await search('Anything?'), isEmpty);
    expect(embedder.calls, isEmpty);
  });
}
