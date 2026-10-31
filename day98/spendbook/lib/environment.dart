import 'package:firebase_core/firebase_core.dart';

import 'firebase_options_dev.dart' as dev_firebase;
import 'firebase_options_prod.dart' as prod_firebase;

/// Day 93: the two versions of Spendbook, one per flavor (`--flavor`).
enum Environment {
  /// For building and testing: its own app id, name and Firebase project.
  dev,

  /// What users install from the stores.
  prod;

  /// From Flutter's `appFlavor` (the --flavor name, or pubspec.yaml's
  /// default-flavor). Without a flavor, dev: prod is always chosen on
  /// purpose.
  static Environment from(String? flavor) => switch (flavor) {
    'prod' => prod,
    _ => dev,
  };

  /// Each environment has its own Firebase project (flutterfire configure
  /// writes one options file per project).
  FirebaseOptions get firebaseOptions => switch (this) {
    dev => dev_firebase.DefaultFirebaseOptions.currentPlatform,
    prod => prod_firebase.DefaultFirebaseOptions.currentPlatform,
  };

  /// A "DEV" ribbon in the corner, so nobody mistakes it for the real app.
  bool get showsBanner => this == dev;
}
