# Day 69: Rive - Interactive Animations with State Machines

The **Motion Lab** app at the end of Day 69 of [100 Days of Flutter](../../README.md).

Article: https://arkar.dev/day-69-rive-interactive-animation/

```bash
fvm flutter pub get
fvm flutter run
```

### Rive in tests

`flutter test` needs Rive's native library on your machine, once:

```bash
fvm dart run rive_native:setup --verbose --clean --platform macos   # or linux / windows
```

The `.riv` files come from the official Rive Flutter runtime (MIT License): see `assets/CREDITS.md`.
