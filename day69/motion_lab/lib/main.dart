import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Day 69: load Rive's native library before the first animation.
  await RiveNative.init();
  runApp(const MotionLabApp());
}

class MotionLabApp extends StatefulWidget {
  const MotionLabApp({super.key});

  @override
  State<MotionLabApp> createState() => _MotionLabAppState();
}

class _MotionLabAppState extends State<MotionLabApp> {
  // Made once, kept for the app's lifetime (not in build).
  late final _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Motion Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      routerConfig: _router,
    );
  }
}
