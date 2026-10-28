import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/env.dart';

void main() {
  test('Env.pexelsApiKey reads PEXELS_API_KEY', () {
    dotenv.loadFromString(envString: 'PEXELS_API_KEY=abc123');
    expect(Env.pexelsApiKey, 'abc123');
  });

  test('a missing key throws instead of sending an empty header', () {
    dotenv.loadFromString(envString: 'OTHER=1');
    expect(() => Env.pexelsApiKey, throwsA(isA<AssertionError>()));
  });
}
