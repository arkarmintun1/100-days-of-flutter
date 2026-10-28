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

/// Adds the API key and metric units to every request, so the methods
/// above only pass what changes: the position.
class _QueryInterceptor extends Interceptor {
  _QueryInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({'appid': apiKey, 'units': 'metric'});
    handler.next(options);
  }
}
