import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../domain/failures.dart';
import '../../domain/forecast.dart';

/// Daily forecasts from Open-Meteo (Day 84): free for non-commercial use,
/// no API key. The data is CC BY 4.0: credit and link it, link the
/// licence, and say what was changed (the ForecastCard does).
class OpenMeteoForecast implements ForecastService {
  OpenMeteoForecast([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<DayForecast>> daily({
    required double latitude,
    required double longitude,
    required DateTime from,
    required DateTime to,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max',
      // The dates (and "today") in the place's own time zone.
      'timezone': 'auto',
      'start_date': _date(from),
      'end_date': _date(to),
    });

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 15));
    } on Exception catch (e) {
      // No connection, a timeout, a failed TLS handshake...
      log('Open-Meteo request failed', error: e);
      throw const NetworkFailure("Couldn't reach the weather service.");
    }

    final Object? json;
    try {
      json = jsonDecode(response.body);
    } on FormatException {
      throw NetworkFailure(
        'The weather service failed (${response.statusCode}).',
      );
    }
    // A bad request, e.g. a day too far ahead:
    // {"error":true,"reason":"Parameter 'start_date' is out of allowed
    // range from 2026-07-29 to 2026-11-14"}
    if (response.statusCode == 400 && json is Map<String, Object?>) {
      throw ValidationFailure(switch (json['reason']) {
        final String reason => reason,
        _ => 'The weather service has no forecast for those days.',
      });
    }
    if (response.statusCode != 200) {
      throw NetworkFailure(
        'The weather service failed (${response.statusCode}).',
      );
    }
    return _days(json);
  }

  /// {"daily": {"time": [...], "weather_code": [...], ...}}: one list per
  /// value, the same length. A day with a value missing is left out.
  static List<DayForecast> _days(Object? json) {
    if (json case {
      'daily': {
        'time': final List<Object?> time,
        'weather_code': final List<Object?> code,
        'temperature_2m_max': final List<Object?> max,
        'temperature_2m_min': final List<Object?> min,
        'precipitation_probability_max': final List<Object?> rain,
      },
    } when [code, max, min, rain].every((l) => l.length == time.length)) {
      return [
        for (var i = 0; i < time.length; i++)
          if ((time[i], code[i], max[i], min[i]) case (
            final String day,
            final num weatherCode,
            final num maxC,
            final num minC,
          ) when DateTime.tryParse(day) != null)
            DayForecast(
              date: DateTime.parse(day),
              weatherCode: weatherCode.toInt(),
              maxC: maxC.toDouble(),
              minC: minC.toDouble(),
              rainChance: switch (rain[i]) {
                final num chance => chance.round(),
                _ => null,
              },
            ),
      ];
    }
    throw const NetworkFailure("The weather service's answer was unusable.");
  }

  static String _date(DateTime d) =>
      '${d.year}-${_two(d.month)}-${_two(d.day)}';

  static String _two(int n) => n.toString().padLeft(2, '0');
}
