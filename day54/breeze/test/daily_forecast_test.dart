import 'package:breeze/models/daily_forecast.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/models/weather_kind.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_weather_repository.dart';

void main() {
  late Weather weather;
  setUp(() async {
    weather = await fixtureRepository().getWeather(lat: 0, lon: 0);
  });

  test('localTime shifts UTC to the time at the place', () {
    // Yangon is UTC+6:30.
    expect(
      weather.localTime(DateTime.utc(2026, 10, 28, 20)),
      DateTime.utc(2026, 10, 29, 2, 30),
    );
  });

  test('days are grouped by the date at the place, not in UTC', () {
    final days = weather.daily;
    // 40 steps from 28 Oct 12:30 to 2 Nov 09:30 Yangon time: 6 dates.
    expect(days.map((d) => d.date.day), [28, 29, 30, 31, 1, 2]);
    // 28 Oct starts at 12:30 local: steps at 12:30, 15:30, 18:30, 21:30.
    // The UTC step at 18:00 is already 29 Oct 00:30 in Yangon.
    final stepsOn28 = weather.hourly
        .where((s) => weather.localTime(s.time).day == 28)
        .length;
    expect(stepsOn28, 4);
  });

  test('min and max come from the day\'s steps', () {
    final first = weather.daily.first;
    final temps = weather.hourly
        .where((s) => weather.localTime(s.time).day == 28)
        .map((s) => s.temperature);
    expect(first.min, temps.reduce((a, b) => a < b ? a : b));
    expect(first.max, temps.reduce((a, b) => a > b ? a : b));
  });

  test('the condition of a day is the one closest to noon', () {
    final day29 = weather.daily[1];
    final noonStep = weather.hourly.firstWhere((s) {
      final local = weather.localTime(s.time);
      return local.day == 29 && local.hour == 12;
    });
    expect(day29.condition, noonStep.condition);
  });

  test('today is the day of the current weather at the place', () {
    expect(weather.today?.date, DateTime.utc(2026, 10, 28));

    // Late at night the forecast may only have tomorrow and later.
    final lateNight = weather.copyWith(
      current: weather.current.copyWith(time: DateTime.utc(2026, 10, 27, 17)),
    ); // 23:30 on 27 Oct in Yangon
    expect(lateNight.today, isNull);
  });

  group('WeatherKind', () {
    test('from OpenWeatherMap condition codes', () {
      expect(WeatherKind.fromCode(211), WeatherKind.thunderstorm);
      expect(WeatherKind.fromCode(301), WeatherKind.drizzle);
      expect(WeatherKind.fromCode(500), WeatherKind.rain);
      expect(WeatherKind.fromCode(600), WeatherKind.snow);
      expect(WeatherKind.fromCode(741), WeatherKind.mist);
      expect(WeatherKind.fromCode(800), WeatherKind.clear);
      expect(WeatherKind.fromCode(804), WeatherKind.clouds);
    });

    test('a clear night shows a moon and a darker sky', () {
      const night = Condition(
        code: 800,
        main: 'Clear',
        description: 'clear sky',
        icon: '01n',
      );
      const day = Condition(
        code: 800,
        main: 'Clear',
        description: 'clear sky',
        icon: '01d',
      );
      expect(night.iconData, Icons.nightlight);
      expect(day.iconData, Icons.wb_sunny);
      expect(
        night.backgroundColors.first.computeLuminance(),
        lessThan(day.backgroundColors.first.computeLuminance()),
      );
    });
  });
}
