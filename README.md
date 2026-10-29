# 100 Days of Flutter — sample code

The code for the **100 Days of Flutter** series on [arkar.dev](https://arkar.dev/) and [YouTube](https://www.youtube.com/@arkarmintun).

Every day that has code has its own folder, with the app **as it is at the end of that day**, so you can open any day and run it.

| Days | App | What it is |
|---|---|---|
| 24–48 | **Pixly** | A photo gallery on the Pexels API: layouts, navigation, Provider → Riverpod 3, Dio, Freezed, caching, retries, offline |
| 49–54 | **Breeze** | A live weather app on OpenWeatherMap: location, AsyncNotifier, glassmorphism UI, offline persistence |
| 55–66 | **Spendbook** | A Clean Architecture expense tracker: fpdart, Drift, Riverpod DI, charts, a currency API, ML Kit receipt scanning, performance |
| 67–69 | **Motion Lab** | Animations: implicit animations, Hero and page transitions, Rive |

## Run a day

The series uses Flutter **3.47.5** (Dart 3.13), managed with [FVM](https://fvm.app/).

```bash
cd day54/breeze
fvm use 3.47.5          # or use your own Flutter 3.47.x
fvm flutter pub get
fvm dart run build_runner build   # only if pubspec.yaml has build_runner
fvm flutter run
```

### API keys

Pixly and Breeze need a free API key in a `.env` file (never committed):

```bash
cp .env.example .env
# then put your key in .env
```

- Pixly: `PEXELS_API_KEY` from [pexels.com/api](https://www.pexels.com/api/)
- Breeze: `OPENWEATHER_API_KEY` from [openweathermap.org](https://openweathermap.org/api) (a new key can take up to 2 hours to start working)

### Tests

```bash
fvm flutter test
```

The tests tagged `screenshots` render the images used in the blog posts. They're skipped by default (fonts render a little differently on every machine).

## License

MIT — use it to learn, copy what helps.
