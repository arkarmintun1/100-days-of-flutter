import 'package:dio/dio.dart';

/// What kind of thing went wrong, so the UI can pick the right message.
enum ErrorKind {
  /// No internet, or the connection timed out.
  network,

  /// HTTP 401: the API key is missing, wrong or not active yet.
  unauthorized,

  /// HTTP 404: OpenWeatherMap has no data for the request.
  notFound,

  /// HTTP 429: more calls than the plan allows.
  rateLimited,

  /// HTTP 5xx: a problem on OpenWeatherMap's side.
  server,

  /// The device's location services (GPS) are turned off.
  locationOff,

  /// The user said no to the location permission (we can ask again).
  locationDenied,

  /// Denied for good: only the app's settings can change it now.
  locationDeniedForever,

  /// Location is allowed, but the device couldn't find a position.
  locationUnavailable,

  /// Anything else, e.g. JSON with an unexpected shape.
  unknown;

  /// Whether getting the device's position failed (Day 50).
  bool get isLocationProblem =>
      this == locationOff ||
      this == locationDenied ||
      this == locationDeniedForever ||
      this == locationUnavailable;

  /// Whether trying again in a few seconds may work (Day 47).
  bool get mayFixItself => this == network || this == server;
}

/// The one exception type the app's UI has to understand.
class AppException implements Exception {
  const AppException(this.message, {this.kind = ErrorKind.unknown});

  /// Turns a Dio error into a message a user can understand.
  factory AppException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    return switch (e.type) {
      .connectionTimeout ||
      .sendTimeout ||
      .receiveTimeout => const AppException(
        'The connection timed out. Please try again.',
        kind: .network,
      ),
      .connectionError => const AppException(
        'Unable to connect. Check your internet connection.',
        kind: .network,
      ),
      .badResponse => switch (status) {
        401 => const AppException(
          'Invalid API key. Check OPENWEATHER_API_KEY in your .env file.',
          kind: .unauthorized,
        ),
        404 => const AppException(
          'No weather data for this place.',
          kind: .notFound,
        ),
        429 => const AppException(
          'Too many requests. Please try again later.',
          kind: .rateLimited,
        ),
        final int code when code >= 500 => AppException(
          'OpenWeatherMap is having problems ($code). Please try again.',
          kind: .server,
        ),
        _ => AppException('Request failed ($status).'),
      },
      _ => const AppException('Something went wrong. Please try again.'),
    };
  }

  /// Any error from a provider, as something the UI can show.
  factory AppException.from(Object error) => switch (error) {
    final AppException e => e,
    _ => const AppException('Something went wrong. Please try again.'),
  };

  final String message;
  final ErrorKind kind;

  @override
  String toString() => 'AppException($kind): $message';
}
