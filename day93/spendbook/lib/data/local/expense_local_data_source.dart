import 'package:drift/drift.dart';

import 'app_database.dart';

/// Talks to the database; knows rows, not entities.
class ExpenseLocalDataSource {
  /// Day 91: [now] stamps every change; tests pass their own clock.
  ExpenseLocalDataSource(this._db, {this._now = DateTime.now});

  final AppDatabase _db;
  final DateTime Function() _now;

  /// All rows, newest first. Drift re-runs the query when the table changes.
  /// Deleted ones (Day 91) are left out.
  Stream<List<ExpenseRow>> watchAll() {
    final query = _db.select(_db.expenses)
      ..where((e) => e.deleted.not())
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch();
  }

  /// Day 91: stamped with the time, and marked for upload.
  Future<void> insert(ExpenseRow row) => _db
      .into(_db.expenses)
      .insert(row.copyWith(updatedAt: _stamp(), deleted: false, dirty: true));

  /// How many rows were deleted (0 or 1).
  ///
  /// Day 91: the row stays, marked deleted, so the deletion can be uploaded
  /// and reach the other phones.
  Future<int> delete(String id) =>
      (_db.update(
        _db.expenses,
      )..where((e) => e.id.equals(id) & e.deleted.not())).write(
        ExpensesCompanion(
          deleted: const Value(true),
          updatedAt: Value(_stamp()),
          dirty: const Value(true),
        ),
      );

  int _stamp() => _now().millisecondsSinceEpoch;
}
