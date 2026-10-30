import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/booking.dart';
import '../../domain/distance.dart';
import '../../domain/failures.dart';
import '../../domain/forecast.dart';
import '../../domain/nearby.dart';
import '../../domain/time_zones.dart';
import '../../domain/trip_place.dart';

/// The app functions Trip Buddy's model may ask for (Day 80). The model
/// never runs them: it asks, and this class checks the arguments and
/// runs them (Spendbook, Day 74).
class TripTools {
  TripTools({
    required Itinerary itinerary,
    required DateTime Function() now,
    required Future<String> Function() homeTimeZone,
    required FindNearby nearby,
    required GetForecast forecast,
  }) : _itinerary = itinerary,
       _now = now,
       _homeTimeZone = homeTimeZone,
       _nearby = nearby,
       _forecast = forecast {
    // The IANA time zone database, built into the app (no network).
    // Day 83: moved to domain/time_zones.dart, shared with the countdown.
    loadTimeZones();
  }

  final Itinerary _itinerary;
  final DateTime Function() _now;
  final Future<String> Function() _homeTimeZone;
  final FindNearby _nearby;
  final GetForecast _forecast;

  /// Most bookings one message can add (as Spendbook's expenses).
  static const maxAddsPerMessage = 5;
  var _addsThisMessage = 0;

  /// Called at the start of each user message.
  void newMessage() => _addsThisMessage = 0;

  final declarations = [
    FunctionDeclaration(
      'get_local_time',
      'Returns the current date and time in a time zone. Use it for '
          '"what time is it in ..." and before working out how long until '
          'something.',
      parameters: {
        'time_zone': Schema.string(
          description: 'An IANA time zone name, e.g. "Asia/Singapore".',
        ),
      },
    ),
    FunctionDeclaration(
      'add_booking',
      "Adds a booking to the trip's itinerary. Use it only when the user "
          'asks to add, save or remember a booking. One call per booking.',
      parameters: {
        'title': Schema.string(
          description: 'Short, e.g. "Flight SQ321 to Singapore".',
        ),
        'kind': Schema.enumString(
          enumValues: [for (final k in BookingKind.values) k.name],
        ),
        'date': Schema.string(description: 'YYYY-MM-DD.'),
        'time': Schema.string(
          description: "HH:MM, 24-hour. Ask the user if you don't know it.",
        ),
        'time_zone': Schema.string(
          description:
              'IANA name of the place where it happens, e.g. '
              '"Asia/Bangkok". Leave out for the time zone of the phone.',
        ),
      },
      optionalParameters: ['time_zone'],
    ),
    // Day 82.
    FunctionDeclaration(
      'places_near_me',
      "Returns the places from the user's documents that are nearest to "
          "the phone right now, nearest first (at most 5), each with a distance "
          'like "450 m" or "1.2 km". '
          'Use it for "what\'s near me", "closest place to eat" and similar.',
      parameters: {
        'kind': Schema.enumString(
          enumValues: [for (final k in PlaceKind.values) k.name],
          description: 'Only this kind of place. Leave out for any.',
        ),
      },
      optionalParameters: ['kind'],
    ),
    // Day 84.
    FunctionDeclaration(
      'get_forecast',
      'Returns the daily weather forecast for a place: weather, highest '
          'and lowest °C, chance of rain. Forecasts only go about two weeks '
          'ahead; for later days, say there is no forecast yet.',
      parameters: {
        'place': Schema.string(
          description: 'A city or address, e.g. "Singapore".',
        ),
        'from': Schema.string(description: 'First day, YYYY-MM-DD.'),
        'to': Schema.string(
          description: 'Last day, YYYY-MM-DD. Leave out for one day.',
        ),
      },
      optionalParameters: ['to'],
    ),
  ];

  /// Sent with every message: the model doesn't know "today" by itself.
  Future<String> context() async {
    final home = await _home();
    if (home == null) {
      final utc = tz.TZDateTime.from(_now(), tz.UTC);
      return "Now: ${_format(utc)} UTC. The phone's time zone is unknown.";
    }
    final now = tz.TZDateTime.from(_now(), home);
    return "Now on the user's phone: ${_format(now)} (${home.name}).";
  }

  /// The phone's time zone, or null when the app can't tell: the plugin
  /// failed, or a name the time zone database doesn't have.
  Future<tz.Location?> _home() async {
    try {
      return _location(await _homeTimeZone());
    } on Exception catch (e) {
      log("Couldn't get the phone's time zone", error: e);
      return null;
    }
  }

  /// Runs one call. Errors go back to the model as answers ({"error":
  /// ...}), so it can tell the user what failed.
  Future<Map<String, Object?>> run(
    FunctionCall call,
    void Function(Booking booking) onAdded,
  ) async {
    try {
      return switch (call.name) {
        'get_local_time' => _localTime(call.args),
        'add_booking' => await _addBooking(call.args, onAdded),
        'places_near_me' => await _placesNearMe(call.args),
        'get_forecast' => await _getForecast(call.args),
        _ => {'error': 'There is no function called ${call.name}.'},
      };
    } on FormatException catch (e) {
      return {'error': e.message};
    } on Failure catch (failure) {
      return {'error': failure.message};
    }
  }

  Map<String, Object?> _localTime(Map<String, Object?> args) {
    final name = args['time_zone'];
    final location = name is String ? _location(name) : null;
    if (location == null) {
      throw const FormatException('time_zone must be an IANA name.');
    }
    final now = tz.TZDateTime.from(_now(), location);
    return {
      'time_zone': location.name,
      'local_time': _format(now),
      'utc_offset': _offset(now.timeZoneOffset),
    };
  }

  Future<Map<String, Object?>> _addBooking(
    Map<String, Object?> args,
    void Function(Booking booking) onAdded,
  ) async {
    final title = switch (args['title']) {
      final String t when t.trim().isNotEmpty => t.trim(),
      _ => throw const FormatException('Need a title.'),
    };
    final kind = BookingKind.values.asNameMap()[args['kind']];
    if (kind == null) throw const FormatException('Unknown kind.');
    final date = _date(args['date']);
    final time = _time(args['time']);
    final zone = switch (args['time_zone']) {
      null =>
        (await _home())?.name ??
            (throw const FormatException(
              "The phone's time zone is unknown: give time_zone.",
            )),
      final String name when _location(name) != null => name,
      _ => throw const FormatException('time_zone must be an IANA name.'),
    };
    // Check and count with no await in between, before the save
    // (Spendbook, Day 74): even calls run in parallel can't all pass.
    if (_addsThisMessage >= maxAddsPerMessage) {
      return {'error': 'At most $maxAddsPerMessage bookings per message.'};
    }
    _addsThisMessage++;
    final booking = await _itinerary.add(
      title: title,
      kind: kind,
      startsAt: DateTime(date.year, date.month, date.day, time.$1, time.$2),
      timeZone: zone,
    );
    onAdded(booking);
    return {'saved': true, 'id': booking.id};
  }

  /// The 5 nearest places, for the model to talk about (Day 82).
  Future<Map<String, Object?>> _placesNearMe(Map<String, Object?> args) async {
    final kind = switch (args['kind']) {
      null => null,
      final String name =>
        PlaceKind.values.asNameMap()[name] ??
            (throw const FormatException('Unknown kind.')),
      _ => throw const FormatException('Unknown kind.'),
    };
    final nearby = await _nearby(kind: kind, top: 5);
    if (nearby.isEmpty) {
      return {
        'places': <Object?>[],
        'note': 'No saved places. The user can find them on the Map tab.',
      };
    }
    return {
      'places': [
        for (final (:place, :meters) in nearby)
          {
            'name': place.found.name,
            'kind': place.found.kind.name,
            'address': place.found.address,
            'distance': formatDistance(meters),
          },
      ],
    };
  }

  /// The forecast, for the model to talk about (Day 84). The same days
  /// stay in GetForecast for the ForecastCard.
  Future<Map<String, Object?>> _getForecast(Map<String, Object?> args) async {
    final place = switch (args['place']) {
      final String p when p.trim().isNotEmpty => p.trim(),
      _ => throw const FormatException('Need a place.'),
    };
    final from = _date(args['from']);
    final to = args['to'] == null ? from : _date(args['to']);
    final days = await _forecast(place, from, to);
    return {
      'place': place,
      'days': [
        for (final day in days)
          {
            'date':
                '${day.date.year}-${_two(day.date.month)}-'
                '${_two(day.date.day)}',
            'weather': weatherText(day.weatherCode),
            'max_c': day.maxC,
            'min_c': day.minC,
            'rain_chance_percent': day.rainChance,
          },
      ],
      'data_by': 'Open-Meteo.com',
    };
  }

  static tz.Location? _location(String name) => timeZoneNamed(name);

  /// "2026-12-21" → that day. Not "2026-02-30": DateTime would quietly
  /// turn it into March 2nd (Spendbook, Day 72).
  static DateTime _date(Object? text) {
    final match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})$',
    ).firstMatch(text is String ? text : '');
    if (match != null) {
      final [y, m, d] = [for (var i = 1; i <= 3; i++) int.parse(match[i]!)];
      final date = DateTime(y, m, d);
      if (date.month == m && date.day == d) return date;
    }
    throw const FormatException('date must be YYYY-MM-DD.');
  }

  static (int, int) _time(Object? text) {
    final match = RegExp(
      r'^([01]\d|2[0-3]):([0-5]\d)$',
    ).firstMatch(text is String ? text : '');
    if (match == null) throw const FormatException('time must be HH:MM.');
    return (int.parse(match[1]!), int.parse(match[2]!));
  }

  static String _format(DateTime t) =>
      '${t.year}-${_two(t.month)}-${_two(t.day)} '
      '${_two(t.hour)}:${_two(t.minute)}';

  static String _offset(Duration offset) {
    final sign = offset.isNegative ? '-' : '+';
    final minutes = offset.inMinutes.abs();
    return '$sign${_two(minutes ~/ 60)}:${_two(minutes % 60)}';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
