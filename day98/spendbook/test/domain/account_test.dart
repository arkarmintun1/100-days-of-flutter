import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/app_user.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/account.dart';

import '../helpers/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository auth;
  setUp(() => auth = FakeAuthRepository());

  group('CreateAccount', () {
    test('a guest keeps their id when they make an account', () async {
      final guest = (await auth.continueAsGuest()).getRight().toNullable()!;

      final result = await CreateAccount(auth)(
        email: '  mya@example.com ',
        password: 'long enough',
      );

      expect(
        result.getRight().toNullable(),
        AppUser(id: guest.id, email: 'mya@example.com'),
      );
    });

    test('checks the email and the password first', () async {
      final create = CreateAccount(auth);
      for (final (email, password) in [
        ('mya.example.com', 'long enough'),
        ('@example.com', 'long enough'),
        ('mya@', 'long enough'),
        ('mya @example.com', 'long enough'),
        ('mya@example.com', 'short'),
      ]) {
        final result = await create(email: email, password: password);
        expect(
          result.getLeft().toNullable(),
          isA<ValidationFailure>(),
          reason: '$email / $password',
        );
      }
      expect(auth.accounts, isEmpty);
    });
  });

  group('SignIn', () {
    test('needs a password', () async {
      final result = await SignIn(auth)(email: 'mya@example.com', password: '');
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    });

    test("the repository's failure comes back", () async {
      final result = await SignIn(auth)(
        email: 'mya@example.com',
        password: 'wrong one',
      );
      expect(
        result.getLeft().toNullable()?.message,
        'Wrong email or password.',
      );
    });
  });

  test('a guest has no email', () {
    expect(const AppUser(id: '1').isGuest, isTrue);
    expect(const AppUser(id: '1', email: 'a@b.co').isGuest, isFalse);
  });
}
