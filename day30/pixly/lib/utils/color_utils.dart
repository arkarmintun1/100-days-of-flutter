import 'package:flutter/painting.dart';

/// Turns a hex string like "#7A8C6E" into a [Color]. Falls back to grey.
Color colorFromHex(String hex) {
  final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
  if (value == null || hex.replaceFirst('#', '').length != 6) {
    return const Color(0xFF9E9E9E);
  }
  return Color(0xFF000000 | value);
}
