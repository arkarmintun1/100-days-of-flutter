import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'presentation/providers/dependencies.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/setup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ready = await _startFirebase();
  runApp(
    ProviderScope(
      // Show errors right away; the screens have a "Try again" button
      // (Day 47).
      retry: (_, _) => null,
      overrides: [firebaseReadyProvider.overrideWithValue(ready)],
      child: const TripBuddyApp(),
    ),
  );
}

/// Trip Buddy's AI runs on Firebase. Without a Firebase project it shows
/// how to set one up instead.
Future<bool> _startFirebase() async {
  // App Check on the web needs a reCAPTCHA key: not covered in this series.
  if (kIsWeb) return false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Our Cloud Function only answers requests with a valid App Check
    // token (enforceAppCheck), as Day 70.
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode
          ? const AppleDebugProvider()
          : const AppleAppAttestWithDeviceCheckFallbackProvider(),
    );
    return true;
  } on UnsupportedError catch (e) {
    // The placeholder firebase_options.dart, before `flutterfire configure`.
    log('Firebase not set up: $e');
    return false;
  } on FirebaseException catch (e) {
    log('Firebase not set up: $e');
    return false;
  }
}

class TripBuddyApp extends ConsumerWidget {
  const TripBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Trip Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: ref.watch(firebaseReadyProvider)
          ? const HomeScreen()
          : const SetupScreen(),
    );
  }
}
