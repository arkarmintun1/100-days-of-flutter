import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('spendbook_test');
    file = File('${dir.path}/spendbook.sqlite');
  });
  tearDown(() => dir.deleteSync(recursive: true));

  test('version 1 → 4: every step runs, and the data is kept', () async {
    // A database as Day 57's app left it: version 1, one expense.
    final v1 = sqlite3.open(file.path);
    v1.execute('''
      CREATE TABLE expenses (
        id TEXT NOT NULL PRIMARY KEY,
        title TEXT NOT NULL,
        amount_cents INTEGER NOT NULL,
        category TEXT NOT NULL,
        date INTEGER NOT NULL,
        note TEXT NULL
      );
      INSERT INTO expenses VALUES ('1', 'Lunch', 1250, 'food', 1793180000, NULL);
    ''');
    v1.userVersion = 1;
    v1.close();

    final db = AppDatabase(NativeDatabase(file));
    final rows = await db.select(db.expenses).get(); // opens and migrates
    expect(rows.single.title, 'Lunch');

    final index = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name = 'expenses_date'",
        )
        .get();
    expect(index, hasLength(1));
    // Day 62: the budgets table exists and works.
    await db.into(db.budgets).insert(const BudgetRow(id: 1, monthlyCents: 100));
    // Day 63: the old expense has no original currency.
    expect(rows.single.originalCurrency, isNull);
    await db.close();

    final after = sqlite3.open(file.path);
    expect(after.userVersion, 4);
    after.close();
  });

  test('a new install gets the latest version, with the index', () async {
    final db = AppDatabase(NativeDatabase(file));
    await db.select(db.expenses).get();
    final index = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE name = 'expenses_date'",
        )
        .get();
    expect(index, hasLength(1));
    await db.close();
  });
}
