import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/expense_category.dart';

part 'app_database.g.dart';

/// The expenses table. Drift generates the SQL and a row class from it.
@DataClassName('ExpenseRow')
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

@DriftDatabase(tables: [Expenses])
class AppDatabase extends _$AppDatabase {
  /// Tests pass an in-memory database here.
  AppDatabase(super.executor);

  /// The app's database file on the device.
  AppDatabase.defaults() : super(driftDatabase(name: 'spendbook'));

  /// Bump this when the tables change, and add a migration (Day 58).
  @override
  int get schemaVersion => 1;
}
