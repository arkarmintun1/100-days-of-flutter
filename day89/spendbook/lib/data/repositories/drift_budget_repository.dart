import 'dart:async';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';

import '../../domain/failures.dart';
import '../../domain/repositories/budget_repository.dart';
import '../local/budget_local_data_source.dart';

class DriftBudgetRepository implements BudgetRepository {
  DriftBudgetRepository(this._local);

  final BudgetLocalDataSource _local;

  @override
  Stream<Either<Failure, int?>> watchMonthlyBudget() => _local
      .watch()
      .map<Either<Failure, int?>>(right)
      .transform(
        StreamTransformer.fromHandlers(
          handleError: (error, stackTrace, sink) {
            log('Storage error', error: error, stackTrace: stackTrace);
            sink.add(left(const StorageFailure("Couldn't load your budget.")));
          },
        ),
      );

  @override
  Future<Either<Failure, Unit>> setMonthlyBudget(int cents) =>
      TaskEither<Failure, void>.tryCatch(() => _local.save(cents), (
        error,
        stackTrace,
      ) {
        log('Storage error', error: error, stackTrace: stackTrace);
        return const StorageFailure("Couldn't save your budget.");
      }).map((_) => unit).run();
}
