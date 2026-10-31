// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Firebase started (Day 90; see main.dart). Without a Firebase
/// project there is no sign-in, and Spendbook works as before.

@ProviderFor(firebaseReady)
final firebaseReadyProvider = FirebaseReadyProvider._();

/// Whether Firebase started (Day 90; see main.dart). Without a Firebase
/// project there is no sign-in, and Spendbook works as before.

final class FirebaseReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether Firebase started (Day 90; see main.dart). Without a Firebase
  /// project there is no sign-in, and Spendbook works as before.
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

/// Null when Firebase isn't set up. Tests put a fake here.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Null when Firebase isn't set up. Tests put a fake here.

final class AuthRepositoryProvider
    extends
        $FunctionalProvider<AuthRepository?, AuthRepository?, AuthRepository?>
    with $Provider<AuthRepository?> {
  /// Null when Firebase isn't set up. Tests put a fake here.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository? create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository?>(value),
    );
  }
}

String _$authRepositoryHash() => r'f0ea4aadcbbd4a2e581ec07a9958cb58bd9eac0a';

/// Who is signed in: null for nobody (or no Firebase).

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Who is signed in: null for nobody (or no Firebase).

final class CurrentUserProvider
    extends
        $FunctionalProvider<AsyncValue<AppUser?>, AppUser?, Stream<AppUser?>>
    with $FutureModifier<AppUser?>, $StreamProvider<AppUser?> {
  /// Who is signed in: null for nobody (or no Firebase).
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $StreamProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppUser?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'6aea83931b8d428b01c47c5a932b6c0a1917fd67';

@ProviderFor(createAccount)
final createAccountProvider = CreateAccountProvider._();

final class CreateAccountProvider
    extends $FunctionalProvider<CreateAccount?, CreateAccount?, CreateAccount?>
    with $Provider<CreateAccount?> {
  CreateAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createAccountHash();

  @$internal
  @override
  $ProviderElement<CreateAccount?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateAccount? create(Ref ref) {
    return createAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateAccount? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateAccount?>(value),
    );
  }
}

String _$createAccountHash() => r'f6741a77f60fb8abffa5bbee3da2a79a2e9ff146';

@ProviderFor(signIn)
final signInProvider = SignInProvider._();

final class SignInProvider
    extends $FunctionalProvider<SignIn?, SignIn?, SignIn?>
    with $Provider<SignIn?> {
  SignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInHash();

  @$internal
  @override
  $ProviderElement<SignIn?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignIn? create(Ref ref) {
    return signIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignIn? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignIn?>(value),
    );
  }
}

String _$signInHash() => r'b4250469ee9162d1791d9dac8f3e6245896cad9f';
