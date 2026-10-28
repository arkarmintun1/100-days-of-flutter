import 'package:flutter/material.dart';

/// Example 3 - An Instagram-style explore grid with GridView.builder.
/// Each tile is a coloured placeholder; swap in Image.network for real photos.
class ExploreGrid extends StatelessWidget {
  const ExploreGrid({super.key});

  static const icons = [
    Icons.landscape,
    Icons.pets,
    Icons.restaurant,
    Icons.flight,
    Icons.music_note,
    Icons.sports_soccer,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: GridView.builder(
        itemCount: 60,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          final color = Colors.primaries[index % Colors.primaries.length];
          return Container(
            color: color.shade300,
            child: Icon(
              icons[index % icons.length],
              color: Colors.white,
              size: 36,
            ),
          );
        },
      ),
    );
  }
}
