import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/category_suggester.dart';

/// Answers with [result] and remembers the titles it was asked about.
/// Pass a [Completer] to answer only when the test says so.
class FakeCategorySuggester implements CategorySuggester {
  FakeCategorySuggester(this.result, {this.wait});

  final Either<Failure, ExpenseCategory> result;
  final Completer<void>? wait;
  final titles = <String>[];

  @override
  Future<Either<Failure, ExpenseCategory>> suggest(String title) async {
    titles.add(title);
    await wait?.future;
    return result;
  }
}
