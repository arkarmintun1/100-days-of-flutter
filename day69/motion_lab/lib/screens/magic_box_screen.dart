import 'package:flutter/material.dart';

/// Tap the box: size, color and corners change, and AnimatedContainer
/// animates between the old and the new values.
class MagicBoxScreen extends StatefulWidget {
  const MagicBoxScreen({super.key});

  @override
  State<MagicBoxScreen> createState() => _MagicBoxScreenState();
}

class _MagicBoxScreenState extends State<MagicBoxScreen> {
  var _isLarge = false;
  var _curve = curves.keys.first;

  /// A few curves to compare: the same change, a different feel.
  static const curves = {
    'easeInOut': Curves.easeInOut,
    'linear': Curves.linear,
    'bounceOut': Curves.bounceOut,
    'elasticOut': Curves.elasticOut,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magic box')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => _isLarge = !_isLarge),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: curves[_curve]!,
                  width: _isLarge ? 250 : 100,
                  height: _isLarge ? 250 : 100,
                  decoration: BoxDecoration(
                    color: _isLarge ? Colors.deepPurple : Colors.amber,
                    borderRadius: BorderRadius.circular(_isLarge ? 125 : 12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Tap me',
                    style: TextStyle(
                      color: _isLarge ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String>(
              segments: [
                for (final name in curves.keys)
                  ButtonSegment(value: name, label: Text(name)),
              ],
              selected: {_curve},
              onSelectionChanged: (selection) =>
                  setState(() => _curve = selection.single),
              showSelectedIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}
