import 'dart:typed_data';

import 'package:trip_buddy/domain/embedder.dart';

/// A stand-in for the real embedding model, for tests: no network, same
/// vectors every run.
///
/// Each dimension is a group of related words, so "sleep" and "hotel" get
/// similar vectors. A real model learns millions of such relations.
class FakeEmbedder implements Embedder {
  FakeEmbedder({this.error});

  /// If set, every call throws it.
  final Object? error;

  final calls = <(List<String>, EmbedKind)>[];

  static const _groups = [
    ['hotel', 'sleep', 'stay', 'check-in', 'room', 'night'],
    ['flight', 'land', 'lands', 'airport', 'terminal', 'plane', 'arrive'],
    ['coffee', 'dinner', 'crab', 'eat', 'food', 'breakfast'],
    ['mrt', 'buses', 'card', 'train', 'metro', 'transport'],
    ['umbrella', 'showers', 'rain', 'weather'],
    ['show', 'gardens', 'light', 'see', 'evening'],
    ['insurance', 'policy', 'hotline'],
  ];

  @override
  Future<List<Float32List>> embed(List<String> texts, EmbedKind kind) async {
    calls.add((texts, kind));
    if (error case final error?) throw error;
    return [for (final text in texts) _vector(text)];
  }

  static Float32List _vector(String text) {
    final words = text.toLowerCase().split(RegExp(r'[^a-z\-]+'));
    return Float32List.fromList([
      for (final group in _groups)
        words.where(group.contains).length.toDouble(),
    ]);
  }
}
