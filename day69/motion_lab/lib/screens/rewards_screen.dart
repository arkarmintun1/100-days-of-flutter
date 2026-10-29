import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../rive_factory.dart';

/// Flutter and Rive share data through the file's view model
/// (data binding): Flutter writes numbers, Rive draws them, and Rive's
/// button fires a trigger that Flutter listens to.
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late final _fileLoader = FileLoader.fromAsset(
    'assets/rive/rewards.riv',
    riveFactory: riveFactory,
  );

  // Properties of the view model instance, found by their path.
  ViewModelInstanceNumber? _coins;
  ViewModelInstanceNumber? _energy;

  @override
  void dispose() {
    // RiveWidgetBuilder disposes the controller and the view model
    // instance (and with it, the property listeners). The loader is ours.
    _fileLoader.dispose();
    super.dispose();
  }

  void _onLoaded(RiveLoaded state) {
    final viewModel = state.viewModelInstance!;
    setState(() {
      _coins = viewModel.number('Coin/Item_Value');
      _energy = viewModel.number('Energy_Bar/Energy_Bar');
    });
    // Rive's "Continue" button fires this trigger.
    viewModel.trigger('Button/Pressed')?.addListener(_onContinue);
  }

  void _onContinue(bool _) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Rewards collected!')));
  }

  @override
  Widget build(BuildContext context) {
    final coins = _coins;
    final energy = _energy;
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                // The artboard's size in the Rive editor: 1252 x 2223.
                aspectRatio: 1252 / 2223,
                child: RiveWidgetBuilder(
                  fileLoader: _fileLoader,
                  // Bind the file's default view model instance.
                  dataBind: DataBind.auto(),
                  onLoaded: _onLoaded,
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
          if (coins != null && energy != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  FilledButton.tonal(
                    // Setting the value: Rive redraws the counter.
                    onPressed: () => coins.value += 100,
                    child: const Text('+100 coins'),
                  ),
                  Expanded(
                    child: Slider(
                      // Energy_Bar is 0-100 in this file.
                      value: energy.value.clamp(0, 100),
                      max: 100,
                      label: 'Energy',
                      onChanged: (value) =>
                          setState(() => energy.value = value),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
