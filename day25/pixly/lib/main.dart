import 'package:flutter/material.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/screens/home_screen.dart';

void main() {
  runApp(const PixlyApp());
}

class PixlyApp extends StatelessWidget {
  const PixlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
