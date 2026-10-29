import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../rive_factory.dart';

/// Rive handles the taps (its state machine listens to the pointer) and
/// tells Flutter the result with an event.
class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // Loads the file once. This State owns it, so it disposes it.
  late final _fileLoader = FileLoader.fromAsset(
    'assets/rive/rating.riv',
    riveFactory: riveFactory,
  );

  double? _rating;

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  void _onRiveEvent(Event event) {
    // A custom number property the designer put on the event.
    final rating = event.numberProperty('rating')?.value;
    if (rating == null || !mounted) return;
    setState(() => _rating = rating);
  }

  @override
  Widget build(BuildContext context) {
    final rating = _rating;
    return Scaffold(
      appBar: AppBar(title: const Text('Rating')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: RiveWidgetBuilder(
                  fileLoader: _fileLoader,
                  // The controller is ready: listen to the state machine.
                  onLoaded: (state) => state.controller.stateMachine
                      .addEventListener(_onRiveEvent),
                  builder: (context, state) => switch (state) {
                    RiveLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    RiveFailed(:final error) => Center(
                      child: Text("Couldn't load the animation: $error"),
                    ),
                    RiveLoaded(:final controller) => RiveWidget(
                      controller: controller,
                    ),
                  },
                ),
              ),
            ),
          ),
          Text(
            rating == null
                ? 'Tap a star'
                : 'You gave ${rating.round()} out of 5',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
