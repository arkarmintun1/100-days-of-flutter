/// 1 [from] = [rate] [to], as published on [date].
class ExchangeRate {
  const ExchangeRate({
    required this.from,
    required this.to,
    required this.rate,
    required this.date,
  });

  final String from;
  final String to;
  final double rate;
  final DateTime date;
}
