import 'dart:async';
import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Left;

import 'data/auth/firebase_auth_repository.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth.dart';
import 'presentation/providers/dependencies.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebase = await _startFirebase();
  // Day 90: everyone gets a guest account on the first launch, without a
  // sign-in screen. Not awaited: offline, the app still starts.
  if (firebase) unawaited(_startGuestSession());
  runApp(
    ProviderScope(
      // A local database won't fix itself by trying again (Day 47):
      // show errors right away.
      retry: _noRetry,
      overrides: [
        aiEnabledProvider.overrideWithValue(firebase),
        firebaseReadyProvider.overrideWithValue(firebase),
      ],
      child: const SpendbookApp(),
    ),
  );
}

/// Day 70: Firebase is only needed for AI. If it isn't set up (or not for
/// this platform), Spendbook works as before, without the AI features.
Future<bool> _startFirebase() async {
  // App Check on the web needs a reCAPTCHA key: not covered in this series.
  if (kIsWeb) return false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Proves requests come from this app, not from someone who copied the
    // Firebase settings. Firebase AI Logic requires it.
    await FirebaseAppCheck.instance.activate(
      // Debug builds: a debug token you register in the Firebase console.
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode
          ? const AppleDebugProvider()
          : const AppleAppAttestWithDeviceCheckFallbackProvider(),
    );
    // Day 90: the Auth emulator instead of the real Firebase Auth, e.g.
    // --dart-define=AUTH_EMULATOR=localhost:9099
    // localhost is this computer: fine for a simulator or an emulator.
    if (_authEmulator case [final host, final port]) {
      await FirebaseAuth.instance.useAuthEmulator(host, int.parse(port));
    }
    return true;
  } on UnsupportedError catch (e) {
    // What firebase_options.dart throws for a platform it has no settings
    // for (and our placeholder, before `flutterfire configure`).
    log('AI features off: $e');
    return false;
  } on FirebaseException catch (e) {
    log('AI features off: $e');
    return false;
  }
}

Duration? _noRetry(int retryCount, Object error) => null;

const _authEmulatorSetting = String.fromEnvironment('AUTH_EMULATOR');

/// host:port, or nothing when the setting is missing or not in that shape.
final _authEmulator = switch (_authEmulatorSetting.split(':')) {
  [final host, final port] when int.tryParse(port) != null => [host, port],
  _ => const <String>[],
};

/// A guest account, unless someone is already signed in.
Future<void> _startGuestSession() async {
  if (FirebaseAuth.instance.currentUser != null) return;
  final result = await FirebaseAuthRepository(FirebaseAuth.instance)
      .continueAsGuest();
  if (result case Left(value: final failure)) {
    log('No guest account yet: ${failure.message}');
  }
}

class SpendbookApp extends StatelessWidget {
  const SpendbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendbook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      // Day 88: a dark theme, following the phone's setting.
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
