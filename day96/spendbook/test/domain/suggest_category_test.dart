import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/suggest_category.dart';

import '../helpers/fake_category_suggester.dart';

void main() {
  test('an empty title is not sent to the AI', () async {
    final suggester = FakeCategorySuggester(right(ExpenseCategory.food));

    final result = await SuggestCategory(suggester)('   ');

    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    expect(suggester.titles, isEmpty);
  });

  test('the title is trimmed before it is sent', () async {
    final suggester = FakeCategorySuggester(right(ExpenseCategory.food));

    final result = await SuggestCategory(suggester)('  Kopi C  ');

    expect(result.getRight().toNullable(), ExpenseCategory.food);
    expect(suggester.titles, ['Kopi C']);
  });
}
