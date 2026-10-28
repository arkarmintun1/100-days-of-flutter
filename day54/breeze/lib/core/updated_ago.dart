import 'package:intl/intl.dart';

/// "Updated 5 min ago": how fresh the weather is.
String updatedAgo(DateTime fetchedAt, DateTime now) {
  final age = now.difference(fetchedAt);
  if (age.inMinutes < 1) return 'Updated just now';
  if (age.inMinutes < 60) return 'Updated ${age.inMinutes} min ago';
  if (age.inHours < 24) return 'Updated ${age.inHours} h ago';
  // Older: the date, in the phone's time zone (it's about the user).
  return 'Updated ${DateFormat.MMMd().format(fetchedAt.toLocal())}';
}
