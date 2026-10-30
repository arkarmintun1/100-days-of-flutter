import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/failures.dart';
import '../../domain/forecast.dart';
import '../providers/dependencies.dart';

/// The weather at one place for a few days (Day 84).
///
/// The model only says which place and days. The numbers come from
/// GetForecast: the very ones get_forecast gave the model, not the
/// model's copy of them.
final forecastCard = CatalogItem(
  name: 'ForecastCard',
  dataSchema: S.object(
    description:
        'The daily weather forecast for one place. Use the same place and '
        'days as your get_forecast call.',
    properties: {
      'place': S.string(description: 'As in get_forecast, e.g. "Singapore".'),
      'from': S.string(description: 'First day, YYYY-MM-DD.'),
      'to': S.string(description: 'Last day, YYYY-MM-DD.'),
    },
    required: ['place', 'from', 'to'],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as JsonMap;
    final place = switch (data['place']) {
      final String p when p.trim().isNotEmpty => p.trim(),
      _ => null,
    };
    final from = _day(data['from']);
    final to = _day(data['to']);
    if (place == null || from == null || to == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Couldn't show this forecast."),
        ),
      );
    }
    return ForecastView(place: place, from: from, to: to);
  },
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "ForecastCard",
          "place": "Singapore",
          "from": "2026-10-31",
          "to": "2026-11-01"
        }
      ]
    ''',
  ],
);

/// "2026-10-31" → that day; null for anything else (also "2026-02-30").
DateTime? _day(Object? text) {
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})$',
  ).firstMatch(text is String ? text : '');
  if (match == null) return null;
  final [y, m, d] = [for (var i = 1; i <= 3; i++) int.parse(match[i]!)];
  final day = DateTime(y, m, d);
  return day.month == m && day.day == d ? day : null;
}

class ForecastView extends ConsumerWidget {
  const ForecastView({
    super.key,
    required this.place,
    required this.from,
    required this.to,
  });

  final String place;
  final DateTime from;
  final DateTime to;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final forecast = ref.watch(forecastProvider(place, from, to));
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weather in $place', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            switch (forecast) {
              AsyncData(:final value) when value.isEmpty => const Text(
                'No forecast for those days.',
              ),
              AsyncData(:final value) => Column(
                children: [for (final day in value) _DayRow(day)],
              ),
              // While "Try again" loads, Riverpod keeps the old error: show
              // the progress bar then.
              AsyncError(:final error) when !forecast.isLoading => Row(
                children: [
                  Expanded(
                    child: Text(
                      error is Failure
                          ? error.message
                          : "Couldn't get the forecast.",
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                  TextButton(
                    // Riverpod (retry is off, Day 47): ask again.
                    onPressed: () =>
                        ref.invalidate(forecastProvider(place, from, to)),
                    child: const Text('Try again'),
                  ),
                ],
              ),
              _ => const LinearProgressIndicator(),
            },
            // Open-Meteo's data licence (CC BY 4.0): credit with a link,
            // a link to the licence, and what was changed.
            Text('Temperatures rounded.', style: theme.textTheme.bodySmall),
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _open(context, Uri.https('open-meteo.com')),
                  child: const Text('Weather data by Open-Meteo.com'),
                ),
                TextButton(
                  onPressed: () => _open(
                    context,
                    Uri.https('creativecommons.org', '/licenses/by/4.0/'),
                  ),
                  child: const Text('CC BY 4.0'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// launchUrl returns false or throws when nothing can open the link
/// (url_launcher's documentation).
Future<void> _open(BuildContext context, Uri url) async {
  final messenger = ScaffoldMessenger.of(context);
  bool opened;
  try {
    opened = await launchUrl(url);
  } on PlatformException {
    opened = false;
  }
  if (!opened) {
    messenger.showSnackBar(
      SnackBar(content: Text("Couldn't open ${url.host}.")),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow(this.day);

  final DayForecast day;

  @override
  Widget build(BuildContext context) {
    final date = day.date;
    final rain = day.rainChance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              '${_weekdays[date.weekday - 1]} ${date.day} '
              '${_months[date.month - 1]}',
            ),
          ),
          Icon(weatherIcon(day.weatherCode)),
          const SizedBox(width: 8),
          Expanded(child: Text(weatherText(day.weatherCode))),
          Text('${day.maxC.round()}° / ${day.minC.round()}°'),
          if (rain != null) ...[
            const SizedBox(width: 8),
            const Icon(Icons.water_drop_outlined, size: 16),
            Text('$rain%'),
          ],
        ],
      ),
    );
  }
}

/// An icon for a WMO weather code (see weatherText).
IconData weatherIcon(int code) => switch (code) {
  0 || 1 => Icons.wb_sunny_outlined,
  2 => Icons.wb_cloudy_outlined,
  3 => Icons.cloud_outlined,
  45 || 48 => Icons.foggy,
  >= 51 && <= 57 => Icons.grain,
  >= 61 && <= 67 || >= 80 && <= 82 => Icons.umbrella_outlined,
  >= 71 && <= 77 || 85 || 86 => Icons.ac_unit,
  >= 95 && <= 99 => Icons.thunderstorm_outlined,
  _ => Icons.help_outline,
};

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
