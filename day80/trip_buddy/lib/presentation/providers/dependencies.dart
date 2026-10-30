import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/ai/cloud_embedder.dart';
import '../../data/ai/gemini_answer_writer.dart';
import '../../data/ai/gemini_chat_writer.dart';
import '../../data/ai/gemini_document_reader.dart';
import '../../data/ai/trip_tools.dart';
import '../../data/files/pick_document.dart';
import '../../data/local/drift_itinerary.dart';
import '../../data/local/drift_trip_memory.dart';
import '../../data/local/trip_database.dart';
import '../../domain/add_document_file.dart';
import '../../domain/answer.dart';
import '../../domain/booking.dart';
import '../../domain/ask_trip.dart';
import '../../domain/document_file.dart';
import '../../domain/document_reader.dart';
import '../../domain/embedder.dart';
import '../../domain/memorize_document.dart';
import '../../domain/search_memory.dart';
import '../../domain/trip_chat.dart';
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

// Day 77: the document vault. Gemini reads the files (Firebase AI Logic,
// with the App Check set up in main.dart).

@Riverpod(keepAlive: true)
DocumentReader documentReader(Ref ref) =>
    GeminiDocumentReader(FirebaseAI.googleAI());

/// The file picker. Tests override it with a prepared file.
@Riverpod(keepAlive: true)
Future<DocumentFile?> Function() documentPicker(Ref ref) => pickDocument;

@riverpod
AddDocumentFile addDocumentFile(Ref ref) => AddDocumentFile(
  ref.watch(documentReaderProvider),
  ref.watch(memorizeDocumentProvider),
);

// Day 78: answers from the documents (RAG).

@Riverpod(keepAlive: true)
AnswerWriter answerWriter(Ref ref) => GeminiAnswerWriter(FirebaseAI.googleAI());

@riverpod
AskTrip askTrip(Ref ref) =>
    AskTrip(ref.watch(searchMemoryProvider), ref.watch(answerWriterProvider));

/// The answer to [question], from the documents as they are now.
@riverpod
Future<Answer> tripAnswer(Ref ref, String question) async {
  // Asked again when a document is added or deleted.
  await ref.watch(documentsProvider.future);
  return ref.read(askTripProvider)(question);
}

// Day 79: the chat.

@Riverpod(keepAlive: true)
ChatWriter chatWriter(Ref ref) =>
    GeminiChatWriter(FirebaseAI.googleAI(), ref.watch(tripToolsProvider));

/// One conversation, kept while the app runs.
@Riverpod(keepAlive: true)
TripChat tripChat(Ref ref) =>
    TripChat(ref.watch(searchMemoryProvider), ref.watch(chatWriterProvider));

// Day 80: the itinerary, and the functions the chat can run.

@Riverpod(keepAlive: true)
Itinerary itinerary(Ref ref) => DriftItinerary(ref.watch(tripDatabaseProvider));

@riverpod
Stream<List<Booking>> bookings(Ref ref) =>
    ref.watch(itineraryProvider).watchBookings();

/// The phone's IANA time zone, e.g. "Asia/Yangon". Tests override it.
@Riverpod(keepAlive: true)
Future<String> Function() homeTimeZone(Ref ref) =>
    () async => (await FlutterTimezone.getLocalTimezone()).identifier;

@Riverpod(keepAlive: true)
TripTools tripTools(Ref ref) => TripTools(
  itinerary: ref.watch(itineraryProvider),
  now: ref.watch(clockProvider),
  homeTimeZone: ref.watch(homeTimeZoneProvider),
);
