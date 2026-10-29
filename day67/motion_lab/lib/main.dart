import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const MotionLabApp());

class MotionLabApp extends StatelessWidget {
  const MotionLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}
