// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Null when Firebase isn't set up. Tests put a fake here.

@ProviderFor(syncRepository)
final syncRepositoryProvider = SyncRepositoryProvider._();

/// Null when Firebase isn't set up. Tests put a fake here.

final class SyncRepositoryProvider
    extends
        $FunctionalProvider<SyncRepository?, SyncRepository?, SyncRepository?>
    with $Provider<SyncRepository?> {
  /// Null when Firebase isn't set up. Tests put a fake here.
  SyncRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRepositoryHash();

  @$internal
  @override
  $ProviderElement<SyncRepository?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncRepository? create(Ref ref) {
    return syncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncRepository? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncRepository?>(value),
    );
  }
}

String _$syncRepositoryHash() => r'38976fc8058534a163acbd0b84dda7b1ba7b1235';

@ProviderFor(signOut)
final signOutProvider = SignOutProvider._();

final class SignOutProvider
    extends $FunctionalProvider<SignOut?, SignOut?, SignOut?>
    with $Provider<SignOut?> {
  SignOutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutHash();

  @$internal
  @override
  $ProviderElement<SignOut?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignOut? create(Ref ref) {
    return signOut(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignOut? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignOut?>(value),
    );
  }
}

String _$signOutHash() => r'5b4edcdb2cd51457d5a8d116ce457e5cbf377e8c';

/// Day 91: syncs when someone signs in, and a moment after every change on
/// this phone. Drift stays the source of truth: the screens never wait for
/// this.

@ProviderFor(Sync)
final syncProvider = SyncProvider._();

/// Day 91: syncs when someone signs in, and a moment after every change on
/// this phone. Drift stays the source of truth: the screens never wait for
/// this.
final class SyncProvider extends $NotifierProvider<Sync, SyncState> {
  /// Day 91: syncs when someone signs in, and a moment after every change on
  /// this phone. Drift stays the source of truth: the screens never wait for
  /// this.
  SyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncHash();

  @$internal
  @override
  Sync create() => Sync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncHash() => r'631a05688b861b333e5ea8539c8b3abc0c43a3a4';

/// Day 91: syncs when someone signs in, and a moment after every change on
/// this phone. Drift stays the source of truth: the screens never wait for
/// this.

abstract class _$Sync extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
