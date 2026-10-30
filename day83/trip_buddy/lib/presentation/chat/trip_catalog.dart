import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../../domain/time_zones.dart';
import '../providers/dependencies.dart';

/// The widgets Trip Buddy's chat may answer with (Day 83): GenUI's basic
/// layout and text widgets, plus Trip Buddy's own.
final tripCatalog = BasicCatalogItems.asCatalog()
    .copyWithout(
      // Answers to read, not forms: no inputs or buttons (nothing would
      // handle them), and no media (fewer tokens in the prompt).
      itemsToRemove: [
        BasicCatalogItems.audioPlayer,
        BasicCatalogItems.video,
        BasicCatalogItems.image,
        BasicCatalogItems.button,
        BasicCatalogItems.checkBox,
        BasicCatalogItems.dateTimeInput,
        BasicCatalogItems.choicePicker,
        BasicCatalogItems.slider,
        BasicCatalogItems.textField,
        BasicCatalogItems.modal,
        BasicCatalogItems.tabs,
      ],
    )
    .copyWith(newItems: [tripCountdown]);

/// "12 days 4 h" until a flight or check-in, in the place's time zone.
final tripCountdown = CatalogItem(
  name: 'TripCountdown',
  dataSchema: S.object(
    description:
        'A countdown to one moment of the trip, e.g. a departure or a '
        'check-in. Use the date and time from the sources or the itinerary.',
    properties: {
      'title': S.string(
        description: 'Short, e.g. "Flight SQ321 to Singapore".',
      ),
      'startsAt': S.string(
        description: 'Local time where it happens, as YYYY-MM-DDTHH:MM.',
      ),
      'timeZone': S.string(
        description: 'IANA name of that place, e.g. "Europe/London".',
      ),
    },
    required: ['title', 'startsAt', 'timeZone'],
  ),
  widgetBuilder: (itemContext) {
    final context = itemContext.buildContext;
    final data = itemContext.data as JsonMap;
    // The model fills these in: check them like any outside data.
    final title = switch (data['title']) {
      final String t when t.trim().isNotEmpty => t.trim(),
      _ => 'Your trip',
    };
    final startsAt = switch (data['startsAt']) {
      final String text => DateTime.tryParse(text),
      _ => null,
    };
    final zone = switch (data['timeZone']) {
      final String name => name,
      _ => '',
    };
    // "Now" from the app's clock, so tests (and screenshots) are stable.
    final now = ProviderScope.containerOf(context).read(clockProvider)();
    final left = startsAt == null ? null : timeUntil(startsAt, zone, now: now);
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flight_takeoff),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(countdownText(left), style: theme.textTheme.headlineMedium),
            if (startsAt != null && left != null)
              Text(
                '${_two(startsAt.day)}/${_two(startsAt.month)}/'
                '${startsAt.year} ${_two(startsAt.hour)}:'
                '${_two(startsAt.minute)} · $zone',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  },
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "TripCountdown",
          "title": "Flight SQ321 to Singapore",
          "startsAt": "2026-12-12T21:40",
          "timeZone": "Europe/London"
        }
      ]
    ''',
  ],
);

/// "43 days 5 h", "3 h 20 min", "Started": how long is left.
String countdownText(Duration? left) {
  if (left == null) return 'Unknown time';
  if (left.isNegative) return 'Started';
  final days = left.inDays;
  final hours = left.inHours % 24;
  if (days > 0) return '$days ${days == 1 ? 'day' : 'days'} $hours h';
  return '$hours h ${left.inMinutes % 60} min';
}

String _two(int n) => n.toString().padLeft(2, '0');
