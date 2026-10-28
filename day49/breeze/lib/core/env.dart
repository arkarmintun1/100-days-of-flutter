import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to values from the `.env` file.
class Env {
  static String get openWeatherApiKey => dotenv.get('OPENWEATHER_API_KEY');
}
