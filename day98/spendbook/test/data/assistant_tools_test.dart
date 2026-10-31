import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/data/ai/assistant_tools.dart';
import 'package:spendbook/domain/usecases/add_expense.dart';

import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  final now = DateTime(2026, 10, 28, 10);
  late FakeExpenseRepository repository;
  late AssistantTools tools;
  var ids = 0;

  setUp(() {
    repository = FakeExpenseRepository(sampleExpenses);
    tools = AssistantTools(
      addExpense: AddExpense(
        repository,
        newId: () => 'n${++ids}',
        now: () => now,
      ),
      expenses: () async => right(repository.expenses),
      now: () => now,
    );
  });

  Future<Map<String, Object?>> run(String name, Map<String, Object?> args) =>
      tools.run(FunctionCall(name, args), (_) {});

  test('get_spending sums one month', () async {
    expect(await run('get_spending', {'month': '2026-10'}), {
      'total': '185.45',
      'count': 5,
      'byCategory': {
        'bills': '87.35',
        'food': '45.20',
        'transport': '20.00',
        'shopping': '18.90',
        'entertainment': '14.00',
      },
    });
  });

  test('arguments that do not fit are answered with an error', () async {
    for (final args in [
      {'title': 'Coffee', 'amount': '4,50', 'category': 'food'},
      {'title': 'Coffee', 'amount': '4.50', 'category': 'drinks'},
      {
        'title': 'Coffee',
        'amount': '4.50',
        'category': 'food',
        'date': 'today',
      },
      {'amount': '4.50', 'category': 'food'},
    ]) {
      final result = await run('add_expense', args);
      expect(result.keys, ['error'], reason: '$args');
    }
    for (final args in [
      {'month': 202610}, // a number, not "2026-10"
      {'month': '2026-13'},
      {'month': '2026-00'},
      <String, Object?>{},
    ]) {
      final result = await run('get_spending', args);
      expect(result, {'error': 'month must be YYYY-MM.'}, reason: '$args');
    }
    expect(await run('delete_everything', {}), {
      'error': 'There is no function called delete_everything.',
    });
    expect(repository.expenses, hasLength(sampleExpenses.length));
  });

  test('at most 5 expenses per message', () async {
    tools.newMessage();
    for (var i = 0; i < 6; i++) {
      await run('add_expense', {
        'title': 'Item $i',
        'amount': '1',
        'category': 'other',
      });
    }
    expect(repository.expenses, hasLength(sampleExpenses.length + 5));

    tools.newMessage(); // the next message may add again
    final result = await run('add_expense', {
      'title': 'One more',
      'amount': '1',
      'category': 'other',
    });
    expect(result['saved'], isTrue);
  });

  test('the limit also holds for parallel calls', () async {
    tools.newMessage();
    // Six calls in one answer run together (Future.wait).
    final results = await Future.wait([
      for (var i = 0; i < 6; i++)
        run('add_expense', {
          'title': 'Item $i',
          'amount': '1',
          'category': 'other',
        }),
    ]);
    expect(results.where((r) => r['saved'] == true), hasLength(5));
    expect(repository.expenses, hasLength(sampleExpenses.length + 5));
  });
}
