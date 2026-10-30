import 'package:flutter/material.dart';

import '../../domain/booking.dart';

/// A booking in a list or in the chat (Day 80).
class BookingTile extends StatelessWidget {
  const BookingTile(this.booking, {super.key, this.prefix, this.trailing});

  final Booking booking;

  /// "Added" / "Removed" in the chat.
  final String? prefix;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = booking.startsAt;
    String two(int n) => n.toString().padLeft(2, '0');
    return ListTile(
      leading: Icon(switch (booking.kind) {
        BookingKind.flight => Icons.flight,
        BookingKind.hotel => Icons.hotel,
        BookingKind.activity => Icons.local_activity,
        BookingKind.other => Icons.event,
      }),
      title: Text(prefix == null ? booking.title : '$prefix: ${booking.title}'),
      // The time where it happens, with the place's time zone.
      subtitle: Text(
        '${t.year}-${two(t.month)}-${two(t.day)} '
        '${two(t.hour)}:${two(t.minute)} · ${booking.timeZone}',
      ),
      trailing: trailing,
    );
  }
}
