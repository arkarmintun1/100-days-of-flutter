import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trip_buddy/data/weather/open_meteo_forecast.dart';
import 'package:trip_buddy/domain/failures.dart';

void main() {
  // A real answer from api.open-meteo.com, 30 Oct 2026 (forecast_days=3).
  const singapore =
      '{"latitude":1.3005272,"longitude":103.862564,'
      '"generationtime_ms":0.20074844360351562,"utc_offset_seconds":28800,'
      '"timezone":"Asia/Singapore","timezone_abbreviation":"GMT+8",'
      '"elevation":27.0,"daily_units":{"time":"iso8601",'
      '"weather_code":"wmo code","temperature_2m_max":"°C",'
      '"temperature_2m_min":"°C","precipitation_probability_max":"%"},'
      '"daily":{"time":["2026-10-30","2026-10-31","2026-11-01"],'
      '"weather_code":[53,53,81],"temperature_2m_max":[31.8,31.9,30.1],'
      '"temperature_2m_min":[23.8,25.2,23.9],'
      '"precipitation_probability_max":[90,96,96]}}';

  late List<http.Request> requests;

  OpenMeteoForecast service(http.Response Function() answer) {
    requests = [];
    return OpenMeteoForecast(
      MockClient((request) async {
        requests.add(request);
        return answer();
      }),
    );
  }

  Future<Object?> daily(OpenMeteoForecast s) => s.daily(
    latitude: 1.2897,
    longitude: 103.8501,
    from: DateTime(2026, 10, 30),
    to: DateTime(2026, 11, 1),
  );

  http.Response json(String body, int status) => http.Response.bytes(
    utf8.encode(body),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );

  test('asks for the daily values, in the place\'s time zone', () async {
    final days = await service(() => json(singapore, 200)).daily(
      latitude: 1.2897,
      longitude: 103.8501,
      from: DateTime(2026, 10, 30),
      to: DateTime(2026, 11, 1),
    );

    final url = requests.single.url;
    expect(url.host, 'api.open-meteo.com');
    expect(url.path, '/v1/forecast');
    expect(url.queryParameters, {
      'latitude': '1.2897',
      'longitude': '103.8501',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max',
      'timezone': 'auto',
      'start_date': '2026-10-30',
      'end_date': '2026-11-01',
    });

    expect(days, hasLength(3));
    final last = days.last;
    expect(last.date, DateTime(2026, 11, 1));
    expect(last.weatherCode, 81);
    expect(last.maxC, 30.1);
    expect(last.minC, 23.9);
    expect(last.rainChance, 96);
  });

  test(
    'a day with a value missing is left out; no rain chance is null',
    () async {
      const body =
          '{"daily":{"time":["2026-10-30","2026-10-31"],'
          '"weather_code":[53,null],"temperature_2m_max":[31.8,31.9],'
          '"temperature_2m_min":[23.8,25.2],'
          '"precipitation_probability_max":[null,96]}}';
      final days = await service(() => json(body, 200)).daily(
        latitude: 1,
        longitude: 1,
        from: DateTime(2026, 10, 30),
        to: DateTime(2026, 10, 31),
      );

      expect(days.single.date, DateTime(2026, 10, 30));
      expect(days.single.rainChance, isNull);
    },
  );

  test("days it has no forecast for: Open-Meteo's reason", () async {
    // A real answer for 13 Dec, asked on 30 Oct 2026.
    const body =
        '{"error":true,"reason":"Parameter \'start_date\' is out of allowed '
        'range from 2026-07-29 to 2026-11-14"}';

    await expectLater(
      daily(service(() => json(body, 400))),
      throwsA(
        isA<ValidationFailure>().having(
          (f) => f.message,
          'message',
          "Parameter 'start_date' is out of allowed range from 2026-07-29 "
              'to 2026-11-14',
        ),
      ),
    );
  });

  test('a server error, an odd answer, or no connection', () async {
    await expectLater(
      daily(service(() => http.Response('Bad gateway', 502))),
      throwsA(isA<NetworkFailure>()),
    );
    await expectLater(
      daily(service(() => json('{"daily":{}}', 200))),
      throwsA(isA<NetworkFailure>()),
    );
    await expectLater(
      daily(service(() => throw http.ClientException('Failed host lookup'))),
      throwsA(isA<NetworkFailure>()),
    );
  });
}
