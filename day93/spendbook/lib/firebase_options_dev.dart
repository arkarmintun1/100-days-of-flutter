// A placeholder, so the project builds before you have a Firebase project.
//
// Day 93: the dev flavor's own Firebase project, so testing never touches
// real users' data. Replace this file with
//   flutterfire configure --project=<your dev project id> \
//     --out=lib/firebase_options_dev.dart
// Until then the app runs without Firebase (no AI, no sign-in, no sync).
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
    'No Firebase project for dev yet. Run `flutterfire configure` (Day 93).',
  );
}
