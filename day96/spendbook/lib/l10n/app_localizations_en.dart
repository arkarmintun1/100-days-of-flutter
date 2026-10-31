// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navAsk => 'Ask';

  @override
  String get account => 'Account';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Phone\'s language';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get addExpense => 'Add expense';

  @override
  String get deleteExpenseTitle => 'Delete expense?';

  @override
  String deleteExpenseBody(String title) {
    return '\"$title\" will be deleted.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String deleted(String title) {
    return 'Deleted \"$title\".';
  }

  @override
  String noExpensesIn(DateTime month) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.yMMMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return 'No expenses in $monthString.';
  }

  @override
  String noCategoryExpensesIn(String category, DateTime month) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.yMMMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return 'No $category expenses in $monthString.';
  }

  @override
  String expenseCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString expenses',
      one: '1 expense',
      zero: 'No expenses',
    );
    return '$_temp0';
  }

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get allCategories => 'All';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categoryEntertainment => 'Fun';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryOther => 'Other';

  @override
  String get scanReceipt => 'Scan receipt';

  @override
  String get cameraError => 'Couldn\'t open the camera.';

  @override
  String get noTotalFound => 'Couldn\'t find the total. Please type it.';

  @override
  String get checkAmountAndCurrency => 'Check the amount and the currency.';

  @override
  String get amount => 'Amount';

  @override
  String convertedOnSave(String currency) {
    return 'Converted to $currency when you save.';
  }

  @override
  String get enterWholeAmount => 'Enter a whole amount like 1500';

  @override
  String get enterAmount => 'Enter an amount like 12.50';

  @override
  String get currency => 'Currency';

  @override
  String get title => 'Title';

  @override
  String get category => 'Category';

  @override
  String get suggest => 'Suggest';

  @override
  String get change => 'Change';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get save => 'Save';

  @override
  String get noExpensesThisMonth => 'No expenses this month.';

  @override
  String get dailySpending => 'Daily spending';

  @override
  String dayOfMonth(int day) {
    final intl.NumberFormat dayNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String dayString = dayNumberFormat.format(day);

    return 'Day $dayString';
  }

  @override
  String get total => 'Total';

  @override
  String get couldNotLoadBudget => 'Couldn\'t load your budget.';

  @override
  String budgetOf(String amount) {
    return 'Budget $amount';
  }

  @override
  String amountLeft(String amount) {
    return '$amount left';
  }

  @override
  String amountOver(String amount) {
    return '$amount over';
  }

  @override
  String get noBudgetYet => 'No monthly budget yet';

  @override
  String get setBudget => 'Set budget';

  @override
  String get monthlyBudget => 'Monthly budget';

  @override
  String get enterBudget => 'Enter an amount like 300';
}
