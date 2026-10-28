import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/widgets/error_view.dart';
import 'package:pixly/widgets/photo_image.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/fake_repository.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  Future<void> pumpError(WidgetTester tester, ErrorKind kind) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ErrorView(kind: kind, message: 'Details', onRetry: () {}),
        ),
      ),
    );
  }

  for (final (kind, icon, title, retry) in [
    (ErrorKind.network, Icons.wifi_off, 'No connection', true),
    (
      ErrorKind.rateLimited,
      Icons.hourglass_empty,
      'Taking a short break',
      true,
    ),
    (ErrorKind.unauthorized, Icons.key_off, 'API key problem', false),
    (
      ErrorKind.notFound,
      Icons.image_not_supported_outlined,
      'Not found',
      false,
    ),
    (ErrorKind.server, Icons.cloud_off, 'Pexels is having trouble', true),
    (ErrorKind.unknown, Icons.error_outline, 'Something went wrong', true),
  ]) {
    testWidgets('$kind: "$title", retry: $retry', (tester) async {
      await pumpError(tester, kind);

      expect(find.byIcon(icon), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Try again'), retry ? findsOneWidget : findsNothing);
    });
  }

  testWidgets('Home shows the kind of the first-page error', (tester) async {
    var fail = true;
    final repo = FakePhotoRepository(
      onCurated: (page) async => fail
          ? const Failure('Unable to connect.', kind: ErrorKind.network)
          : FakePhotoRepository.defaultCurated(page),
    );
    await tester.pumpWidget(testApp(repository: repo));
    await tester.pumpAndSettle();

    expect(find.text('No connection'), findsOneWidget);
    expect(find.byType(SliverAppBar), findsOneWidget); // app bar stays

    fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsNothing);
  });

  testWidgets('an API key problem on Home offers no retry', (tester) async {
    final repo = FakePhotoRepository(
      onCurated: (_) async =>
          const Failure('Invalid API key.', kind: ErrorKind.unauthorized),
    );
    await tester.pumpWidget(testApp(repository: repo));
    await tester.pumpAndSettle();

    expect(find.text('API key problem'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  test('only some kinds can be retried', () {
    expect(ErrorKind.values.where((kind) => kind.canRetry), [
      ErrorKind.network,
      ErrorKind.rateLimited,
      ErrorKind.server,
      ErrorKind.unknown,
    ]);
  });
}
