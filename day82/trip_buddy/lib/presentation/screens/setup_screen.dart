import 'package:flutter/material.dart';

/// Shown until the app has a Firebase project (Day 75).
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Buddy')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Trip Buddy needs a Firebase project.\n\n'
          '1. Run `flutterfire configure` in this folder.\n'
          '2. Deploy the functions: `firebase deploy --only functions`.\n'
          '3. Register your App Check debug token.',
        ),
      ),
    );
  }
}
