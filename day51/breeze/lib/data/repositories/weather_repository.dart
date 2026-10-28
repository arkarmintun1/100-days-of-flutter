import 'dart:async';

import 'package:breeze/core/app_exception.dart';
import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/models/owm_models.dart';
import 'package:breeze/models/place.dart';
import 'package:breeze/models/weather.dart';

/// Where the app gets its weather from. The rest of the app only knows
/// this interface, so tests (and later a cache) can stand in for the API.
abstract interface class WeatherRepository {
  /// The weather now and the next 5 days at a position.
  /// Throws an AppException when it can't.
  Future<Weather> getWeather({required double lat, required double lon});

  /// Places matching a city name, e.g. "Mandalay" (Day 51).
  Future<List<Place>> searchPlaces(String query);
}

/// The real thing: two OpenWeatherMap requests, turned into a [Weather].
class OpenWeatherRepository implements WeatherRepository {
  OpenWeatherRepository(this._api, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final OpenWeatherApi _api;
  final DateTime Function() _now;

  @override
  Future<Weather> getWeather({required double lat, required double lon}) async {
    final OwmCurrent current;
    final OwmForecast forecast;
    try {
      // Both requests at the same time, not one after the other.
      (current, forecast) = await (
        _api.currentWeather(lat, lon),
        _api.forecast(lat, lon),
      ).wait;
    } on ParallelWaitError<
      (OwmCurrent?, OwmForecast?),
      (AsyncError?, AsyncError?)
    > catch (e) {
      // .wait reports failures together; rethrow the first one, so callers
      // get the AppException and not a ParallelWaitError.
      final error = e.errors.$1 ?? e.errors.$2!;
      Error.throwWithStackTrace(error.error, error.stackTrace);
    }
    return _toWeather(current, forecast);
  }

  @override
  Future<List<Place>> searchPlaces(String query) async {
    final results = await _api.searchCities(query);
    return [
      for (final result in results)
        Place(
          name: result.name,
          country: result.country,
          state: result.state,
          lat: result.lat,
          lon: result.lon,
        ),
    ];
  }

  Weather _toWeather(OwmCurrent current, OwmForecast forecast) => Weather(
    place: current.name.isNotEmpty ? current.name : forecast.city.name,
    country: current.sys.country ?? forecast.city.country,
    utcOffsetSeconds: current.timezone,
    current: CurrentWeather(
      time: _utc(current.dt),
      temperature: current.main.temp,
      feelsLike: current.main.feelsLike,
      tempMin: current.main.tempMin,
      tempMax: current.main.tempMax,
      humidity: current.main.humidity,
      pressure: current.main.pressure,
      windSpeed: current.wind.speed,
      condition: _condition(current.weather),
      sunrise: current.sys.sunrise == null ? null : _utc(current.sys.sunrise!),
      sunset: current.sys.sunset == null ? null : _utc(current.sys.sunset!),
    ),
    hourly: [
      for (final item in forecast.list)
        HourlyForecast(
          time: _utc(item.dt),
          temperature: item.main.temp,
          condition: _condition(item.weather),
          precipitationChance: item.pop,
        ),
    ],
    fetchedAt: _now().toUtc(),
  );

  /// OpenWeatherMap times are seconds since 1970 (UTC).
  static DateTime _utc(int seconds) =>
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

  /// The first condition is the main one (OpenWeatherMap's docs).
  static Condition _condition(List<OwmCondition> conditions) {
    if (conditions.isEmpty) {
      // .first would throw a StateError: keep the promise of AppException.
      throw const AppException('Unexpected response from OpenWeatherMap.');
    }
    final first = conditions.first;
    return Condition(
      code: first.id,
      main: first.main,
      description: first.description,
      icon: first.icon,
    );
  }
}
