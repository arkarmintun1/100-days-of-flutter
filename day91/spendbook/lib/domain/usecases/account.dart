import 'package:fpdart/fpdart.dart';

import '../entities/app_user.dart';
import '../failures.dart';
import '../repositories/auth_repository.dart';

/// Turns the guest into an account with an email and a password (Day 90).
class const CreateAccount(final AuthRepository _repository) {
  /// Spendbook's own rule. Firebase's default only asks for 6 characters.
  static const minPasswordLength = 8;

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    if (_checkEmail(cleanEmail) case final failure?) return left(failure);
    if (password.length < minPasswordLength) {
      return left(
        const ValidationFailure(
          'Use a password of at least $minPasswordLength characters.',
        ),
      );
    }
    return _repository.createAccount(email: cleanEmail, password: password);
  }
}

/// Signs in to an account that already exists.
class const SignIn(final AuthRepository _repository) {
  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    if (_checkEmail(cleanEmail) case final failure?) return left(failure);
    if (password.isEmpty) {
      return left(const ValidationFailure('Enter your password.'));
    }
    return _repository.signIn(email: cleanEmail, password: password);
  }
}

/// Only a quick check: whether the email exists is Firebase's job.
ValidationFailure? _checkEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 0 || at == email.length - 1 || email.contains(' ')) {
    return const ValidationFailure('Enter an email like name@example.com.');
  }
  return null;
}
