import 'package:flutter/material.dart';

void main() => runApp(const SpendbookApp());

/// The UI comes on Day 59: the domain and data layers come first.
class SpendbookApp extends StatelessWidget {
  const SpendbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendbook',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const Scaffold(body: Center(child: Text('Spendbook'))),
    );
  }
}
