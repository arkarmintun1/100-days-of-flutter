// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Firebase started (main.dart overrides it).

@ProviderFor(firebaseReady)
final firebaseReadyProvider = FirebaseReadyProvider._();

/// Whether Firebase started (main.dart overrides it).

final class FirebaseReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether Firebase started (main.dart overrides it).
  FirebaseReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseReadyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return firebaseReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$firebaseReadyHash() => r'38c7dec60f80896bce1c13d65a141173c0ba440b';

/// The current time. Tests override it to get a fixed "now".

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// The current time. Tests override it to get a fixed "now".

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// The current time. Tests override it to get a fixed "now".
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

@ProviderFor(embedder)
final embedderProvider = EmbedderProvider._();

final class EmbedderProvider
    extends $FunctionalProvider<Embedder, Embedder, Embedder>
    with $Provider<Embedder> {
  EmbedderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'embedderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$embedderHash();

  @$internal
  @override
  $ProviderElement<Embedder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Embedder create(Ref ref) {
    return embedder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Embedder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Embedder>(value),
    );
  }
}

String _$embedderHash() => r'beac7758e56b5373a9f15bc43747a6b5c97accab';

@ProviderFor(tripDatabase)
final tripDatabaseProvider = TripDatabaseProvider._();

final class TripDatabaseProvider
    extends $FunctionalProvider<TripDatabase, TripDatabase, TripDatabase>
    with $Provider<TripDatabase> {
  TripDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripDatabaseHash();

  @$internal
  @override
  $ProviderElement<TripDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripDatabase create(Ref ref) {
    return tripDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripDatabase>(value),
    );
  }
}

String _$tripDatabaseHash() => r'3513eeff0d0ded8bb6b9046a947205648b757b37';

@ProviderFor(tripMemory)
final tripMemoryProvider = TripMemoryProvider._();

final class TripMemoryProvider
    extends $FunctionalProvider<TripMemory, TripMemory, TripMemory>
    with $Provider<TripMemory> {
  TripMemoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripMemoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripMemoryHash();

  @$internal
  @override
  $ProviderElement<TripMemory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripMemory create(Ref ref) {
    return tripMemory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripMemory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripMemory>(value),
    );
  }
}

String _$tripMemoryHash() => r'72781d9a2354c99cf27bb562dc7558571875aece';

@ProviderFor(memorizeDocument)
final memorizeDocumentProvider = MemorizeDocumentProvider._();

final class MemorizeDocumentProvider
    extends
        $FunctionalProvider<
          MemorizeDocument,
          MemorizeDocument,
          MemorizeDocument
        >
    with $Provider<MemorizeDocument> {
  MemorizeDocumentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memorizeDocumentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memorizeDocumentHash();

  @$internal
  @override
  $ProviderElement<MemorizeDocument> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MemorizeDocument create(Ref ref) {
    return memorizeDocument(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemorizeDocument value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemorizeDocument>(value),
    );
  }
}

String _$memorizeDocumentHash() => r'96e4827d0f9df7139e4f86b5cfbe61f8ba940833';

@ProviderFor(searchMemory)
final searchMemoryProvider = SearchMemoryProvider._();

final class SearchMemoryProvider
    extends $FunctionalProvider<SearchMemory, SearchMemory, SearchMemory>
    with $Provider<SearchMemory> {
  SearchMemoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchMemoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchMemoryHash();

  @$internal
  @override
  $ProviderElement<SearchMemory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchMemory create(Ref ref) {
    return searchMemory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchMemory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchMemory>(value),
    );
  }
}

String _$searchMemoryHash() => r'0dff1a1793ad0747f9cbde4a2e438d606a8001eb';

@ProviderFor(documents)
final documentsProvider = DocumentsProvider._();

final class DocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TripDocument>>,
          List<TripDocument>,
          Stream<List<TripDocument>>
        >
    with
        $FutureModifier<List<TripDocument>>,
        $StreamProvider<List<TripDocument>> {
  DocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsHash();

  @$internal
  @override
  $StreamProviderElement<List<TripDocument>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TripDocument>> create(Ref ref) {
    return documents(ref);
  }
}

String _$documentsHash() => r'a28bc50c5c8972b0631e07256be8138ea45a819d';

@ProviderFor(documentReader)
final documentReaderProvider = DocumentReaderProvider._();

final class DocumentReaderProvider
    extends $FunctionalProvider<DocumentReader, DocumentReader, DocumentReader>
    with $Provider<DocumentReader> {
  DocumentReaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentReaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentReaderHash();

  @$internal
  @override
  $ProviderElement<DocumentReader> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentReader create(Ref ref) {
    return documentReader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentReader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentReader>(value),
    );
  }
}

String _$documentReaderHash() => r'2cd0fddabed95ec09fe881697846fda40a4485ae';

/// The file picker. Tests override it with a prepared file.

@ProviderFor(documentPicker)
final documentPickerProvider = DocumentPickerProvider._();

/// The file picker. Tests override it with a prepared file.

final class DocumentPickerProvider
    extends
        $FunctionalProvider<
          Future<DocumentFile?> Function(),
          Future<DocumentFile?> Function(),
          Future<DocumentFile?> Function()
        >
    with $Provider<Future<DocumentFile?> Function()> {
  /// The file picker. Tests override it with a prepared file.
  DocumentPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentPickerHash();

  @$internal
  @override
  $ProviderElement<Future<DocumentFile?> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<DocumentFile?> Function() create(Ref ref) {
    return documentPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<DocumentFile?> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<DocumentFile?> Function()>(
        value,
      ),
    );
  }
}

String _$documentPickerHash() => r'278591c0f9969e598cbb061d4499e7b557a8c6a3';

@ProviderFor(addDocumentFile)
final addDocumentFileProvider = AddDocumentFileProvider._();

final class AddDocumentFileProvider
    extends
        $FunctionalProvider<AddDocumentFile, AddDocumentFile, AddDocumentFile>
    with $Provider<AddDocumentFile> {
  AddDocumentFileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addDocumentFileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addDocumentFileHash();

  @$internal
  @override
  $ProviderElement<AddDocumentFile> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddDocumentFile create(Ref ref) {
    return addDocumentFile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddDocumentFile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddDocumentFile>(value),
    );
  }
}

String _$addDocumentFileHash() => r'6b9cddb40e3cf1cfc94e651261e1d31fb2af1364';

@ProviderFor(answerWriter)
final answerWriterProvider = AnswerWriterProvider._();

final class AnswerWriterProvider
    extends $FunctionalProvider<AnswerWriter, AnswerWriter, AnswerWriter>
    with $Provider<AnswerWriter> {
  AnswerWriterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'answerWriterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$answerWriterHash();

  @$internal
  @override
  $ProviderElement<AnswerWriter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnswerWriter create(Ref ref) {
    return answerWriter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnswerWriter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnswerWriter>(value),
    );
  }
}

String _$answerWriterHash() => r'33b0564f1629cbbb6bf2d522c4548ef6d346cfa3';

@ProviderFor(askTrip)
final askTripProvider = AskTripProvider._();

final class AskTripProvider
    extends $FunctionalProvider<AskTrip, AskTrip, AskTrip>
    with $Provider<AskTrip> {
  AskTripProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'askTripProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$askTripHash();

  @$internal
  @override
  $ProviderElement<AskTrip> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AskTrip create(Ref ref) {
    return askTrip(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AskTrip value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AskTrip>(value),
    );
  }
}

String _$askTripHash() => r'4e6d0b41e9304d3be98575cdeb45eed59e49fa49';

/// The answer to [question], from the documents as they are now.

@ProviderFor(tripAnswer)
final tripAnswerProvider = TripAnswerFamily._();

/// The answer to [question], from the documents as they are now.

final class TripAnswerProvider
    extends $FunctionalProvider<AsyncValue<Answer>, Answer, FutureOr<Answer>>
    with $FutureModifier<Answer>, $FutureProvider<Answer> {
  /// The answer to [question], from the documents as they are now.
  TripAnswerProvider._({
    required TripAnswerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tripAnswerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tripAnswerHash();

  @override
  String toString() {
    return r'tripAnswerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Answer> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Answer> create(Ref ref) {
    final argument = this.argument as String;
    return tripAnswer(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TripAnswerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tripAnswerHash() => r'083c43f02eb3ccd574b800a70127e032ab16785a';

/// The answer to [question], from the documents as they are now.

final class TripAnswerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Answer>, String> {
  TripAnswerFamily._()
    : super(
        retry: null,
        name: r'tripAnswerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The answer to [question], from the documents as they are now.

  TripAnswerProvider call(String question) =>
      TripAnswerProvider._(argument: question, from: this);

  @override
  String toString() => r'tripAnswerProvider';
}

@ProviderFor(chatWriter)
final chatWriterProvider = ChatWriterProvider._();

final class ChatWriterProvider
    extends $FunctionalProvider<ChatWriter, ChatWriter, ChatWriter>
    with $Provider<ChatWriter> {
  ChatWriterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatWriterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatWriterHash();

  @$internal
  @override
  $ProviderElement<ChatWriter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatWriter create(Ref ref) {
    return chatWriter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatWriter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatWriter>(value),
    );
  }
}

String _$chatWriterHash() => r'707bb9c8c1c9c6ab8791b532cd0eb1b313d310f2';

/// One conversation, kept while the app runs.

@ProviderFor(tripChat)
final tripChatProvider = TripChatProvider._();

/// One conversation, kept while the app runs.

final class TripChatProvider
    extends $FunctionalProvider<TripChat, TripChat, TripChat>
    with $Provider<TripChat> {
  /// One conversation, kept while the app runs.
  TripChatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripChatProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripChatHash();

  @$internal
  @override
  $ProviderElement<TripChat> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripChat create(Ref ref) {
    return tripChat(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripChat value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripChat>(value),
    );
  }
}

String _$tripChatHash() => r'b2cb096a35f0ac4fac0329241abf355972c9594a';

@ProviderFor(itinerary)
final itineraryProvider = ItineraryProvider._();

final class ItineraryProvider
    extends $FunctionalProvider<Itinerary, Itinerary, Itinerary>
    with $Provider<Itinerary> {
  ItineraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itineraryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itineraryHash();

  @$internal
  @override
  $ProviderElement<Itinerary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Itinerary create(Ref ref) {
    return itinerary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Itinerary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Itinerary>(value),
    );
  }
}

String _$itineraryHash() => r'808ca1c178dcbaae20a7e3206ea1310ebb8fa49b';

@ProviderFor(bookings)
final bookingsProvider = BookingsProvider._();

final class BookingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Booking>>,
          List<Booking>,
          Stream<List<Booking>>
        >
    with $FutureModifier<List<Booking>>, $StreamProvider<List<Booking>> {
  BookingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingsHash();

  @$internal
  @override
  $StreamProviderElement<List<Booking>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Booking>> create(Ref ref) {
    return bookings(ref);
  }
}

String _$bookingsHash() => r'9af2d361233140bfccbade53f57244dff681819c';

/// The phone's IANA time zone, e.g. "Asia/Yangon". Tests override it.

@ProviderFor(homeTimeZone)
final homeTimeZoneProvider = HomeTimeZoneProvider._();

/// The phone's IANA time zone, e.g. "Asia/Yangon". Tests override it.

final class HomeTimeZoneProvider
    extends
        $FunctionalProvider<
          Future<String> Function(),
          Future<String> Function(),
          Future<String> Function()
        >
    with $Provider<Future<String> Function()> {
  /// The phone's IANA time zone, e.g. "Asia/Yangon". Tests override it.
  HomeTimeZoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeTimeZoneProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeTimeZoneHash();

  @$internal
  @override
  $ProviderElement<Future<String> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<String> Function() create(Ref ref) {
    return homeTimeZone(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<String> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<String> Function()>(value),
    );
  }
}

String _$homeTimeZoneHash() => r'76fd8e88f24dd8418c4da2fa97cc6b6227b76445';

@ProviderFor(tripTools)
final tripToolsProvider = TripToolsProvider._();

final class TripToolsProvider
    extends $FunctionalProvider<TripTools, TripTools, TripTools>
    with $Provider<TripTools> {
  TripToolsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripToolsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripToolsHash();

  @$internal
  @override
  $ProviderElement<TripTools> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripTools create(Ref ref) {
    return tripTools(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripTools value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripTools>(value),
    );
  }
}

String _$tripToolsHash() => r'ac19cdc8b08f8a956d92d5cd49a3923ec11a928c';
