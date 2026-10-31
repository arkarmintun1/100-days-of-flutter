import 'app_database.dart';

class BudgetLocalDataSource {
  BudgetLocalDataSource(this._db);

  final AppDatabase _db;

  /// There's only ever one budget row.
  static const _id = 1;

  /// The budget in cents, or null if none was set yet.
  Stream<int?> watch() {
    final query = _db.select(_db.budgets)..where((b) => b.id.equals(_id));
    return query.watchSingleOrNull().map((row) => row?.monthlyCents);
  }

  /// Inserts the row the first time, updates it after that (an upsert).
  Future<void> save(int cents) => _db
      .into(_db.budgets)
      .insertOnConflictUpdate(BudgetRow(id: _id, monthlyCents: cents));
}
