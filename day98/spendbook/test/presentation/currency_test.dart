import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_exchange_rate_repository.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  Finder field(String label) => find.widgetWithText(TextFormField, label);

  Future<void> addInSgd(
    WidgetTester tester,
    FakeExpenseRepository repository, {
    FakeExchangeRateRepository? rates,
  }) async {
    await tester.pumpWidget(testApp(repository, rates: rates));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownMenu<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SGD').last);
    await tester.pumpAndSettle();

    await tester.enterText(field('Amount'), '16');
    await tester.enterText(field('Title'), 'Chicken rice');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('an amount in SGD is saved in USD, with the original', (
    tester,
  ) async {
    final repository = FakeExpenseRepository();
    await addInSgd(tester, repository);

    final saved = repository.expenses.single;
    expect(saved.amountCents, 1249); // 16 × 0.78047
    expect(
      saved.original,
      const ForeignAmount(currency: 'SGD', minorUnits: 1600, decimalDigits: 2),
    );
    // Back on the list: the USD amount, and what was paid.
    expect(find.text('Food · Oct 28 · SGD 16.00'), findsOneWidget);
  });

  testWidgets('no rate: the error is shown and nothing is saved', (
    tester,
  ) async {
    final repository = FakeExpenseRepository();
    final rates = FakeExchangeRateRepository()
      ..failWith = const NetworkFailure(
        "Couldn't get the exchange rate. Check your connection.",
      );
    await addInSgd(tester, repository, rates: rates);

    expect(
      find.text("Couldn't get the exchange rate. Check your connection."),
      findsOneWidget,
    );
    expect(repository.expenses, isEmpty);
  });
}
