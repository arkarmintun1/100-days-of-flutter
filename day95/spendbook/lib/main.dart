import 'dart:async';
import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Left;

import 'data/auth/firebase_auth_repository.dart';
import 'environment.dart';
import 'presentation/providers/auth.dart';
import 'presentation/providers/dependencies.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Day 93: dev or prod, from `--flavor`.
  final environment = Environment.from(appFlavor);
  final firebase = await _startFirebase(environment);
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
      child: SpendbookApp(showsBanner: environment.showsBanner),
    ),
  );
}

/// Day 70: if Firebase isn't set up (or not for this platform), Spendbook
/// works without it: no AI, sign-in, sync, Crashlytics or Analytics.
Future<bool> _startFirebase(Environment environment) async {
  // App Check on the web needs a reCAPTCHA key: not covered in this series.
  if (kIsWeb) return false;
  try {
    await Firebase.initializeApp(options: environment.firebaseOptions);
    // Day 95: errors nobody caught are crashes in Crashlytics. Errors in
    // Flutter itself (build, layout, paint, gestures):
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Async errors outside the framework, e.g. a Future nobody awaited:
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    // Which flavor a report comes from (Day 93): a label, not essential,
    // so not awaited.
    unawaited(
      FirebaseCrashlytics.instance.setCustomKey('flavor', environment.name),
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
    if (_hostAndPort(_authEmulator) case (final host, final port)) {
      await FirebaseAuth.instance.useAuthEmulator(host, port);
    }
    // Day 91: Drift is the app's offline store, so Firestore keeps no
    // second copy on the phone.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
    // e.g. --dart-define=FIRESTORE_EMULATOR=localhost:8080
    if (_hostAndPort(_firestoreEmulator) case (final host, final port)) {
      FirebaseFirestore.instance.useFirestoreEmulator(host, port);
    }
    return true;
  } on UnsupportedError catch (e) {
    // What firebase_options_*.dart throws for a platform it has no settings
    // for (and our placeholder, before `flutterfire configure`).
    log('Firebase off: $e');
    return false;
  } on FirebaseException catch (e) {
    log('Firebase off: $e');
    return false;
  }
}

Duration? _noRetry(int retryCount, Object error) => null;

const _authEmulator = String.fromEnvironment('AUTH_EMULATOR');
const _firestoreEmulator = String.fromEnvironment('FIRESTORE_EMULATOR');

/// "host:port", or null when the setting is missing or not in that shape.
(String, int)? _hostAndPort(String setting) => switch (setting.split(':')) {
  [final host, final port] when int.tryParse(port) != null => (
    host,
    int.parse(port),
  ),
  _ => null,
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
  const SpendbookApp({super.key, this.showsBanner = false});

  /// Day 93: a "DEV" ribbon for the dev flavor.
  final bool showsBanner;

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
      builder: showsBanner
          ? (context, child) => Banner(
              message: 'DEV',
              location: BannerLocation.topStart,
              child: child!,
            )
          : null,
    );
  }
}
