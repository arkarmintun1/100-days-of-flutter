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
  );
}
