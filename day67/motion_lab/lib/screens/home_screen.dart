import 'package:flutter/material.dart';

import 'counter_screen.dart';
import 'magic_box_screen.dart';
import 'sidebar_screen.dart';

/// A list of small animation demos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void open(Widget screen) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));

    return Scaffold(
      appBar: AppBar(title: const Text('Motion Lab')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.crop_square),
            title: const Text('Magic box'),
            subtitle: const Text('AnimatedContainer and curves'),
            onTap: () => open(const MagicBoxScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.menu_open),
            title: const Text('Sidebar'),
            subtitle: const Text('AnimatedPositioned and AnimatedOpacity'),
            onTap: () => open(const SidebarScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.pin),
            title: const Text('Counter'),
            subtitle: const Text('TweenAnimationBuilder and AnimatedSwitcher'),
            onTap: () => open(const CounterScreen()),
          ),
        ],
      ),
    );
  }
}
