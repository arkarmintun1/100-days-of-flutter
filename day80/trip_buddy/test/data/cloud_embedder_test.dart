import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/ai/cloud_embedder.dart';
import 'package:trip_buddy/domain/embedder.dart';
import 'package:trip_buddy/domain/failures.dart';

void main() {
  test('sends the texts and the kind, reads one vector per text', () async {
    final sent = <Map<String, Object?>>[];
    final embedder = CloudEmbedder((data) async {
      sent.add(data);
      return [
        [0.6, 0.8],
        [1, 0],
      ];
    });

    final vectors = await embedder.embed(['Hotel', 'Flight'], EmbedKind.query);

    expect(sent.single, {
      'texts': ['Hotel', 'Flight'],
      'kind': 'query',
    });
    expect(vectors.map((v) => v.toList()), [
      [closeTo(0.6, 1e-6), closeTo(0.8, 1e-6)],
      [1, 0],
    ]);
  });

  test('more than 50 texts are sent in several calls', () async {
    final sizes = <int>[];
    final embedder = CloudEmbedder((data) async {
      final texts = data['texts']! as List;
      sizes.add(texts.length);
      return [
        for (final _ in texts) [1.0],
      ];
    });

    final vectors = await embedder.embed([
      for (var i = 0; i < 120; i++) 'note $i',
    ], EmbedKind.document);

    expect(sizes, [50, 50, 20]);
    expect(vectors, hasLength(120));
  });

  test('errors from the function become Failures', () async {
    Future<Failure> failureFor(String code) async {
      final embedder = CloudEmbedder(
        (_) async => throw FirebaseFunctionsException(message: 'x', code: code),
      );
      try {
        await embedder.embed(['a'], EmbedKind.query);
      } on Failure catch (f) {
        return f;
      }
      fail('no Failure for $code');
    }

    expect(await failureFor('unavailable'), isA<NetworkFailure>());
    expect(
      (await failureFor('unauthenticated')).message,
      "Couldn't verify this app.",
    );
    expect(await failureFor('internal'), isA<AiFailure>());
  });

  test('an answer of the wrong shape is an AiFailure', () async {
    for (final answer in [
      null,
      [
        [1, 'two'],
      ],
      [<Object?>[]],
      [
        [1],
        [2],
      ], // two vectors for one text
    ]) {
      final embedder = CloudEmbedder((_) async => answer);
      await expectLater(
        embedder.embed(['a'], EmbedKind.query),
        throwsA(isA<AiFailure>()),
        reason: '$answer',
      );
    }
  });
}
