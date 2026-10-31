import 'package:fpdart/fpdart.dart';

import '../entities/app_user.dart';
import '../failures.dart';

/// Signing in (Day 90). The domain doesn't know it's Firebase.
abstract interface class AuthRepository {
  /// The user now, and again whenever it changes. Null: nobody is signed in.
  Stream<AppUser?> watchUser();

  /// A guest account: an id, without an email or a password.
  Future<Either<Failure, AppUser>> continueAsGuest();

  /// Gives the signed-in guest an email and a password, and keeps their
  /// id. With nobody signed in, makes a new account.
  Future<Either<Failure, AppUser>> createAccount({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();
}
