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

@DriftDatabase(tables: [Expenses, Budgets])
class AppDatabase extends _$AppDatabase {
  /// Tests pass an in-memory database here.
  AppDatabase(super.executor);

  /// The app's database file on the device.
  AppDatabase.defaults() : super(driftDatabase(name: 'spendbook'));

  /// 1: the expenses table (Day 57). 2: an index on date (Day 58).
  /// 3: the budgets table (Day 62).
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // A new install: create everything of the latest version.
    onCreate: (m) => m.createAll(),
    // An update: bring an older database up to date, step by step.
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createIndex(expensesDate);
      if (from < 3) await m.createTable(budgets);
    },
  );
}
