import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/config/theme.dart';
import 'package:pixly/screens/home_screen.dart';

void main() {
  // Show the Poppins font license on Flutter's licenses page.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Poppins'], license);
  });

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
