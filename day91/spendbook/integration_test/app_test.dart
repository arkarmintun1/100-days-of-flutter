import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/main.dart';
import 'package:spendbook/presentation/providers/dependencies.dart';

/// Day 89: the whole app on a simulator or a phone. Real widgets, real
/// platform, real Drift and SQLite: only the database file is swapped for
/// one in memory, so every run starts empty.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add an expense, see it on the dashboard, delete it', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const SpendbookApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No expenses in'), findsOneWidget);

    // Add: the form, the use case, the repository, a real database.
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount'),
      '12.5',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Lunch',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text(r'$12.50'), findsNWidgets(2)); // the row and the total

    // The dashboard reads the same database.
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('100%'), findsWidgets);

    // Delete it again.
    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Lunch'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Deleted "Lunch".'), findsOneWidget);
    expect(find.text('Lunch'), findsNothing);
    expect(find.textContaining('No expenses in'), findsOneWidget);
  });
}
