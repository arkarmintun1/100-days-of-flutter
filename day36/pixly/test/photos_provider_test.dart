import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/providers/photos_provider.dart';

import 'helpers/fake_repository.dart';

void main() {
  test('loadCurated: loading -> photos, notifying listeners twice', () async {
    final provider = PhotosProvider(FakePhotoRepository());
    final loadingStates = <bool>[];
    provider.addListener(() => loadingStates.add(provider.isLoading));

    await provider.loadCurated();

    expect(loadingStates, [true, false]);
    expect(provider.photos, hasLength(12));
    expect(provider.error, isNull);
  });

  test('loadCurated: Failure -> error message, no photos', () async {
    final provider = PhotosProvider(
      FakePhotoRepository(onCurated: (_) async => const Failure('No internet')),
    );

    await provider.loadCurated();

    expect(provider.error, 'No internet');
    expect(provider.photos, isEmpty);
    expect(provider.isLoading, isFalse);
  });

  test('a second call while loading is ignored', () async {
    final repo = FakePhotoRepository();
    final provider = PhotosProvider(repo);

    final first = provider.loadCurated();
    final second = provider.loadCurated();
    await Future.wait([first, second]);

    expect(repo.curatedCalls, [1]);
  });

  test('photos list cannot be modified from outside', () async {
    final provider = PhotosProvider(FakePhotoRepository());
    await provider.loadCurated();
    expect(() => provider.photos.clear(), throwsUnsupportedError);
  });

  test(
    'disposing while a request is pending does not notify afterwards',
    () async {
      final pending = Completer<Result<PhotosPage>>();
      final provider = PhotosProvider(
        FakePhotoRepository(onCurated: (_) => pending.future),
      );

      final load = provider.loadCurated();
      provider.dispose();
      pending.complete(FakePhotoRepository.fixturePage('curated_page1'));

      await expectLater(load, completes); // no "used after dispose" error
    },
  );
}
