import 'package:drift/drift.dart';

import 'app_database.dart';

/// Day 91: the database's side of syncing. The app's screens never use it.
class SyncLocalDataSource {
  SyncLocalDataSource(this._db);

  final AppDatabase _db;

  /// Changed here and not uploaded yet, deleted ones included.
  Future<List<ExpenseRow>> dirtyRows() =>
      (_db.select(_db.expenses)..where((e) => e.dirty)).get();

  /// How many changes wait for an upload. Emits again when that changes.
  Stream<int> watchDirtyCount() {
    final count = _db.expenses.id.count();
    final query = _db.selectOnly(_db.expenses)
      ..addColumns([count])
      ..where(_db.expenses.dirty);
    // Drift runs the query again after any write to the table: distinct()
    // drops the repeats, so a listener only hears real changes.
    return query.map((row) => row.read(count) ?? 0).watchSingle().distinct();
  }

  /// After an upload. A row changed again during the upload (deleted, a
  /// newer updatedAt) stays dirty and goes up next time.
  Future<void> markClean(List<ExpenseRow> uploaded) => _db.batch((batch) {
    for (final row in uploaded) {
      batch.update(
        _db.expenses,
        const ExpensesCompanion(dirty: Value(false)),
        where: (e) =>
            e.id.equals(row.id) &
            e.updatedAt.equals(row.updatedAt) &
            e.deleted.equals(row.deleted),
      );
    }
  });

  /// Rows from Firestore. Expenses can't be edited and ids never repeat,
  /// so a row only ever goes from "there" to "deleted": a new expense is
  /// added, and a deletion is final, whatever any phone's clock says.
  Future<void> applyRemote(List<ExpenseRow> rows) => _db.transaction(() async {
    for (final row in rows) {
      final ours = await (_db.select(
        _db.expenses,
      )..where((e) => e.id.equals(row.id))).getSingleOrNull();
      if (ours == null || (row.deleted && !ours.deleted)) {
        await _db
            .into(_db.expenses)
            .insertOnConflictUpdate(row.copyWith(dirty: false));
      }
    }
  });

  Future<SyncInfoRow?> syncInfo() => (_db.select(
    _db.syncInfos,
  )..where((s) => s.id.equals(1))).getSingleOrNull();

  Future<void> saveSyncInfo({required String userId, int? pulledUpTo}) => _db
      .into(_db.syncInfos)
      .insertOnConflictUpdate(
        SyncInfoRow(id: 1, userId: userId, pulledUpTo: pulledUpTo),
      );

  /// This database now syncs with another account: everything in it is
  /// uploaded to that account.
  Future<void> startSyncFor(String userId) => _db.transaction(() async {
    await _db
        .update(_db.expenses)
        .write(const ExpensesCompanion(dirty: Value(true)));
    await saveSyncInfo(userId: userId);
  });

  /// After signing out: this phone forgets the account's expenses, and the
  /// budget too (it isn't synced, but it's theirs).
  Future<void> clear() => _db.transaction(() async {
    await _db.delete(_db.expenses).go();
    await _db.delete(_db.budgets).go();
    await _db.delete(_db.syncInfos).go();
  });
}
