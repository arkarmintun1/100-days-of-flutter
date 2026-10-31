import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/app_user.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_auth_repository.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/fake_sync_repository.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> openAccount(
    WidgetTester tester,
    FakeAuthRepository? auth, {
    FakeSyncRepository? sync,
  }) async {
    await tester.pumpWidget(
      testApp(FakeExpenseRepository(), auth: auth, sync: sync),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Account'));
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextField, label);

  testWidgets('no Firebase: no sign-in', (tester) async {
    await openAccount(tester, null);
    expect(
      find.textContaining('needs your own Firebase project'),
      findsOneWidget,
    );
  });

  testWidgets('a guest makes an account and keeps their id', (tester) async {
    final auth = FakeAuthRepository(signedIn: const AppUser(id: 'guest-1'));
    await openAccount(tester, auth);
    expect(find.text('You are using Spendbook as a guest'), findsOneWidget);

    await tester.enterText(field('Email'), 'mya@example.com');
    await tester.enterText(field('Password'), 'long enough');
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Signed in'), findsOneWidget);
    expect(find.text('mya@example.com'), findsOneWidget);
    expect(auth.user, const AppUser(id: 'guest-1', email: 'mya@example.com'));
  });

  testWidgets('errors are shown under the form', (tester) async {
    final auth = FakeAuthRepository(signedIn: const AppUser(id: 'guest-1'));
    await openAccount(tester, auth);

    await tester.enterText(field('Email'), 'mya@example.com');
    await tester.enterText(field('Password'), 'short');
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(
      find.text('Use a password of at least 8 characters.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Already have an account? Sign in'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Password'), 'not the one');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Wrong email or password.'), findsOneWidget);
    expect(auth.user!.isGuest, isTrue);
  });

  testWidgets('sign out, then continue as a guest', (tester) async {
    final auth = FakeAuthRepository(
      signedIn: const AppUser(id: 'u1', email: 'mya@example.com'),
    );
    await openAccount(tester, auth);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('You are not signed in'), findsOneWidget);

    await tester.tap(find.text('Continue as a guest'));
    await tester.pumpAndSettle();
    expect(find.text('You are using Spendbook as a guest'), findsOneWidget);
  });

  testWidgets('Day 91: syncs when signed in, and says when', (tester) async {
    final sync = FakeSyncRepository();
    await openAccount(
      tester,
      FakeAuthRepository(
        signedIn: const AppUser(id: 'u1', email: 'mya@example.com'),
      ),
      sync: sync,
    );

    expect(sync.synced, ['u1']);
    expect(find.text('Synced at 10:00 AM'), findsOneWidget); // testNow

    sync.failWith = const NetworkFailure('No connection. Syncing later.');
    await tester.tap(find.byTooltip('Sync now'));
    await tester.pumpAndSettle();
    expect(find.text('No connection. Syncing later.'), findsOneWidget);
  });

  testWidgets('Day 91: changes stuck offline: the user decides', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      signedIn: const AppUser(id: 'u1', email: 'mya@example.com'),
    );
    final sync = FakeSyncRepository()
      ..pendingNow = 2
      ..failWith = const NetworkFailure('No connection.');
    await openAccount(tester, auth, sync: sync);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out anyway?'), findsOneWidget);

    await tester.tap(find.text('Stay signed in'));
    await tester.pumpAndSettle();
    expect(auth.user, isNotNull);
    expect(sync.cleared, isFalse);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out anyway'));
    await tester.pumpAndSettle();
    expect(auth.user, isNull);
    expect(sync.cleared, isTrue);
  });
}
