import 'package:breeze/screens/weather_screen.dart';
import 'package:flutter/material.dart';

class BreezeApp extends StatelessWidget {
  const BreezeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breeze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const WeatherScreen(),
    );
  }
}
