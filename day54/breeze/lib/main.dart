import 'package:breeze/app.dart';
import 'package:breeze/core/retry_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(
    const ProviderScope(
      // Retry network and server errors only (Pixly, Day 47).
      retry: retryTransient,
      child: BreezeApp(),
    ),
  );
}
