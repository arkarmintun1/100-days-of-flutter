import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/failures.dart';
import 'dependencies.dart';

part 'budget.g.dart';

/// The monthly budget in cents (null: not set yet).
@riverpod
class MonthlyBudget extends _$MonthlyBudget {
  @override
  Stream<int?> build() {
    final watchBudget = ref.watch(watchMonthlyBudgetProvider);
    return watchBudget().map(
      (result) => result.fold((failure) => throw failure, (cents) => cents),
    );
  }

  Future<Either<Failure, Unit>> set(int cents) =>
      ref.read(setMonthlyBudgetProvider)(cents);
}
