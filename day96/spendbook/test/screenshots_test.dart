// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show right;
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/repositories/assistant_model.dart';
import 'package:spendbook/domain/entities/receipt_draft.dart';
import 'package:spendbook/domain/entities/spending_insight.dart';

import 'helpers/fake_assistant_model.dart';
import 'helpers/fake_budget_repository.dart';
import 'helpers/fake_category_suggester.dart';
import 'helpers/fake_insight_writer.dart';
import 'helpers/fake_receipt_reader.dart';
import 'helpers/receipts.dart';
import 'helpers/fake_expense_repository.dart';
import 'helpers/fake_locale_store.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

/// Screenshots for the blog posts (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day59_list',
    (t) => screenshot(
      t,
      'day59_list',
      testApp(FakeExpenseRepository(sampleExpenses)),
    ),
  );

  testWidgets(
    'day59_add',
    (t) => screenshot(
      t,
      'day59_add',
      testApp(FakeExpenseRepository()),
      before: (t) async {
        await t.tap(find.text('Add expense'));
        await t.pumpAndSettle();
        await t.enterText(find.widgetWithText(TextFormField, 'Amount'), '4.20');
        await t.enterText(
          find.widgetWithText(TextFormField, 'Title'),
          'Bubble tea',
        );
        await t.tap(find.text('Shopping'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day60_filter',
    (t) => screenshot(
      t,
      'day60_filter',
      testApp(FakeExpenseRepository(sampleExpenses)),
      before: (t) async {
        await t.tap(find.widgetWithText(ChoiceChip, 'Food'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day61_dashboard',
    (t) => screenshot(
      t,
      'day61_dashboard',
      testApp(FakeExpenseRepository(sampleExpenses)),
      before: (t) async {
        await t.tap(find.text('Dashboard'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day62_budget',
    (t) => screenshot(
      t,
      'day62_budget',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
      ),
      before: (t) async {
        await t.tap(find.text('Dashboard'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day62_daily',
    (t) => screenshot(
      t,
      'day62_daily',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
      ),
      before: (t) async {
        await t.tap(find.text('Dashboard'));
        await t.pumpAndSettle();
        await t.drag(find.byType(ListView).last, const Offset(0, -600));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day63_currency',
    (t) => screenshot(
      t,
      'day63_currency',
      testApp(FakeExpenseRepository(sampleExpenses)),
      before: (t) async {
        await t.tap(find.text('Add expense'));
        await t.pumpAndSettle();
        await t.tap(find.byType(DropdownMenu<String>));
        await t.pumpAndSettle();
        await t.tap(find.text('SGD').last);
        await t.pumpAndSettle();
        await t.enterText(find.widgetWithText(TextFormField, 'Amount'), '16');
        await t.enterText(
          find.widgetWithText(TextFormField, 'Title'),
          'Chicken rice',
        );
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day63_list',
    (t) => screenshot(
      t,
      'day63_list',
      testApp(
        FakeExpenseRepository([
          ...sampleExpenses,
          Expense(
            id: '7',
            title: 'Chicken rice',
            amountCents: 1249,
            category: ExpenseCategory.food,
            date: DateTime(2026, 10, 28, 13),
            original: const ForeignAmount(
              currency: 'SGD',
              minorUnits: 1600,
              decimalDigits: 2,
            ),
          ),
        ]),
      ),
    ),
  );

  testWidgets(
    'day64_scan',
    (t) => screenshot(
      t,
      'day64_scan',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        receiptReader: FakeReader(right(cafe)),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
      before: (t) async {
        await t.tap(find.text('Add expense'));
        await t.pumpAndSettle();
        await t.tap(find.byTooltip('Scan receipt'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day70_suggest',
    (t) => screenshot(
      t,
      'day70_suggest',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        categorySuggester: FakeCategorySuggester(
          right(ExpenseCategory.transport),
        ),
      ),
      before: (t) async {
        await t.tap(find.text('Add expense'));
        await t.pumpAndSettle();
        await t.enterText(
          find.widgetWithText(TextFormField, 'Amount'),
          '18.40',
        );
        await t.enterText(
          find.widgetWithText(TextFormField, 'Title'),
          'Grab to the airport',
        );
        await t.tap(find.text('Suggest'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day71_insight',
    (t) => screenshot(
      t,
      'day71_insight',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
        insightWriter: FakeInsightWriter(
          right(
            const SpendingInsight(
              headline: 'Electricity bill leads your October',
              tip:
                  "You've used 62% of your budget with 3 days left. Keep the "
                  'rest of the month to essentials.',
            ),
          ),
        ),
      ),
      before: (t) async {
        await t.tap(find.text('Dashboard'));
        await t.pumpAndSettle();
        await t.tap(find.text('Explain my month'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day72_scan',
    (t) => screenshot(
      t,
      'day72_scan',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        aiReceiptReader: FakeReceiptReader(
          right(
            ReceiptDraft(
              merchant: 'Kopi Corner',
              total: '10.25',
              currency: 'SGD',
              date: DateTime(2026, 10, 27),
              category: ExpenseCategory.food,
            ),
          ),
        ),
        receiptPhoto: '/tmp/receipt.jpg',
      ),
      before: (t) async {
        await t.tap(find.text('Add expense'));
        await t.pumpAndSettle();
        await t.tap(find.byTooltip('Scan receipt'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day73_assistant',
    (t) => screenshot(
      t,
      'day73_assistant',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
        assistantModel: FakeAssistantModel([
          'Bills are almost half of your October.\n',
          ...FakeAssistantModel.answer('month', [
            {
              'id': 'root',
              'component': 'Column',
              'children': ['bills', 'food', 'tip'],
            },
            {
              'id': 'bills',
              'component': 'SpendingCard',
              'category': 'bills',
              'amount': 87.35,
              'share': 0.47,
            },
            {
              'id': 'food',
              'component': 'SpendingCard',
              'category': 'food',
              'amount': 64.10,
              'share': 0.35,
            },
            {
              'id': 'tip',
              'component': 'TipCard',
              'text': "You've used 62% of your \$300 budget with 3 days left.",
              'mood': 'good',
            },
          ]).skip(1),
        ]),
      ),
      before: (t) async {
        await t.tap(find.text('Ask'));
        await t.pumpAndSettle();
        await t.enterText(find.byType(TextField), 'How am I doing this month?');
        await t.tap(find.byTooltip('Send'));
        await finishAnswer(t);
      },
    ),
  );

  testWidgets('day74_assistant', (t) {
    final coffee = Expense(
      id: 'a1',
      title: 'Coffee',
      amountCents: 500,
      category: ExpenseCategory.food,
      date: DateTime(2026, 10, 28),
    );
    final grab = Expense(
      id: 'a2',
      title: 'Grab',
      amountCents: 2000,
      category: ExpenseCategory.transport,
      date: DateTime(2026, 10, 28),
    );
    return screenshot(
      t,
      'day74_assistant',
      testApp(
        FakeExpenseRepository([...sampleExpenses, coffee, grab]),
        budget: FakeBudgetRepository(30000),
        assistantModel: FakeAssistantModel(
          [
            r'Done: I added Coffee ($5.00, food) and Grab ($20.00, '
                r'transport) for today. You have $89.55 left this month.',
          ],
          actionsToReport: [ExpenseAdded(coffee), ExpenseAdded(grab)],
        ),
      ),
      before: (t) async {
        await t.tap(find.text('Ask'));
        await t.pumpAndSettle();
        await t.enterText(
          find.byType(TextField),
          'Log my 5 dollar coffee and 20 dollar Grab',
        );
        await t.tap(find.byTooltip('Send'));
        await finishAnswer(t);
      },
    );
  });

  // Day 96: the same screens in Myanmar.
  testWidgets(
    'day96_list_my',
    (t) => screenshot(
      t,
      'day96_list_my',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        locale: FakeLocaleStore('my'),
      ),
    ),
  );

  testWidgets(
    'day96_add_my',
    (t) => screenshot(
      t,
      'day96_add_my',
      testApp(FakeExpenseRepository(), locale: FakeLocaleStore('my')),
      before: (t) async {
        await t.tap(find.text('စရိတ် ထည့်ရန်'));
        await t.pumpAndSettle();
        await t.enterText(find.widgetWithText(TextFormField, 'ပမာဏ'), 'abc');
        await t.tap(find.text('သိမ်းရန်'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day96_dashboard_my',
    (t) => screenshot(
      t,
      'day96_dashboard_my',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
        locale: FakeLocaleStore('my'),
      ),
      before: (t) async {
        await t.tap(find.text('အနှစ်ချုပ်'));
        await t.pumpAndSettle();
      },
    ),
  );
}
