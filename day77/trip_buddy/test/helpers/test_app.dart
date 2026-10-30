import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_buddy/domain/document_file.dart';
import 'package:trip_buddy/domain/document_reader.dart';
import 'package:trip_buddy/domain/embedder.dart';
import 'package:trip_buddy/domain/trip_memory.dart';
import 'package:trip_buddy/main.dart';
import 'package:trip_buddy/presentation/providers/dependencies.dart';

import 'fake_document_reader.dart';
import 'fake_embedder.dart';
import 'fake_trip_memory.dart';

/// "Now" in every widget test.
final testNow = DateTime(2026, 10, 29, 10);

/// The real app, with fakes instead of Firebase and the database.
Widget testApp({
  Embedder? embedder,
  TripMemory? memory,
  DocumentReader? reader,
  DocumentFile? pickedFile,
  Future<DocumentFile?> Function()? picker,
}) => ProviderScope(
  retry: (_, _) => null,
  overrides: [
    firebaseReadyProvider.overrideWithValue(true),
    embedderProvider.overrideWithValue(embedder ?? FakeEmbedder()),
    tripMemoryProvider.overrideWithValue(memory ?? FakeTripMemory()),
    clockProvider.overrideWithValue(() => testNow),
    // Day 77: no Gemini, no file picker (it's a native dialog).
    documentReaderProvider.overrideWithValue(reader ?? FakeDocumentReader()),
    documentPickerProvider.overrideWithValue(picker ?? () async => pickedFile),
  ],
  child: const TripBuddyApp(),
);
