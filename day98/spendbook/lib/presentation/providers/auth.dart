import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/auth/firebase_auth_repository.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/account.dart';

part 'auth.g.dart';

/// Whether Firebase started (Day 90; see main.dart). Without a Firebase
/// project there is no sign-in, and Spendbook works as before.
@Riverpod(keepAlive: true)
bool firebaseReady(Ref ref) => false;

/// Null when Firebase isn't set up. Tests put a fake here.
@Riverpod(keepAlive: true)
AuthRepository? authRepository(Ref ref) => ref.watch(firebaseReadyProvider)
    ? FirebaseAuthRepository(FirebaseAuth.instance)
    : null;

/// Who is signed in: null for nobody (or no Firebase).
@Riverpod(keepAlive: true)
Stream<AppUser?> currentUser(Ref ref) =>
    ref.watch(authRepositoryProvider)?.watchUser() ?? Stream.value(null);

/// Day 91: only the id. Riverpod compares with ==, so a new User object
/// for the same person (e.g. a refreshed token) changes nothing here.
@Riverpod(keepAlive: true)
String? currentUserId(Ref ref) => ref.watch(currentUserProvider).value?.id;

@riverpod
CreateAccount? createAccount(Ref ref) =>
    switch (ref.watch(authRepositoryProvider)) {
      final repository? => CreateAccount(repository),
      null => null,
    };

@riverpod
SignIn? signIn(Ref ref) => switch (ref.watch(authRepositoryProvider)) {
  final repository? => SignIn(repository),
  null => null,
};
