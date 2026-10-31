import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_analytics.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/receipts.dart';
import '../helpers/test_app.dart';

/// Day 95: what the add-expense form tells Analytics.
void main() {
  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('a typed expense: its category, nothing it says', (tester) async {
    final analytics = FakeAnalytics();
    await tester.pumpWidget(
      testApp(FakeExpenseRepository(), analytics: analytics),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Amount'), '12.5');
    await tester.enterText(field('Title'), 'Lunch');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(analytics.events, ['expense_added food']);
  });

  testWidgets('not saved (no title): no event', (tester) async {
    final analytics = FakeAnalytics();
    await tester.pumpWidget(
      testApp(FakeExpenseRepository(), analytics: analytics),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Amount'), '12.5');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(analytics.events, isEmpty);
  });

  testWidgets('a scanned receipt, then saved', (tester) async {
    final analytics = FakeAnalytics();
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        analytics: analytics,
        receiptReader: FakeReader(right(cafe)),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(analytics.events, [
      'receipt_scanned total',
      'expense_added food from receipt',
    ]);
  });

  testWidgets('a photo that cannot be read', (tester) async {
    final analytics = FakeAnalytics();
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        analytics: analytics,
        receiptReader: FakeReader(
          left(const ValidationFailure("Couldn't read this photo.")),
        ),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    expect(analytics.events, ['receipt_scanned failed']);
  });
}
