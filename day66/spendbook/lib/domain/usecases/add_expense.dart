import 'package:characters/characters.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../entities/expense_category.dart';
import '../failures.dart';
import '../repositories/expense_repository.dart';

/// Checks the business rules, then saves a new expense.
class AddExpense {
  AddExpense(
    this._repository, {
    required String Function() newId,
    required DateTime Function() now,
  }) : _newId = newId,
       _now = now;

  final ExpenseRepository _repository;
  final String Function() _newId;
  final DateTime Function() _now;

  static const maxTitleLength = 60;

  Future<Either<Failure, Expense>> call({
    required String title,
    required int amountCents,
    required ExpenseCategory category,
    required DateTime date,
    String? note,

    /// The amount as paid in another currency, if it was (Day 63).
    ForeignAmount? original,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      return left(const ValidationFailure('Enter a title.'));
    }
    // Characters as people see them: `length` would count UTF-16 code
    // units, and an emoji or a Burmese syllable can be several of them.
    if (cleanTitle.characters.length > maxTitleLength) {
      return left(
        const ValidationFailure(
          'Keep the title to $maxTitleLength characters or fewer.',
        ),
      );
    }
    if (amountCents <= 0) {
      return left(const ValidationFailure('The amount must be more than 0.'));
    }
    if (_dayOf(date).isAfter(_dayOf(_now()))) {
      return left(const ValidationFailure("The date can't be in the future."));
    }

    final cleanNote = note?.trim();
    final expense = Expense(
      id: _newId(),
      title: cleanTitle,
      amountCents: amountCents,
      category: category,
      date: date,
      note: cleanNote == null || cleanNote.isEmpty ? null : cleanNote,
      original: original,
    );
    final saved = await _repository.addExpense(expense);
    // Success: give back the saved expense (with its new id).
    return saved.map((_) => expense);
  }

  /// Only the calendar day: an expense at 9 pm today isn't "in the future".
  static DateTime _dayOf(DateTime time) =>
      DateTime(time.year, time.month, time.day);
}
