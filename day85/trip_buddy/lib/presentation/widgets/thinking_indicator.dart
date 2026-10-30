import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import '../providers/dependencies.dart';

/// Shown while Trip Buddy is thinking (Day 85): Rive's "little machine",
/// or a still icon when animations are turned off.
class ThinkingIndicator extends ConsumerWidget {
  const ThinkingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loader = ref.watch(thinkingAnimationProvider);
    // Android's "Remove animations" sets disableAnimations. iOS's "Reduce
    // Motion" only sets reduceMotion (Flutter's API documentation). Read
    // like this, a change doesn't rebuild the widget, but a new one is
    // made for every question.
    final reduceMotion = View.of(
      context,
    ).platformDispatcher.accessibilityFeatures.reduceMotion;
    final still =
        loader == null ||
        MediaQuery.disableAnimationsOf(context) ||
        reduceMotion;
    // Its own node, so a screen reader reads it on its own. A live region
    // tells the platform its updates matter: screen readers may announce
    // it without the user moving focus there.
    return Semantics(
      container: true,
      liveRegion: true,
      label: 'Trip Buddy is thinking',
      child: SizedBox(
        width: 120,
        height: 80,
        child: still
            ? const Icon(Icons.more_horiz)
            // The animation draws a new frame all the time: its own layer,
            // so the chat around it isn't repainted with it (Day 66).
            : RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RiveWidgetBuilder(
                    fileLoader: loader,
                    builder: (context, state) => switch (state) {
                      RiveLoading() => const SizedBox.shrink(),
                      RiveFailed() => const Icon(Icons.more_horiz),
                      RiveLoaded() => RiveWidget(
                        controller: state.controller,
                        fit: Fit.contain,
                      ),
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
