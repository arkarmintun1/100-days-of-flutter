// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/providers/photos_provider.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_repository.dart';
import 'helpers/screenshot_helper.dart';

Widget app(FakePhotoRepository repo, {ThemeData? theme}) {
  return ChangeNotifierProvider(
    create: (_) => PhotosProvider(repo)..loadCurated(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.lightTheme,
      home: const HomeScreen(),
    ),
  );
}

void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day29_loading',
    (t) => screenshot(
      t,
      'day29_loading',
      app(FakePhotoRepository(onCurated: (_) => FakePhotoRepository.never())),
      settle: false,
    ),
  );

  testWidgets(
    'day29_list',
    (t) => screenshot(t, 'day29_list', app(FakePhotoRepository())),
  );

  testWidgets(
    'day29_error',
    (t) => screenshot(
      t,
      'day29_error',
      app(
        FakePhotoRepository(
          onCurated: (_) async => const Failure(
            'Unable to connect. Check your network and try again.',
          ),
        ),
      ),
    ),
  );
}
