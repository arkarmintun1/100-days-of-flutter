import 'package:dio/dio.dart';
import 'package:breeze/core/app_exception.dart';
import 'package:breeze/core/env.dart';
import 'package:breeze/data/models/owm_models.dart';

/// The two OpenWeatherMap endpoints Breeze needs (both in the free plan).
class OpenWeatherApi {
  OpenWeatherApi({Dio? dio, String? apiKey}) : _dio = dio ?? Dio(_options) {
    // No LogInterceptor here: it prints request URLs, and OpenWeatherMap's
    // URLs contain the API key.
    _dio.interceptors.add(_QueryInterceptor(apiKey ?? Env.openWeatherApiKey));
  }

  static const baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const geocodingUrl = 'https://api.openweathermap.org/geo/1.0/direct';

  static final _options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  final Dio _dio;

  Future<OwmCurrent> currentWeather(double lat, double lon) =>
      _get('/weather', lat, lon, OwmCurrent.fromJson);

  Future<OwmForecast> forecast(double lat, double lon) =>
      _get('/forecast', lat, lon, OwmForecast.fromJson);

  /// Up to 5 places called [query] (Geocoding API, Day 51).
  Future<List<OwmGeoPlace>> searchCities(String query) async {
    try {
      // A full URL: the Geocoding API isn't under baseUrl (/data/2.5).
      final response = await _dio.get<List<dynamic>>(
        geocodingUrl,
        queryParameters: {'q': query, 'limit': 5},
      );
      return [
        for (final item in response.data!)
          OwmGeoPlace.fromJson(item as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } on TypeError {
      throw const AppException('Unexpected response from OpenWeatherMap.');
    }
  }

  /// GETs [path] for a position and parses the JSON with [fromJson].
  /// Every failure becomes an [AppException].
  Future<T> _get<T>(
    String path,
    double lat,
    double lon,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {'lat': lat, 'lon': lon},
      );
      return fromJson(response.data!);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } on TypeError {
      // The JSON didn't have the shape our models expect.
      throw const AppException('Unexpected response from OpenWeatherMap.');
    }
  }
}

/// Adds the API key to every request, and metric units to the weather
/// requests, so the methods above only pass what changes.
class _QueryInterceptor extends Interceptor {
  _QueryInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['appid'] = apiKey;
    // Only the weather endpoints (/data/2.5/...) have units.
    if (options.uri.path.startsWith('/data/')) {
      options.queryParameters['units'] = 'metric';
    }
    handler.next(options);
  }
}
