import 'dart:async';

import 'package:trip_buddy/domain/booking.dart';

/// The itinerary in a list, for tests (Day 80).
class FakeItinerary implements Itinerary {
  FakeItinerary([List<Booking> bookings = const []])
    : _bookings = List.of(bookings);

  final List<Booking> _bookings;
  final _changes = StreamController<void>.broadcast();
  var _nextId = 100;

  List<Booking> get bookings => List.unmodifiable(_bookings);

  @override
  Stream<List<Booking>> watchBookings() async* {
    yield _sorted();
    await for (final _ in _changes.stream) {
      yield _sorted();
    }
  }

  List<Booking> _sorted() =>
      List.of(_bookings)..sort((a, b) => a.startsAt.compareTo(b.startsAt));

  @override
  Future<Booking> add({
    required String title,
    required BookingKind kind,
    required DateTime startsAt,
    required String timeZone,
  }) async {
    final booking = Booking(
      id: _nextId++,
      title: title,
      kind: kind,
      startsAt: startsAt,
      timeZone: timeZone,
    );
    _bookings.add(booking);
    _changes.add(null);
    return booking;
  }

  @override
  Future<void> delete(int id) async {
    _bookings.removeWhere((b) => b.id == id);
    _changes.add(null);
  }
}
