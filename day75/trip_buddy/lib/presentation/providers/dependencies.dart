import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/ai/cloud_embedder.dart';
import '../../data/sample_notes.dart';
import '../../domain/embedder.dart';
import '../../domain/similarity.dart';

part 'dependencies.g.dart';

// The composition root: the only place that knows which implementation
// goes behind each interface. Tests override these providers.

/// Whether Firebase started (main.dart overrides it).
@Riverpod(keepAlive: true)
bool firebaseReady(Ref ref) => false;

@Riverpod(keepAlive: true)
Embedder embedder(Ref ref) =>
    CloudEmbedder.firebase(FirebaseFunctions.instance);

/// The sample notes with their vectors. Embedded once: every search
/// reuses them and only embeds the question.
@Riverpod(keepAlive: true)
Future<List<({String item, Float32List vector})>> notesIndex(Ref ref) async {
  final vectors = await ref
      .watch(embedderProvider)
      .embed(sampleNotes, EmbedKind.document);
  return [
    for (final (i, note) in sampleNotes.indexed)
      (item: note, vector: vectors[i]),
  ];
}

/// The notes closest in meaning to [query], best first.
@riverpod
Future<List<Scored<String>>> noteSearch(Ref ref, String query) async {
  final embedder = ref.watch(embedderProvider);
  final index = await ref.watch(notesIndexProvider.future);
  final [vector] = await embedder.embed([query], EmbedKind.query);
  return rankBySimilarity(vector, index, top: 3);
}
