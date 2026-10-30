# Day 73: GenUI - When Gemini Answers with Widgets

The **Spendbook** app at the end of Day 73 of [100 Days of Flutter](../../README.md).

Article: https://arkar.dev/day-73-genui-sdk/

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

### Tests

```bash
fvm flutter test
```

The tests tagged `screenshots` render the blog's images and are skipped by default (see `dart_test.yaml`).
