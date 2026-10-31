import '../../domain/entities/expense.dart';
import '../local/app_database.dart';

/// Row (data layer) → entity (domain).
extension ExpenseRowMapper on ExpenseRow {
  Expense toEntity() => Expense(
    id: id,
    title: title,
    amountCents: amountCents,
    category: category,
    date: date,
    note: note,
    original: switch ((
      originalCurrency,
      originalMinorUnits,
      originalDecimalDigits,
    )) {
      (final String currency, final int minor, final int digits) =>
        ForeignAmount(
          currency: currency,
          minorUnits: minor,
          decimalDigits: digits,
        ),
      _ => null,
    },
  );
}

/// Entity (domain) → row (data layer).
extension ExpenseEntityMapper on Expense {
  ExpenseRow toRow() => ExpenseRow(
    id: id,
    title: title,
    amountCents: amountCents,
    category: category,
    date: date,
    note: note,
    originalCurrency: original?.currency,
    originalMinorUnits: original?.minorUnits,
    originalDecimalDigits: original?.decimalDigits,
    // Set by ExpenseLocalDataSource when it saves the row (Day 91).
    updatedAt: 0,
    deleted: false,
    dirty: true,
  );
}
