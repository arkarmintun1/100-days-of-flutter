import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/budget_repository.dart';

class FakeBudgetRepository implements BudgetRepository {
  FakeBudgetRepository([this.cents]);

  int? cents;
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<Either<Failure, int?>> watchMonthlyBudget() {
    final controller = StreamController<Either<Failure, int?>>();
    StreamSubscription<void>? changes;
    controller
      ..onListen = () {
        changes = _changes.stream.listen((_) => controller.add(right(cents)));
        controller.add(right(cents));
      }
      ..onCancel = () => changes?.cancel();
    return controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> setMonthlyBudget(int cents) async {
    this.cents = cents;
    _changes.add(null);
    return right(unit);
  }
}
