import 'failures.dart';
import 'trip_place.dart';

/// One day of weather at a place (Day 84).
class DayForecast {
  const DayForecast({
    required this.date,
    required this.weatherCode,
    required this.maxC,
    required this.minC,
    this.rainChance,
  });

  /// The day, in the place's own time zone (only the date is used).
  final DateTime date;

  /// A WMO weather code: 0 is a clear sky, 61 slight rain, ...
  final int weatherCode;

  /// The day's highest and lowest temperature, in °C.
  final double maxC;
  final double minC;

  /// The highest chance of rain during the day, in %; null if the weather
  /// model doesn't have one for that day.
  final int? rainChance;
}

/// Where daily forecasts come from (Open-Meteo in the app).
abstract interface class ForecastService {
  /// One [DayForecast] per day from [from] to [to], dates in the place's
  /// time zone. Throws a [ValidationFailure] for days the service has no
  /// forecast for, a [NetworkFailure] if it can't be reached.
  Future<List<DayForecast>> daily({
    required double latitude,
    required double longitude,
    required DateTime from,
    required DateTime to,
  });
}

/// The weather for a place, by name (Day 84): the chat's `get_forecast`
/// tool and the ForecastCard both use it.
///
/// Answers are kept for [keepFor], so the card shows the very numbers the
/// model was given, without a second request.
class GetForecast {
  GetForecast(
    this._geocoder,
    this._service, {
    required DateTime Function() now,
    this.keepFor = const Duration(minutes: 30),
  }) : _now = now;

  final Geocoder _geocoder;
  final ForecastService _service;
  final DateTime Function() _now;
  final Duration keepFor;
  final _kept = <String, ({DateTime at, List<DayForecast> days})>{};

  /// The most days one forecast may cover: Open-Meteo's own limit.
  static const maxDays = 16;

  Future<List<DayForecast>> call(
    String place,
    DateTime from,
    DateTime to,
  ) async {
    final name = place.trim();
    if (name.isEmpty) throw const ValidationFailure('Which place?');
    // Whole days apart, whatever the daylight saving changes on the way.
    final span = DateTime.utc(
      to.year,
      to.month,
      to.day,
    ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
    if (span < 0) {
      throw const ValidationFailure('The last day is before the first.');
    }
    if (span >= maxDays) {
      throw const ValidationFailure('A forecast covers at most $maxDays days.');
    }

    final key = '${name.toLowerCase()}|${_day(from)}|${_day(to)}';
    final now = _now();
    if (_kept[key] case (
      :final at,
      :final days,
    ) when now.difference(at) < keepFor) {
      return days;
    }

    final where = await _geocoder.locate(name);
    if (where == null) {
      throw ValidationFailure('Couldn\'t find "$name" on the map.');
    }
    final forecast = await _service.daily(
      latitude: where.latitude,
      longitude: where.longitude,
      from: from,
      to: to,
    );
    // Old answers go, so the map doesn't grow for as long as the app runs.
    _kept.removeWhere((_, kept) => now.difference(kept.at) >= keepFor);
    _kept[key] = (at: now, days: forecast);
    return forecast;
  }

  static String _day(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

/// "Slight rain" for a WMO weather code, as Open-Meteo's documentation
/// lists them.
String weatherText(int code) => switch (code) {
  0 => 'Clear sky',
  1 => 'Mainly clear',
  2 => 'Partly cloudy',
  3 => 'Overcast',
  45 => 'Fog',
  48 => 'Depositing rime fog',
  51 => 'Light drizzle',
  53 => 'Moderate drizzle',
  55 => 'Dense drizzle',
  56 => 'Light freezing drizzle',
  57 => 'Dense freezing drizzle',
  61 => 'Slight rain',
  63 => 'Moderate rain',
  65 => 'Heavy rain',
  66 => 'Light freezing rain',
  67 => 'Heavy freezing rain',
  71 => 'Slight snowfall',
  73 => 'Moderate snowfall',
  75 => 'Heavy snowfall',
  77 => 'Snow grains',
  80 => 'Slight rain showers',
  81 => 'Moderate rain showers',
  82 => 'Violent rain showers',
  85 => 'Slight snow showers',
  86 => 'Heavy snow showers',
  95 => 'Thunderstorm',
  96 => 'Thunderstorm with slight hail',
  97 => 'Heavy thunderstorm',
  99 => 'Thunderstorm with heavy hail',
  _ => 'Unknown weather',
};
