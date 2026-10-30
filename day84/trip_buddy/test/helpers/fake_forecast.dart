import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/forecast.dart';

import 'fake_places.dart';

/// Prepared days instead of Open-Meteo, for tests (Day 84).
class FakeForecastService implements ForecastService {
  FakeForecastService([List<DayForecast>? days]) : days = days ?? singaporeDays;

  final List<DayForecast> days;

  /// Thrown instead of answering. Not final: a test can fix the "network".
  Failure? error;
  final calls = <({double latitude, double longitude})>[];

  @override
  Future<List<DayForecast>> daily({
    required double latitude,
    required double longitude,
    required DateTime from,
    required DateTime to,
  }) async {
    calls.add((latitude: latitude, longitude: longitude));
    if (error case final error?) throw error;
    return [
      for (final day in days)
        if (!day.date.isBefore(from) && !day.date.isAfter(to)) day,
    ];
  }

  /// From a real Open-Meteo answer for Singapore, fetched 30 Oct 2026.
  static final singaporeDays = [
    DayForecast(
      date: DateTime(2026, 10, 30),
      weatherCode: 53,
      maxC: 31.8,
      minC: 23.8,
      rainChance: 90,
    ),
    DayForecast(
      date: DateTime(2026, 10, 31),
      weatherCode: 53,
      maxC: 31.9,
      minC: 25.2,
      rainChance: 96,
    ),
    DayForecast(
      date: DateTime(2026, 11, 1),
      weatherCode: 81,
      maxC: 30.1,
      minC: 23.9,
      rainChance: 96,
    ),
  ];
}

/// A GetForecast over fakes: "Singapore" is found, its days are above.
GetForecast fakeGetForecast([ForecastService? service]) => GetForecast(
  FakeGeocoder(),
  service ?? FakeForecastService(),
  now: () => DateTime(2026, 10, 29, 10),
);
