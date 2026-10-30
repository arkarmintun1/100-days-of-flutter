/// What a booking is for (Day 80).
enum BookingKind { flight, hotel, activity, other }

/// Something on the trip's itinerary, added by the user or by Trip Buddy.
class Booking {
  const Booking({
    required this.id,
    required this.title,
    required this.kind,
    required this.startsAt,
    required this.timeZone,
  });

  final int id;
  final String title;
  final BookingKind kind;

  /// The time on the clock where it happens: a 09:00 flight from Bangkok
  /// is 09:00 in [timeZone] ("Asia/Bangkok"), wherever the phone is.
  final DateTime startsAt;
  final String timeZone;
}

/// The trip's bookings, kept on the device. Throws a StorageFailure.
abstract interface class Itinerary {
  /// Earliest first.
  Stream<List<Booking>> watchBookings();

  Future<Booking> add({
    required String title,
    required BookingKind kind,
    required DateTime startsAt,
    required String timeZone,
  });

  Future<void> delete(int id);
}
