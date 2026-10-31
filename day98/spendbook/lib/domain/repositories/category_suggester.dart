import 'package:fpdart/fpdart.dart';

import '../entities/expense_category.dart';
import '../failures.dart';

/// Guesses an expense's category from its title (Day 70).
///
/// The domain doesn't know it's an AI model behind this: tests use a fake,
/// and the model could be swapped without touching the domain.
abstract interface class CategorySuggester {
  Future<Either<Failure, ExpenseCategory>> suggest(String title);
}
