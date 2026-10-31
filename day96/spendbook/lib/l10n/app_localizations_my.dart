// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get navExpenses => 'အသုံးစရိတ်';

  @override
  String get navDashboard => 'အနှစ်ချုပ်';

  @override
  String get navAsk => 'မေးရန်';

  @override
  String get account => 'အကောင့်';

  @override
  String get language => 'ဘာသာစကား';

  @override
  String get languageSystem => 'ဖုန်းရဲ့ ဘာသာစကား';

  @override
  String get somethingWentWrong => 'တခုခု မှားသွားပါတယ်။';

  @override
  String get addExpense => 'စရိတ် ထည့်ရန်';

  @override
  String get deleteExpenseTitle => 'ဖျက်မှာ သေချာပါသလား။';

  @override
  String deleteExpenseBody(String title) {
    return '\"$title\" ကို ဖျက်ပါမယ်။';
  }

  @override
  String get cancel => 'မလုပ်တော့';

  @override
  String get delete => 'ဖျက်ရန်';

  @override
  String deleted(String title) {
    return '\"$title\" ကို ဖျက်ပြီးပါပြီ။';
  }

  @override
  String noExpensesIn(DateTime month) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.yMMMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return '$monthString မှာ စရိတ် မရှိပါ။';
  }

  @override
  String noCategoryExpensesIn(String category, DateTime month) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.yMMMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return '$monthString မှာ $category စရိတ် မရှိပါ။';
  }

  @override
  String expenseCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'စရိတ် $countString ခု',
      zero: 'စရိတ် မရှိပါ',
    );
    return '$_temp0';
  }

  @override
  String get previousMonth => 'ယခင်လ';

  @override
  String get nextMonth => 'နောက်လ';

  @override
  String get allCategories => 'အားလုံး';

  @override
  String get categoryFood => 'အစားအသောက်';

  @override
  String get categoryTransport => 'သွားလာရေး';

  @override
  String get categoryShopping => 'ဈေးဝယ်';

  @override
  String get categoryBills => 'ဘေလ်';

  @override
  String get categoryEntertainment => 'ဖျော်ဖြေရေး';

  @override
  String get categoryHealth => 'ကျန်းမာရေး';

  @override
  String get categoryOther => 'အခြား';

  @override
  String get scanReceipt => 'ပြေစာ စကင်ဖတ်ရန်';

  @override
  String get cameraError => 'ကင်မရာ ဖွင့်လို့ မရပါ။';

  @override
  String get noTotalFound => 'စုစုပေါင်း ရှာမတွေ့ပါ။ ကိုယ်တိုင် ရိုက်ထည့်ပါ။';

  @override
  String get checkAmountAndCurrency => 'ပမာဏနဲ့ ငွေကြေးကို ပြန်စစ်ပါ။';

  @override
  String get amount => 'ပမာဏ';

  @override
  String convertedOnSave(String currency) {
    return 'သိမ်းတဲ့အခါ $currency အဖြစ် ပြောင်းပါမယ်။';
  }

  @override
  String get enterWholeAmount => '1500 လို ကိန်းပြည့် ထည့်ပါ';

  @override
  String get enterAmount => '12.50 လို ပမာဏ ထည့်ပါ';

  @override
  String get currency => 'ငွေကြေး';

  @override
  String get title => 'ခေါင်းစဉ်';

  @override
  String get category => 'အမျိုးအစား';

  @override
  String get suggest => 'အကြံပြုရန်';

  @override
  String get change => 'ပြောင်းရန်';

  @override
  String get noteOptional => 'မှတ်ချက် (မထည့်လည်း ရ)';

  @override
  String get save => 'သိမ်းရန်';

  @override
  String get noExpensesThisMonth => 'ဒီလ စရိတ် မရှိပါ။';

  @override
  String get dailySpending => 'နေ့စဉ် သုံးငွေ';

  @override
  String dayOfMonth(int day) {
    final intl.NumberFormat dayNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String dayString = dayNumberFormat.format(day);

    return '$dayString ရက်';
  }

  @override
  String get total => 'စုစုပေါင်း';

  @override
  String get couldNotLoadBudget => 'ဘတ်ဂျက်ကို ဖတ်လို့ မရပါ။';

  @override
  String budgetOf(String amount) {
    return 'ဘတ်ဂျက် $amount';
  }

  @override
  String amountLeft(String amount) {
    return '$amount ကျန်';
  }

  @override
  String amountOver(String amount) {
    return '$amount ပိုသုံးထား';
  }

  @override
  String get noBudgetYet => 'လစဉ် ဘတ်ဂျက် မသတ်မှတ်ရသေးပါ';

  @override
  String get setBudget => 'သတ်မှတ်ရန်';

  @override
  String get monthlyBudget => 'လစဉ် ဘတ်ဂျက်';

  @override
  String get enterBudget => '300 လို ပမာဏ ထည့်ပါ';
}
