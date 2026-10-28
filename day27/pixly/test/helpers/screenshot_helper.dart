// Renders widgets to PNG "screenshots" for the blog, using real Roboto and
// Material Icons fonts (flutter test normally uses the blocky Ahem font).
// Run with: flutter test --update-goldens
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadRealFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return;
  final dir = '$root/bin/cache/artifacts/material_fonts';

  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      final file = File('$dir/$f');
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        loader.addFont(Future.value(ByteData.view(bytes.buffer)));
      }
    }
    await loader.load();
  }

  await load('Roboto', [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
    'Roboto-Light.ttf',
  ]);
  await load('MaterialIcons', ['MaterialIcons-Regular.otf']);

  // Fonts declared in the app's pubspec.yaml (e.g. Poppins) via FontManifest.
  try {
    final manifest = await rootBundle.loadString('FontManifest.json');
    for (final family in json.decode(manifest) as List<dynamic>) {
      final name = family['family'] as String;
      if (name == 'MaterialIcons') continue;
      final loader = FontLoader(name);
      for (final font in family['fonts'] as List<dynamic>) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  } catch (_) {
    // No app fonts declared.
  }
}

/// Pumps [child] at a phone-sized viewport and writes `screenshots/NAME.png`.
Future<void> screenshot(
  WidgetTester tester,
  String name,
  Widget child, {
  Size size = const Size(390, 844),
  double pixelRatio = 2.0,
  Future<void> Function(WidgetTester tester)? before,
}) async {
  tester.view.physicalSize = size * pixelRatio;
  tester.view.devicePixelRatio = pixelRatio;
  addTearDown(tester.view.reset);

  // flutter_test replaces shadows with black outlines by default; draw real
  // shadows so the screenshot looks like the app on a device.
  debugDisableShadows = false;
  try {
    await tester.pumpWidget(
      RepaintBoundary(key: const ValueKey('screenshot'), child: child),
    );
    await tester.pumpAndSettle();
    if (before != null) await before(tester);
    await expectLater(
      find.byKey(const ValueKey('screenshot')),
      matchesGoldenFile('screenshots/$name.png'),
    );
  } finally {
    debugDisableShadows = true;
  }
}
