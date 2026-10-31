import 'package:fpdart/fpdart.dart';

import '../entities/expense_category.dart';
import '../failures.dart';
import '../repositories/category_suggester.dart';

/// A category for a title, or why there's none.
class SuggestCategory(final CategorySuggester _suggester) {
  Future<Either<Failure, ExpenseCategory>> call(String title) async {
    final cleanTitle = title.trim();
    // Don't spend a request (time and money) on nothing.
    if (cleanTitle.isEmpty) {
      return left(const ValidationFailure('Enter a title first.'));
    }
    return _suggester.suggest(cleanTitle);
  }
}
