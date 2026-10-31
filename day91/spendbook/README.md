# Day 91: Cloud Sync with Firestore - Offline-First with Drift

The **Spendbook** app at the end of Day 91 of [100 Days of Flutter](../../README.md).

Article: https://arkar.dev/day-91-firestore-sync/

```bash
fvm flutter pub get
fvm dart run build_runner build
fvm flutter run
```

### Firebase (AI features)

The AI features (Days 70-74) need your own Firebase project with Firebase AI Logic and App Check (see Day 70):

```bash
flutterfire configure
```

Without it, `lib/firebase_options.dart` is a placeholder and Spendbook runs without the AI features.

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

### Integration tests (Day 89)

On an Android emulator, an iOS Simulator or a phone (`fvm flutter devices` lists the ids):

```bash
fvm flutter test integration_test/app_test.dart -d <device id>
```

### Tests

```bash
fvm flutter test
```

The tests tagged `screenshots` render the blog's images and are skipped by default (see `dart_test.yaml`).
