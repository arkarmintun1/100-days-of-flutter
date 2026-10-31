import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' as fake;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendbook/data/auth/firebase_auth_repository.dart';
import 'package:spendbook/domain/entities/app_user.dart';
import 'package:spendbook/domain/failures.dart';

// Day 87's mocks, for what the fake below can't do.
class MockAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockCredential extends Mock implements UserCredential {}

void main() {
  group('with firebase_auth_mocks (a fake FirebaseAuth)', () {
    test('a guest: signed out, then an id without an email', () async {
      final auth = fake.MockFirebaseAuth();
      final repository = FirebaseAuthRepository(auth);
      final users = <AppUser?>[];
      final subscription = repository.watchUser().listen(users.add);
      addTearDown(subscription.cancel);

      final guest = await repository.continueAsGuest();
      await pumpEventQueue();

      expect(guest.getRight().toNullable()!.isGuest, isTrue);
      expect(users, [null, guest.getRight().toNullable()]);
    });

    test('signing in gives the account', () async {
      final auth = fake.MockFirebaseAuth(
        mockUser: fake.MockUser(uid: 'u1', email: 'mya@example.com'),
      );

      final result = await FirebaseAuthRepository(auth)
          .signIn(email: 'mya@example.com', password: 'long enough');

      expect(
        result.getRight().toNullable(),
        const AppUser(id: 'u1', email: 'mya@example.com'),
      );
    });
  });

  group('with mocktail', () {
    late MockAuth auth;
    late MockUser user;
    setUpAll(() {
      registerFallbackValue(
        EmailAuthProvider.credential(email: 'x@y.co', password: 'x'),
      );
    });
    setUp(() {
      auth = MockAuth();
      user = MockUser();
    });

    test('a guest is linked, not replaced: the id stays', () async {
      final linked = MockUser();
      when(() => linked.uid).thenReturn('guest-1');
      when(() => linked.email).thenReturn('mya@example.com');
      final credential = MockCredential();
      when(() => credential.user).thenReturn(linked);
      when(() => user.isAnonymous).thenReturn(true);
      when(() => user.linkWithCredential(any()))
          .thenAnswer((_) async => credential);
      when(() => auth.currentUser).thenReturn(user);

      final result = await FirebaseAuthRepository(auth)
          .createAccount(email: 'mya@example.com', password: 'long enough');

      expect(
        result.getRight().toNullable(),
        const AppUser(id: 'guest-1', email: 'mya@example.com'),
      );
      final sent =
          verify(() => user.linkWithCredential(captureAny())).captured.single
              as AuthCredential;
      expect(sent.providerId, 'password');
      verifyNever(
        () => auth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    test("Firebase's error codes become messages", () async {
      when(() => auth.currentUser).thenReturn(null);
      final repository = FirebaseAuthRepository(auth);
      for (final (code, expected) in [
        ('invalid-credential', 'Wrong email or password.'),
        ('email-already-in-use', 'This email already has an account.'),
        ('network-request-failed', 'No connection.'),
        ('something-new', "Couldn't sign in."),
      ]) {
        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: code));

        final result = await repository.signIn(
          email: 'mya@example.com',
          password: 'long enough',
        );

        expect(
          result.getLeft().toNullable()!.message,
          startsWith(expected),
          reason: code,
        );
      }
    });

    test('no connection is a NetworkFailure', () {
      expect(
        authFailure(FirebaseAuthException(code: 'network-request-failed')),
        isA<NetworkFailure>(),
      );
    });
  });
}
