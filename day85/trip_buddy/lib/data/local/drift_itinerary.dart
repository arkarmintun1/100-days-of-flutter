import 'dart:developer';

import 'package:drift/drift.dart';

import '../../domain/booking.dart';
import '../../domain/failures.dart';
import 'trip_database.dart';

/// The itinerary in SQLite (Day 80).
class DriftItinerary implements Itinerary {
  DriftItinerary(this._db);

  final TripDatabase _db;

  @override
  Stream<List<Booking>> watchBookings() =>
      (_db.select(_db.bookings)
            ..orderBy([(b) => OrderingTerm(expression: b.startsAt)]))
          .watch()
          .map((rows) => [for (final row in rows) _booking(row)])
          .handleError((Object e, StackTrace stackTrace) {
            log('Reading bookings failed', error: e, stackTrace: stackTrace);
            throw const StorageFailure("Couldn't read the itinerary.");
          });

  @override
  Future<Booking> add({
    required String title,
    required BookingKind kind,
    required DateTime startsAt,
    required String timeZone,
  }) => _guard(() async {
    final row = await _db
        .into(_db.bookings)
        .insertReturning(
          BookingsCompanion.insert(
            title: title,
            kind: kind,
            startsAt: _text(startsAt),
            timeZone: timeZone,
          ),
        );
    return _booking(row);
  });

  @override
  Future<void> delete(int id) => _guard(
    () => (_db.delete(_db.bookings)..where((b) => b.id.equals(id))).go(),
  );

  Future<T> _guard<T>(Future<T> Function() write) async {
    try {
      return await write();
    } on Exception catch (e, stackTrace) {
      log('Writing the itinerary failed', error: e, stackTrace: stackTrace);
      throw const StorageFailure("Couldn't save the itinerary.");
    }
  }

  /// "2026-12-21T09:00": sorts as text in time order.
  static String _text(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}-${_two(t.month)}-${_two(t.day)}'
      'T${_two(t.hour)}:${_two(t.minute)}';

  static String _two(int n) => n.toString().padLeft(2, '0');

  static Booking _booking(BookingRow row) => Booking(
    id: row.id,
    title: row.title,
    kind: row.kind,
    startsAt: DateTime.parse(row.startsAt),
    timeZone: row.timeZone,
  );
}
