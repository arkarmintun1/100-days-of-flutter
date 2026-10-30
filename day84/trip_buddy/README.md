# Day 84: GenUI Forecast - Weather Tool & ForecastCard

The **Trip Buddy** app at the end of Day 84 of [100 Days of Flutter](../../README.md).

Article: https://arkar.dev/day-84-genui-forecast-card/

```bash
fvm flutter pub get
fvm dart run build_runner build
fvm flutter run
```

### Firebase

Trip Buddy needs your own Firebase project (see Day 75): Firebase AI Logic, App Check, and the `embedTexts` Cloud Function in `functions/` (Blaze plan).

```bash
flutterfire configure
cd functions && npm install && cd ..
firebase deploy --only functions
```

Without it, the app shows how to set it up.

### Google Maps (Day 81)

Put your own restricted API keys in place of `YOUR_ANDROID_MAPS_KEY` (`android/app/src/main/AndroidManifest.xml`) and `YOUR_IOS_MAPS_KEY` (`ios/Runner/AppDelegate.swift`).

### Tests

```bash
fvm flutter test
```

The tests tagged `screenshots` render the blog's images and are skipped by default (see `dart_test.yaml`).
