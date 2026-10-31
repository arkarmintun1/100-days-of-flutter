# Day 94: CI with GitHub Actions

[![Spendbook (Day 94)](https://github.com/arkarmintun1/100-days-of-flutter/actions/workflows/day94_spendbook.yml/badge.svg)](https://github.com/arkarmintun1/100-days-of-flutter/actions/workflows/day94_spendbook.yml)

The **Spendbook** app at the end of Day 94 of [100 Days of Flutter](../../README.md).

Article: https://arkar.dev/day-94-github-actions-ci/

```bash
fvm flutter pub get
fvm dart run build_runner build
fvm flutter run
```

### Flavors (Day 93)

Two flavors: `dev` (app id `dev.arkar.flutter100.spendbook.dev`, "Spendbook Dev", a DEV banner) and `prod`. `dev` is the default flavor (`default-flavor` in `pubspec.yaml`).

```bash
fvm flutter run --flavor dev --dart-define-from-file=config/dev.json
fvm flutter run --flavor prod --dart-define-from-file=config/prod.json
```

`config/dev.json` points the app at the Auth and Firestore emulators. Each flavor needs its own Firebase project (Day 70, 90-92):

```bash
flutterfire configure --project=<dev project id> --out=lib/firebase_options_dev.dart \
  --android-package-name=dev.arkar.flutter100.spendbook.dev --android-out=android/app/src/dev/google-services.json \
  --ios-bundle-id=dev.arkar.flutter100.spendbook.dev --ios-out=ios/flavors/dev/GoogleService-Info.plist
flutterfire configure --project=<prod project id> --out=lib/firebase_options_prod.dart \
  --android-package-name=dev.arkar.flutter100.spendbook --android-out=android/app/src/prod/google-services.json \
  --ios-bundle-id=dev.arkar.flutter100.spendbook --ios-out=ios/flavors/prod/GoogleService-Info.plist
```

Without them, `lib/firebase_options_*.dart` are placeholders and Spendbook runs without the Firebase features.

### Sign-in (Day 90)

In your Firebase project, turn on the Anonymous and Email/Password sign-in methods. To try it with the Auth emulator instead (Firebase CLI needed):

```bash
firebase emulators:start --only auth --project <your project id>
fvm flutter run --dart-define=AUTH_EMULATOR=localhost:9099
```

The Auth emulator test (no Firebase project needed):

```bash
firebase emulators:exec --only auth --project demo-spendbook \
  "fvm flutter test integration_test/auth_emulator_test.dart -d <device id>"
```

### Cloud sync (Day 91)

Create a Firestore database in your Firebase project. The sync test with the Auth and Firestore emulators (the Firestore emulator needs Java 21 or newer, e.g. `export JAVA_HOME=$(/usr/libexec/java_home -v 21+)` on a Mac):

```bash
firebase emulators:exec --only auth,firestore --project demo-spendbook \
  "fvm flutter test integration_test/sync_emulator_test.dart -d <device id>"
```

### Security Rules (Day 92)

The rules tests (Node.js 24.12 or newer, the Firestore emulator):

```bash
npm ci --prefix firestore-tests
firebase emulators:exec --only firestore --project demo-spendbook \
  "npm --prefix firestore-tests test"
```

Deploy them to your project: `firebase deploy --only firestore:rules --project <your project id>`.

### Integration tests (Day 89)

On an Android emulator, an iOS Simulator or a phone (`fvm flutter devices` lists the ids):

```bash
fvm flutter test integration_test/app_test.dart -d <device id>
```

### CI (Day 94)

GitHub Actions: [`.github/workflows/day94_spendbook.yml`](../../.github/workflows/day94_spendbook.yml) checks the Day 94 folder on every push and pull request (format, analyze, tests without goldens, the Firestore rules tests, a release APK of the prod flavor).

### Tests

```bash
fvm flutter test
```

The tests tagged `screenshots` render the blog's images and are skipped by default (see `dart_test.yaml`).
