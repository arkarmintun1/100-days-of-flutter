import 'package:breeze/models/weather.dart';

/// One day of the 5-day forecast, made from its 3-hour steps.
class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.min,
    required this.max,
    required this.condition,
    required this.precipitationChance,
  });

  /// The day at the place (a UTC DateTime at midnight, used as a date).
  final DateTime date;

  /// The lowest and highest of the day's 3-hour samples (not a measured
  /// daily minimum and maximum).
  final double min;
  final double max;

  /// The condition around midday, the most typical for the day.
  final Condition condition;

  /// The highest chance of any 3-hour step of the day, 0 to 1 (not the
  /// chance of rain at any time that day).
  final double precipitationChance;
}

extension WeatherTime on Weather {
  /// [utc] as the wall-clock time at the place. The result is still a UTC
  /// DateTime: only its fields (hour, day...) are meant to be read.
  DateTime localTime(DateTime utc) =>
      utc.add(Duration(seconds: utcOffsetSeconds));

  /// The forecast steps grouped by day **at the place**, not on the phone.
  List<DailyForecast> get daily {
    final days = <DateTime, List<HourlyForecast>>{};
    for (final step in hourly) {
      final local = localTime(step.time);
      final day = DateTime.utc(local.year, local.month, local.day);
      (days[day] ??= []).add(step);
    }
    return [
      for (final MapEntry(key: date, value: steps) in days.entries)
        DailyForecast(
          date: date,
          min: steps.map((s) => s.temperature).reduce((a, b) => a < b ? a : b),
          max: steps.map((s) => s.temperature).reduce((a, b) => a > b ? a : b),
          condition: _middayStep(steps).condition,
          precipitationChance: steps
              .map((s) => s.precipitationChance)
              .reduce((a, b) => a > b ? a : b),
        ),
    ];
  }

  /// Today at the place, if the forecast still has steps for it (late at
  /// night the first forecast day can already be tomorrow).
  DailyForecast? get today {
    final now = localTime(current.time);
    return daily
        .where(
          (day) =>
              day.date.year == now.year &&
              day.date.month == now.month &&
              day.date.day == now.day,
        )
        .firstOrNull;
  }

  HourlyForecast _middayStep(List<HourlyForecast> steps) {
    int distanceToNoon(HourlyForecast step) {
      final local = localTime(step.time);
      return (local.hour * 60 + local.minute - 12 * 60).abs();
    }

    return steps.reduce(
      (a, b) => distanceToNoon(b) < distanceToNoon(a) ? b : a,
    );
  }
}
