import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_buddy/domain/answer.dart';
import 'package:trip_buddy/domain/booking.dart';
import 'package:trip_buddy/domain/document_file.dart';
import 'package:trip_buddy/domain/document_reader.dart';
import 'package:trip_buddy/domain/embedder.dart';
import 'package:trip_buddy/domain/forecast.dart';
import 'package:trip_buddy/domain/trip_chat.dart';
import 'package:trip_buddy/domain/nearby.dart';
import 'package:trip_buddy/domain/trip_memory.dart';
import 'package:trip_buddy/domain/trip_place.dart';
import 'package:trip_buddy/main.dart';
import 'package:trip_buddy/presentation/providers/dependencies.dart';

import 'fake_answer_writer.dart';
import 'fake_chat_writer.dart';
import 'fake_document_reader.dart';
import 'fake_embedder.dart';
import 'fake_forecast.dart';
import 'fake_itinerary.dart';
import 'fake_location.dart';
import 'fake_places.dart';
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
  AnswerWriter? writer,
  ChatWriter? chatWriter,
  Itinerary? itinerary,
  PlaceFinder? placeFinder,
  Geocoder? geocoder,
  PlaceStore? placeStore,
  LocationService? location,
  ForecastService? forecast,
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
    // Day 78: no Gemini for answers either.
    answerWriterProvider.overrideWithValue(writer ?? FakeAnswerWriter()),
    // Day 79: and none for the chat.
    chatWriterProvider.overrideWithValue(chatWriter ?? FakeChatWriter()),
    // Day 80: the itinerary in a list.
    itineraryProvider.overrideWithValue(itinerary ?? FakeItinerary()),
    // Day 81: no Gemini, no geocoder, no Google Maps.
    placeFinderProvider.overrideWithValue(placeFinder ?? FakePlaceFinder()),
    geocoderProvider.overrideWithValue(geocoder ?? FakeGeocoder()),
    placesMapProvider.overrideWithValue(fakePlacesMap),
    // Day 82: saved places in a list, and a phone in Chinatown.
    placeStoreProvider.overrideWithValue(placeStore ?? FakePlaceStore()),
    locationServiceProvider.overrideWithValue(
      location ?? FakeLocationService(),
    ),
    // Day 84: no Open-Meteo.
    forecastServiceProvider.overrideWithValue(
      forecast ?? FakeForecastService(),
    ),
  ],
  child: const TripBuddyApp(),
);
