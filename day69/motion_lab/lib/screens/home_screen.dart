import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A list of small animation demos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Day 68: GoRouter. push keeps the home screen below (back works).
    void open(String path) => context.push(path);

    return Scaffold(
      appBar: AppBar(title: const Text('Motion Lab')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.crop_square),
            title: const Text('Magic box'),
            subtitle: const Text('AnimatedContainer and curves'),
            onTap: () => open('/magic-box'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_open),
            title: const Text('Sidebar'),
            subtitle: const Text('AnimatedPositioned and AnimatedOpacity'),
            onTap: () => open('/sidebar'),
          ),
          ListTile(
            leading: const Icon(Icons.pin),
            title: const Text('Counter'),
            subtitle: const Text('TweenAnimationBuilder and AnimatedSwitcher'),
            onTap: () => open('/counter'),
          ),
          ListTile(
            leading: const Icon(Icons.flight_takeoff),
            title: const Text('Gallery'),
            subtitle: const Text('Hero and a custom page transition'),
            onTap: () => open('/gallery'),
          ),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Rating'),
            subtitle: const Text('Rive: taps and events'),
            onTap: () => open('/rating'),
          ),
          ListTile(
            leading: const Icon(Icons.redeem),
            title: const Text('Rewards'),
            subtitle: const Text('Rive: data binding'),
            onTap: () => open('/rewards'),
          ),
        ],
      ),
    );
  }
}
