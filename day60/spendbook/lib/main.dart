import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/screens/expenses_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      // A local database won't fix itself by trying again (Day 47):
      // show errors right away.
      retry: _noRetry,
      child: SpendbookApp(),
    ),
  );
}

Duration? _noRetry(int retryCount, Object error) => null;

class SpendbookApp extends StatelessWidget {
  const SpendbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendbook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const ExpensesScreen(),
    );
  }
}
