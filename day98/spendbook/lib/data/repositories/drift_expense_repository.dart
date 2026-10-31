import 'dart:async';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';

import '../../domain/entities/expense.dart';
import '../../domain/failures.dart';
import '../../domain/repositories/expense_repository.dart';
import '../local/expense_local_data_source.dart';
import '../models/expense_mapper.dart';

/// The domain's ExpenseRepository, stored with Drift.
///
/// The boundary: rows become entities, and exceptions become Failures.
/// Nothing from Drift leaves this class.
class DriftExpenseRepository implements ExpenseRepository {
  DriftExpenseRepository(this._local);

  final ExpenseLocalDataSource _local;

  @override
  Stream<Either<Failure, List<Expense>>> watchExpenses() => _local
      .watchAll()
      .map<Either<Failure, List<Expense>>>(
        (rows) => right([for (final row in rows) row.toEntity()]),
      )
      .transform(
        StreamTransformer.fromHandlers(
          handleError: (error, stackTrace, sink) {
            _log(error, stackTrace);
            sink.add(
              left(const StorageFailure("Couldn't load your expenses.")),
            );
          },
        ),
      );

  @override
  Future<Either<Failure, Unit>> addExpense(Expense expense) =>
      TaskEither<Failure, void>.tryCatch(
        () => _local.insert(expense.toRow()),
        _onError("Couldn't save the expense."),
      ).map((_) => unit).run();

  @override
  Future<Either<Failure, Unit>> deleteExpense(String id) =>
      TaskEither<Failure, int>.tryCatch(
            () => _local.delete(id),
            _onError("Couldn't delete the expense."),
          )
          .flatMap<Unit>(
            (deleted) => deleted == 0
                ? TaskEither.left(
                    const NotFoundFailure('This expense no longer exists.'),
                  )
                : TaskEither.right(unit),
          )
          .run();

  /// Keeps the real error in the log; gives the UI a friendly message.
  static Failure Function(Object, StackTrace) _onError(String message) =>
      (error, stackTrace) {
        _log(error, stackTrace);
        return StorageFailure(message);
      };

  static void _log(Object error, StackTrace stackTrace) =>
      log('Storage error', error: error, stackTrace: stackTrace);
}
