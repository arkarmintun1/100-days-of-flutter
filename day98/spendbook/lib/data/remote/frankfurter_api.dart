import 'package:dio/dio.dart';

/// One rate as Frankfurter's v2 API returns it:
/// {"date":"2026-10-28","base":"SGD","quote":"USD","rate":0.78047}
class RateDto {
  const RateDto({
    required this.date,
    required this.base,
    required this.quote,
    required this.rate,
  });

  /// Throws a [FormatException] if the JSON isn't shaped like a rate.
  factory RateDto.fromJson(Map<String, dynamic> json) => switch (json) {
    {
      'date': final String date,
      'base': final String base,
      'quote': final String quote,
      // JSON numbers can arrive as int (e.g. 1): num covers both.
      'rate': final num rate,
    } =>
      RateDto(
        date: DateTime.parse(date), // a FormatException if it isn't a date
        base: base,
        quote: quote,
        rate: rate.toDouble(),
      ),
    _ => throw FormatException('Not a Frankfurter rate', json),
  };

  final DateTime date;
  final String base;
  final String quote;
  final double rate;
}

/// Frankfurter (frankfurter.dev): free exchange rates from central banks,
/// no API key needed.
class FrankfurterApi {
  FrankfurterApi(this._dio);

  /// The production setup. Tests pass a Dio with a fake adapter instead.
  factory FrankfurterApi.create() => FrankfurterApi(
    Dio(
      BaseOptions(
        baseUrl: 'https://api.frankfurter.dev/v2',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  final Dio _dio;

  /// GET /rate/{from}/{to}: the latest rate for one pair.
  Future<RateDto> latestRate(String from, String to) async {
    final response = await _dio.get<Map<String, dynamic>>('/rate/$from/$to');
    final data = response.data;
    if (data == null) throw const FormatException('Empty response');
    return RateDto.fromJson(data);
  }
}
