import 'package:flutter/material.dart';

/// Two ways to animate what has no AnimatedFoo widget:
/// TweenAnimationBuilder (a number) and AnimatedSwitcher (a new widget).
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  var _steps = 0;
  var _celebrating = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Counts up from the old value to the new one.
            TweenAnimationBuilder<double>(
              tween: Tween(end: _steps.toDouble()),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) =>
                  Text('${value.round()} steps', style: text.displaySmall),
              // onEnd: called when an animation finishes. Here it chains a
              // second animation: the badge appears after the count.
              onEnd: () => setState(() => _celebrating = _steps >= 10000),
            ),
            const SizedBox(height: 24),
            // A different child (by key) cross-fades in.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: _celebrating
                  ? const Chip(
                      key: ValueKey('goal'),
                      avatar: Icon(Icons.emoji_events),
                      label: Text('Goal reached!'),
                    )
                  : const Chip(
                      key: ValueKey('keep-going'),
                      label: Text('Goal: 10,000'),
                    ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => setState(() => _steps += 2500),
              child: const Text('+2,500 steps'),
            ),
          ],
        ),
      ),
    );
  }
}
