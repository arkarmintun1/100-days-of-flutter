import 'package:breeze/screens/weather_screen.dart';
import 'package:flutter/material.dart';

class BreezeApp extends StatelessWidget {
  const BreezeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breeze',
      debugShowCheckedModeBanner: false,
      // Dark: white text and icons on the weather gradients.
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const WeatherScreen(),
    );
  }
}
