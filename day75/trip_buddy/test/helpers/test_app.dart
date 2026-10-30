import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_buddy/domain/embedder.dart';
import 'package:trip_buddy/main.dart';
import 'package:trip_buddy/presentation/providers/dependencies.dart';

import 'fake_embedder.dart';

/// The real app, with fakes instead of Firebase.
Widget testApp({Embedder? embedder}) => ProviderScope(
  retry: (_, _) => null,
  overrides: [
    firebaseReadyProvider.overrideWithValue(true),
    embedderProvider.overrideWithValue(embedder ?? FakeEmbedder()),
  ],
  child: const TripBuddyApp(),
);
