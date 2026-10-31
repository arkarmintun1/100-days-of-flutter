import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/failures.dart';
import '../../domain/repositories/auth_repository.dart';

/// Firebase Authentication behind the domain's AuthRepository (Day 90).
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  Stream<AppUser?> watchUser() =>
      // userChanges, not authStateChanges: linking an email to the guest
      // keeps the same user signed in, so authStateChanges says nothing.
      _auth.userChanges().map(_toAppUser);

  @override
  Future<Either<Failure, AppUser>> continueAsGuest() =>
      _run(() => _auth.signInAnonymously());

  @override
  Future<Either<Failure, AppUser>> createAccount({
    required String email,
    required String password,
  }) {
    final user = _auth.currentUser;
    if (user != null && user.isAnonymous) {
      // Link, don't create: the guest keeps their id.
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      return _run(() => user.linkWithCredential(credential));
    }
    return _run(
      () => _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) => _run(
    () => _auth.signInWithEmailAndPassword(email: email, password: password),
  );

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _auth.signOut();
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(authFailure(e));
    }
  }

  Future<Either<Failure, AppUser>> _run(
    Future<UserCredential> Function() action,
  ) async {
    try {
      final credential = await action();
      final user = _toAppUser(credential.user);
      if (user == null) return left(const AuthFailure("Couldn't sign in."));
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(authFailure(e));
    }
  }

  static AppUser? _toAppUser(User? user) =>
      user == null ? null : AppUser(id: user.uid, email: user.email);
}

/// Firebase's error codes as messages people understand. The codes are the
/// ones the firebase_auth docs list for these calls.
Failure authFailure(FirebaseAuthException e) => switch (e.code) {
  'network-request-failed' => const NetworkFailure(
    'No connection. Try again when you are online.',
  ),
  'invalid-email' => const AuthFailure('That email address is not valid.'),
  'weak-password' => const AuthFailure('Choose a stronger password.'),
  'email-already-in-use' || 'credential-already-in-use' => const AuthFailure(
    'This email already has an account. Sign in instead.',
  ),
  // Since September 2023, new projects return this for a wrong email *or*
  // password, so nobody can find out which emails have accounts.
  'invalid-credential' ||
  'user-not-found' ||
  'wrong-password' => const AuthFailure('Wrong email or password.'),
  'user-disabled' => const AuthFailure('This account has been disabled.'),
  'too-many-requests' => const AuthFailure(
    'Too many attempts. Wait a moment and try again.',
  ),
  'operation-not-allowed' => const AuthFailure(
    'This way of signing in is not turned on in Firebase.',
  ),
  _ => const AuthFailure("Couldn't sign in. Try again."),
};
