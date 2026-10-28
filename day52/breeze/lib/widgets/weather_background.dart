import 'package:flutter/material.dart';

/// A full-screen gradient that fades to new [colors] (e.g. when the
/// weather or the time of day changes).
class WeatherBackground extends StatelessWidget {
  const WeatherBackground({
    super.key,
    required this.colors,
    required this.child,
  });

  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // AnimatedContainer animates between two BoxDecorations, gradients too
    // (Day 67 covers implicit animations).
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
