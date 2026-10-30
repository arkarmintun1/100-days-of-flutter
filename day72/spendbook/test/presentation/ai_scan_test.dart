import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/entities/receipt_draft.dart';
import 'package:spendbook/data/ai/ai_errors.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_expense_repository.dart';
import '../helpers/fake_receipt_reader.dart';
import '../helpers/receipts.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('with AI on, Gemini fills amount, currency, date and category', (
    tester,
  ) async {
    final gemini = FakeReceiptReader(
      right(
        ReceiptDraft(
          merchant: 'Kopi Corner',
          total: '10.25',
          currency: 'SGD',
          date: DateTime(2026, 10, 27),
          category: ExpenseCategory.food,
        ),
      ),
    );
    // ML Kit is also there: it must not be used when AI is on.
    final mlKit = FakeReader(right(cafe));
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        aiReceiptReader: gemini,
        receiptReader: mlKit,
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    expect(gemini.paths, ['/tmp/receipt.jpg']);
    String field(String label) => tester
        .widget<TextFormField>(find.widgetWithText(TextFormField, label))
        .controller!
        .text;
    expect(field('Amount'), '10.25');
    expect(field('Title'), 'Kopi Corner');
    expect(
      tester
          .widget<DropdownMenu<String>>(find.byType(DropdownMenu<String>))
          .initialSelection,
      'SGD',
    );
    expect(find.text('Oct 27, 2026'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Food'))
          .selected,
      isTrue,
    );
  });

  testWidgets('a date in the future or an unknown currency is ignored', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        aiReceiptReader: FakeReceiptReader(
          right(
            ReceiptDraft(
              total: '5000',
              currency: 'KRW', // not in Spendbook's list
              date: DateTime(2027, 1, 1), // after testNow
            ),
          ),
        ),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<DropdownMenu<String>>(find.byType(DropdownMenu<String>))
          .initialSelection,
      'USD',
    );
    expect(find.text('Oct 28, 2026'), findsOneWidget); // still today
  });

  testWidgets("a date older than the picker's range is ignored", (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        aiReceiptReader: FakeReceiptReader(
          right(ReceiptDraft(total: '12.00', date: DateTime(2019, 6, 1))),
        ),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    expect(find.text('Oct 28, 2026'), findsOneWidget); // still today
    // The date picker still opens (its first date is Jan 1, 2021).
    await tester.tap(find.text('Oct 28, 2026'));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('offline, the scan falls back to ML Kit on the device', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        aiReceiptReader: FakeReceiptReader(
          left(const NetworkFailure('No connection.')),
        ),
        receiptReader: FakeReader(right(cafe)),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    // ML Kit's parser found the cafe receipt's total.
    expect(
      tester
          .widget<TextFormField>(find.widgetWithText(TextFormField, 'Amount'))
          .controller!
          .text,
      '10.25',
    );
    expect(find.text('No connection.'), findsNothing);
  });

  testWidgets('no App Check token (offline) falls back to ML Kit too', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        aiReceiptReader: FakeReceiptReader(left(appCheckFailed)),
        receiptReader: FakeReader(right(cafe)),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextFormField>(find.widgetWithText(TextFormField, 'Amount'))
          .controller!
          .text,
      '10.25',
    );
    expect(find.text(appCheckFailed.message), findsNothing);
  });

  testWidgets('other AI failures are shown, not hidden by ML Kit', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        aiReceiptReader: FakeReceiptReader(
          left(const AiFailure('Too many requests. Try again later.')),
        ),
        receiptReader: FakeReader(right(cafe)),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    expect(find.text('Too many requests. Try again later.'), findsOneWidget);
  });
}
