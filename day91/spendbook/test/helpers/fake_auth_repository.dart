import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/app_user.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/auth_repository.dart';

/// Accounts in a map, like a tiny Firebase Auth. Set [failWith] to make
/// every call fail.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? signedIn}) : _user = signedIn;

  /// email -> (password, id) of the accounts that exist.
  final accounts = <String, (String, String)>{};
  Failure? failWith;
  AppUser? _user;
  var _nextId = 1;
  final _changes = StreamController<AppUser?>.broadcast();

  AppUser? get user => _user;

  @override
  Stream<AppUser?> watchUser() async* {
    yield _user;
    yield* _changes.stream;
  }

  void _set(AppUser? user) {
    _user = user;
    _changes.add(user);
  }

  @override
  Future<Either<Failure, AppUser>> continueAsGuest() async {
    if (failWith case final failure?) return left(failure);
    final guest = AppUser(id: 'user-${_nextId++}');
    _set(guest);
    return right(guest);
  }

  @override
  Future<Either<Failure, AppUser>> createAccount({
    required String email,
    required String password,
  }) async {
    if (failWith case final failure?) return left(failure);
    if (accounts.containsKey(email)) {
      return left(const AuthFailure('This email already has an account.'));
    }
    // A guest keeps their id, like linkWithCredential.
    final id = _user?.isGuest == true ? _user!.id : 'user-${_nextId++}';
    accounts[email] = (password, id);
    final account = AppUser(id: id, email: email);
    _set(account);
    return right(account);
  }

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    if (failWith case final failure?) return left(failure);
    final account = accounts[email];
    if (account == null || account.$1 != password) {
      return left(const AuthFailure('Wrong email or password.'));
    }
    final user = AppUser(id: account.$2, email: email);
    _set(user);
    return right(user);
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    if (failWith case final failure?) return left(failure);
    _set(null);
    return right(unit);
  }
}
