import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/expense_category.dart';

part 'app_database.g.dart';

/// The expenses table. Drift generates the SQL and a row class from it.
@DataClassName('ExpenseRow')
// Day 58: lists are sorted and filtered by date, so index it.
@TableIndex(name: 'expenses_date', columns: {#date})
class Expenses extends Table {
  TextColumn get id => text()();
  // No withLength(max: 60) here: drift would count UTF-16 code units, but
  // AddExpense (domain) counts characters. One rule, in one place.
  TextColumn get title => text()();
  IntColumn get amountCents => integer()();

  /// Stored as the enum's name ('food'), so adding a category later is
  /// safe; renaming one would need a migration.
  TextColumn get category => textEnum<ExpenseCategory>()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();

  // Day 63: the amount as paid in another currency (all null if not).
  TextColumn get originalCurrency => text().nullable()();
  IntColumn get originalMinorUnits => integer().nullable()();
  IntColumn get originalDecimalDigits => integer().nullable()();

  // Day 91: for syncing with Firestore.

  /// When this phone last changed the expense, in milliseconds since 1970
  /// (UTC). Tells an upload apart from a change made during it.
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  /// Deleted, but kept as a "tombstone" until other phones have seen it.
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  /// Changed here and not uploaded yet.
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Day 91: how far syncing got. One row, with id 1.
@DataClassName('SyncInfoRow')
class SyncInfos extends Table {
  IntColumn get id => integer()();

  /// Whose data this database holds (null before the first sync).
  TextColumn get userId => text().nullable()();

  /// Firestore's time of the newest change downloaded, in microseconds.
  IntColumn get pulledUpTo => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The monthly budget (Day 62): one row, with id 1.
@DataClassName('BudgetRow')
class Budgets extends Table {
  IntColumn get id => integer()();
  IntColumn get monthlyCents => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Expenses, Budgets, SyncInfos])
class AppDatabase extends _$AppDatabase {
  /// Tests pass an in-memory database here.
  AppDatabase(super.executor);

  /// The app's database file on the device.
  AppDatabase.defaults() : super(driftDatabase(name: 'spendbook'));

  /// 1: the expenses table (Day 57). 2: an index on date (Day 58).
  /// 3: the budgets table (Day 62). 4: original currency (Day 63).
  /// 5: sync columns and the sync_infos table (Day 91).
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // A new install: create everything of the latest version.
    onCreate: (m) => m.createAll(),
    // An update: bring an older database up to date, step by step.
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createIndex(expensesDate);
      if (from < 3) await m.createTable(budgets);
      if (from < 4) {
        await m.addColumn(expenses, expenses.originalCurrency);
        await m.addColumn(expenses, expenses.originalMinorUnits);
        await m.addColumn(expenses, expenses.originalDecimalDigits);
      }
      if (from < 5) {
        await m.addColumn(expenses, expenses.updatedAt);
        await m.addColumn(expenses, expenses.deleted);
        // Default true: every expense from before is uploaded once.
        await m.addColumn(expenses, expenses.dirty);
        await m.createTable(syncInfos);
        // Old expenses: "changed now", not in 1970.
        await customStatement('UPDATE expenses SET updated_at = ?', [
          DateTime.now().millisecondsSinceEpoch,
        ]);
      }
    },
  );
}
