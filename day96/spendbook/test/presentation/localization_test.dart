import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/l10n/app_localizations.dart';

import '../helpers/fake_expense_repository.dart';
import '../helpers/fake_locale_store.dart';
import '../helpers/test_app.dart';

/// Day 96: English and Myanmar.
void main() {
  test('plurals in English and Myanmar', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final my = lookupAppLocalizations(const Locale('my'));

    expect(en.expenseCount(0), 'No expenses');
    expect(en.expenseCount(1), '1 expense');
    expect(en.expenseCount(1200), '1,200 expenses');
    expect(my.expenseCount(0), 'စရိတ် မရှိပါ');
    expect(my.expenseCount(1), 'စရိတ် ၁ ခု');
    expect(my.expenseCount(3), 'စရိတ် ၃ ခု');
  });

  testWidgets('English: the phone is in English in tests', (tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository(sampleExpenses)));
    await tester.pumpAndSettle();

    expect(find.text('Add expense'), findsOneWidget);
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text('5 expenses'), findsOneWidget);
  });

  testWidgets('Myanmar: texts, the month, digits and money', (tester) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(sampleExpenses),
        locale: FakeLocaleStore('my'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('စရိတ် ထည့်ရန်'), findsOneWidget);
    expect(find.text('၂၀၂၆ အောက်တိုဘာ'), findsOneWidget);
    expect(find.text('စရိတ် ၅ ခု'), findsOneWidget);
    // Money: Myanmar digits, the symbol after the amount.
    expect(find.text('၄၅.၂၀\u00A0\$'), findsOneWidget);
  });

  testWidgets('picking a language changes the app and saves it', (
    tester,
  ) async {
    final store = FakeLocaleStore();
    await tester.pumpWidget(
      testApp(FakeExpenseRepository(sampleExpenses), locale: store),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<String>, 'မြန်မာ'),
    );
    await tester.pumpAndSettle();
    expect(find.text('စရိတ် ထည့်ရန်'), findsOneWidget);
    expect(store.saved, 'my');

    await tester.tap(find.byTooltip('ဘာသာစကား'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<String>, 'ဖုန်းရဲ့ ဘာသာစကား'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add expense'), findsOneWidget);
    expect(store.saved, isNull);
  });
}
