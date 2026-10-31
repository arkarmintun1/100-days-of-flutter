import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spendbook/data/auth/firebase_auth_repository.dart';
import 'package:spendbook/domain/failures.dart';

/// Day 90: FirebaseAuthRepository against the Auth emulator, on a simulator:
///
///   firebase emulators:exec --only auth --project demo-spendbook \
///     "fvm flutter test integration_test/auth_emulator_test.dart -d DEVICE_ID"
///
/// A "demo-" project needs no Firebase account: only emulators can use it.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a guest makes an account, signs out and in again', (_) async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // Not a real key, but in the shape iOS checks for (39 characters,
        // starting with "A"): otherwise Firebase Installations aborts the app.
        apiKey: 'AIzaSyDemo0nlyForTheAuthEmulator0000000',
        appId: '1:1234567890:ios:0123456789abcdef',
        messagingSenderId: '1234567890',
        projectId: 'demo-spendbook',
      ),
    );
    // On Android, "localhost" is mapped to the computer (10.0.2.2).
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

    final repository = FirebaseAuthRepository(FirebaseAuth.instance);
    final email = 'mya${DateTime.now().millisecondsSinceEpoch}@example.com';

    final guest = (await repository.continueAsGuest()).getRight().toNullable()!;
    expect(guest.isGuest, isTrue);

    final account = (await repository.createAccount(
      email: email,
      password: 'long enough',
    )).getRight().toNullable()!;
    expect(account.id, guest.id); // linked, not a new user
    expect(account.email, email);

    await repository.signOut();
    final wrong = await repository.signIn(email: email, password: 'not it!!');
    expect(wrong.getLeft().toNullable(), isA<AuthFailure>());

    final again = await repository.signIn(
      email: email,
      password: 'long enough',
    );
    expect(again.getRight().toNullable()!.id, guest.id);

    // Another guest can't take the same email.
    await repository.signOut();
    await repository.continueAsGuest();
    final taken = await repository.createAccount(
      email: email,
      password: 'long enough',
    );
    expect(
      taken.getLeft().toNullable()!.message,
      'This email already has an account. Sign in instead.',
    );
  });
}
