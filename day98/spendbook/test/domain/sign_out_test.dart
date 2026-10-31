import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/app_user.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/sign_out.dart';

import '../helpers/fake_auth_repository.dart';
import '../helpers/fake_sync_repository.dart';

void main() {
  late FakeAuthRepository auth;
  late FakeSyncRepository sync;
  setUp(() {
    auth = FakeAuthRepository(
      signedIn: const AppUser(id: 'u1', email: 'mya@example.com'),
    );
    sync = FakeSyncRepository();
  });

  test('uploads, signs out, then forgets this phone\'s data', () async {
    sync.pendingNow = 2;
    final result = await SignOut(auth, sync)('u1');

    expect(result.isRight(), isTrue);
    expect(sync.synced, ['u1']);
    expect(auth.user, isNull);
    expect(sync.cleared, isTrue);
  });

  test('offline with changes: stays signed in, nothing is lost', () async {
    sync
      ..pendingNow = 2
      ..failWith = const NetworkFailure('No connection.');

    final result = await SignOut(auth, sync)('u1');

    final failure = result.getLeft().toNullable()! as UnsavedChangesFailure;
    expect(failure.changes, 2);
    expect(failure.cause, isA<NetworkFailure>());
    expect(auth.user, isNotNull);
    expect(sync.cleared, isFalse);
  });

  test('offline with nothing to upload: signs out', () async {
    sync.failWith = const NetworkFailure('No connection.');

    final result = await SignOut(auth, sync)('u1');

    expect(result.isRight(), isTrue);
    expect(sync.synced, isEmpty); // no need to sync
    expect(sync.cleared, isTrue);
  });

  test('"sign out anyway" loses the changes, as the user said', () async {
    sync
      ..pendingNow = 2
      ..failWith = const NetworkFailure('No connection.');

    final result = await SignOut(auth, sync)('u1', force: true);

    expect(result.isRight(), isTrue);
    expect(auth.user, isNull);
    expect(sync.cleared, isTrue);
  });
}
