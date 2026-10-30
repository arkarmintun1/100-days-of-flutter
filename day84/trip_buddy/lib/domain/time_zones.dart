import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

var _loaded = false;

/// Loads the IANA time zone database (built into the app) once (Day 80).
void loadTimeZones() {
  if (_loaded) return;
  tz_data.initializeTimeZones();
  _loaded = true;
}

/// The time zone called [name] ("Asia/Singapore"), or null.
tz.Location? timeZoneNamed(String name) {
  loadTimeZones();
  try {
    return tz.getLocation(name);
  } on tz.LocationNotFoundException {
    return null;
  }
}

/// How long from [now] until [startsAt] on the clock in [timeZone]
/// (Day 83). Negative once it has started; null for an unknown zone.
Duration? timeUntil(
  DateTime startsAt,
  String timeZone, {
  required DateTime now,
}) {
  final location = timeZoneNamed(timeZone);
  if (location == null) return null;
  final at = tz.TZDateTime(
    location,
    startsAt.year,
    startsAt.month,
    startsAt.day,
    startsAt.hour,
    startsAt.minute,
  );
  // Both are instants: the difference doesn't depend on the phone's zone.
  return at.difference(now);
}
