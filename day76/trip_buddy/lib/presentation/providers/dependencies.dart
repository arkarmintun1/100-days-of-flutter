import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/ai/cloud_embedder.dart';
import '../../data/local/drift_trip_memory.dart';
import '../../data/local/trip_database.dart';
import '../../domain/embedder.dart';
import '../../domain/hybrid_search.dart';
import '../../domain/memorize_document.dart';
import '../../domain/search_memory.dart';
import '../../domain/trip_memory.dart';

part 'dependencies.g.dart';

// The composition root: the only place that knows which implementation
// goes behind each interface. Tests override these providers.

/// Whether Firebase started (main.dart overrides it).
@Riverpod(keepAlive: true)
bool firebaseReady(Ref ref) => false;

/// The current time. Tests override it to get a fixed "now".
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

@Riverpod(keepAlive: true)
Embedder embedder(Ref ref) =>
    CloudEmbedder.firebase(FirebaseFunctions.instance);

// Day 76: documents and their vectors, in SQLite.

@Riverpod(keepAlive: true)
TripDatabase tripDatabase(Ref ref) {
  final db = TripDatabase.defaults();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
TripMemory tripMemory(Ref ref) =>
    DriftTripMemory(ref.watch(tripDatabaseProvider));

@riverpod
MemorizeDocument memorizeDocument(Ref ref) => MemorizeDocument(
  ref.watch(tripMemoryProvider),
  ref.watch(embedderProvider),
  now: ref.watch(clockProvider),
);

@riverpod
SearchMemory searchMemory(Ref ref) =>
    SearchMemory(ref.watch(tripMemoryProvider), ref.watch(embedderProvider));

@riverpod
Stream<List<TripDocument>> documents(Ref ref) =>
    ref.watch(tripMemoryProvider).watchDocuments();

/// The chunks that best answer [question], best first.
@riverpod
Future<List<SearchHit>> memorySearch(Ref ref, String question) async {
  // Runs again when a document is added or deleted.
  await ref.watch(documentsProvider.future);
  return ref.read(searchMemoryProvider)(question);
}
