# Day 50: Location with Geolocator

The **Breeze** app at the end of Day 50 of [100 Days of Flutter](../../README.md).

Article: https://arkar.dev/day-50-location-geolocator/

```bash
fvm flutter pub get
fvm dart run build_runner build
cp .env.example .env   # then add your API key
fvm flutter run
```

Location permissions are already added to `AndroidManifest.xml` and `Info.plist`. For the iOS permission setup of `geolocator`, see the Day 50 article.
