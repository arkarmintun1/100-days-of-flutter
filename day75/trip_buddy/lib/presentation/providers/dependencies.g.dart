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

/// The sample notes with their vectors. Embedded once: every search
/// reuses them and only embeds the question.

@ProviderFor(notesIndex)
final notesIndexProvider = NotesIndexProvider._();

/// The sample notes with their vectors. Embedded once: every search
/// reuses them and only embeds the question.

final class NotesIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<({String item, Float32List vector})>>,
          List<({String item, Float32List vector})>,
          FutureOr<List<({String item, Float32List vector})>>
        >
    with
        $FutureModifier<List<({String item, Float32List vector})>>,
        $FutureProvider<List<({String item, Float32List vector})>> {
  /// The sample notes with their vectors. Embedded once: every search
  /// reuses them and only embeds the question.
  NotesIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesIndexProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesIndexHash();

  @$internal
  @override
  $FutureProviderElement<List<({String item, Float32List vector})>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<({String item, Float32List vector})>> create(Ref ref) {
    return notesIndex(ref);
  }
}

String _$notesIndexHash() => r'2c521689699a70e0d3fc7f09ecf77cd1de1f3197';

/// The notes closest in meaning to [query], best first.

@ProviderFor(noteSearch)
final noteSearchProvider = NoteSearchFamily._();

/// The notes closest in meaning to [query], best first.

final class NoteSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Scored<String>>>,
          List<Scored<String>>,
          FutureOr<List<Scored<String>>>
        >
    with
        $FutureModifier<List<Scored<String>>>,
        $FutureProvider<List<Scored<String>>> {
  /// The notes closest in meaning to [query], best first.
  NoteSearchProvider._({
    required NoteSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'noteSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$noteSearchHash();

  @override
  String toString() {
    return r'noteSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Scored<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Scored<String>>> create(Ref ref) {
    final argument = this.argument as String;
    return noteSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteSearchHash() => r'3f284cd6b778e6c8ac659007603d6f5245d81f41';

/// The notes closest in meaning to [query], best first.

final class NoteSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Scored<String>>>, String> {
  NoteSearchFamily._()
    : super(
        retry: null,
        name: r'noteSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The notes closest in meaning to [query], best first.

  NoteSearchProvider call(String query) =>
      NoteSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'noteSearchProvider';
}
