// A placeholder, so the project builds before you have a Firebase project.
//
// Day 93: the prod flavor's Firebase project. Replace this file with
//   flutterfire configure --project=<your prod project id> \
//     --out=lib/firebase_options_prod.dart
// Until then the app runs without Firebase (no AI, no sign-in, no sync).
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
    'No Firebase project for prod yet. Run `flutterfire configure` (Day 93).',
  );
}
