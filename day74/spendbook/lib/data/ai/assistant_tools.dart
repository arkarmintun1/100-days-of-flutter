import 'package:firebase_ai/firebase_ai.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/failures.dart';
import '../../domain/repositories/assistant_model.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/summarize_month.dart';

/// The app functions Gemini may ask for (Day 74). Gemini never runs them:
/// it asks, this class checks the arguments and runs the real use case.
class AssistantTools {
  AssistantTools({
    required AddExpense addExpense,
    required Future<Either<Failure, List<Expense>>> Function() expenses,
    required DateTime Function() now,
    SummarizeMonth summarize = const SummarizeMonth(),
  }) : _addExpense = addExpense,
       _expenses = expenses,
       _now = now,
       _summarize = summarize;

  final AddExpense _addExpense;
  final Future<Either<Failure, List<Expense>>> Function() _expenses;
  final DateTime Function() _now;
  final SummarizeMonth _summarize;

  /// Most expenses one message can add: a model that misunderstood
  /// can't fill the list with dozens of them.
  static const maxAddsPerMessage = 5;
  var _addsThisMessage = 0;

  /// Called at the start of each user message.
  void newMessage() => _addsThisMessage = 0;

  /// What Gemini is told about the tools. The descriptions are what it
  /// reads to decide when to call them: write them like documentation.
  final declarations = [
    FunctionDeclaration(
      'add_expense',
      'Saves a new expense in Spendbook. Use it only when the user asks to '
          'add, log or record an expense. One call per expense.',
      parameters: {
        'title': Schema.string(description: 'What it was, e.g. "Coffee".'),
        'amount': Schema.string(
          description: 'In USD, digits and a dot only, e.g. "4.50".',
        ),
        'category': Schema.enumString(
          enumValues: [for (final c in ExpenseCategory.values) c.name],
        ),
        'date': Schema.string(
          description: 'YYYY-MM-DD. Leave it out for today.',
        ),
      },
      optionalParameters: ['date'],
    ),
    FunctionDeclaration(
      'get_spending',
      "Returns the total and the totals per category for one month of the "
          "user's expenses, in USD.",
      parameters: {'month': Schema.string(description: 'YYYY-MM.')},
    ),
  ];

  /// Runs one call. The answer goes back to Gemini, so errors are answers
  /// too ({"error": ...}): the model can then tell the user what failed.
  Future<Map<String, Object?>> run(
    FunctionCall call,
    void Function(AssistantAction action) report,
  ) async {
    try {
      return switch (call.name) {
        'add_expense' => await _add(call.args, report),
        'get_spending' => await _spending(call.args),
        _ => {'error': 'There is no function called ${call.name}.'},
      };
    } on FormatException catch (e) {
      return {'error': e.message};
    }
  }

  Future<Map<String, Object?>> _add(
    Map<String, Object?> args,
    void Function(AssistantAction action) report,
  ) async {
    final cents = switch (args['amount']) {
      final String amount => _cents(amount),
      _ => null,
    };
    final category = ExpenseCategory.values.asNameMap()[args['category']];
    if (cents == null || category == null || args['title'] is! String) {
      throw const FormatException('Need a title, an amount and a category.');
    }
    final now = _now();
    final date = switch (args['date']) {
      null => now,
      final String text => _date(text),
      _ => null,
    };
    if (date == null) throw const FormatException('date must be YYYY-MM-DD.');
    // Count it BEFORE the await: parallel calls all run up to their
    // first await before any save finishes, so counting after the save
    // would let six of them through.
    if (_addsThisMessage >= maxAddsPerMessage) {
      return {'error': 'At most $maxAddsPerMessage expenses per message.'};
    }
    _addsThisMessage++;
    // The same use case as the form: the same business rules (Day 56).
    final result = await _addExpense(
      title: args['title']! as String,
      amountCents: cents,
      category: category,
      date: date,
    );
    return result.fold(
      (failure) {
        _addsThisMessage--; // not saved: doesn't count
        return {'error': failure.message};
      },
      (expense) {
        report(ExpenseAdded(expense));
        return {'saved': true, 'id': expense.id};
      },
    );
  }

  Future<Map<String, Object?>> _spending(Map<String, Object?> args) async {
    // Arguments are untrusted: check the type, not just the text.
    final match = switch (args['month']) {
      final String month => RegExp(
        r'^(\d{4})-(0[1-9]|1[0-2])$',
      ).firstMatch(month),
      _ => null,
    };
    if (match == null) throw const FormatException('month must be YYYY-MM.');
    final expenses = await _expenses();
    return expenses.fold((failure) => {'error': failure.message}, (list) {
      final summary = _summarize(
        list,
        year: int.parse(match[1]!),
        month: int.parse(match[2]!),
      );
      return {
        'total': _usd(summary.totalCents),
        'count': summary.count,
        'byCategory': {
          for (final MapEntry(:key, :value) in summary.byCategory.entries)
            key.name: _usd(value),
        },
      };
    });
  }

  /// "4.50" → 450. Null if it isn't a plain amount.
  static int? _cents(String amount) {
    final match = RegExp(r'^(\d{1,7})(?:\.(\d{1,2}))?$').firstMatch(amount);
    if (match == null) return null;
    return int.parse(match[1]!) * 100 +
        int.parse((match[2] ?? '').padRight(2, '0'));
  }

  /// "2026-10-28" → that day; null for "2026-02-30" or anything else.
  static DateTime? _date(String text) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
    if (match == null) return null;
    final [year, month, day] = [
      for (var i = 1; i <= 3; i++) int.parse(match[i]!),
    ];
    final date = DateTime(year, month, day);
    return date.month == month && date.day == day ? date : null;
  }

  static String _usd(int cents) => (cents / 100).toStringAsFixed(2);
}
