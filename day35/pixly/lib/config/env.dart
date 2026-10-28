import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to values from the `.env` file.
class Env {
  static String get pexelsApiKey => dotenv.get('PEXELS_API_KEY');
}
