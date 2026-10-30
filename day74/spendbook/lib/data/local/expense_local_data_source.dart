import 'package:drift/drift.dart';

import 'app_database.dart';

/// Talks to the database; knows rows, not entities.
class ExpenseLocalDataSource {
  ExpenseLocalDataSource(this._db);

  final AppDatabase _db;

  /// All rows, newest first. Drift re-runs the query when the table changes.
  Stream<List<ExpenseRow>> watchAll() {
    final query = _db.select(_db.expenses)
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch();
  }

  Future<void> insert(ExpenseRow row) => _db.into(_db.expenses).insert(row);

  /// How many rows were deleted (0 or 1).
  Future<int> delete(String id) =>
      (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();
}
