import 'package:flutter/material.dart';

import 'examples/explore_grid.dart';
import 'examples/explore_grid_network.dart';
import 'examples/grid_count.dart';
import 'examples/grid_extent.dart';
import 'examples/main_axis_extent.dart';
import 'examples/product_grid.dart';

void main() => runApp(const Day24App());

class Day24App extends StatelessWidget {
  const Day24App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day 24: GridView',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const ExampleMenu(),
    );
  }
}

class ExampleMenu extends StatelessWidget {
  const ExampleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <(String, Widget)>[
      ('GridView.count', const GridCountExample()),
      ('GridView.extent', const GridExtentExample()),
      ('Explore Grid', const ExploreGrid()),
      ('Explore Grid (network)', const ExploreGridNetwork()),
      ('Product Grid', const ProductGrid()),
      ('mainAxisExtent', const FixedHeightGrid()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Day 24: GridView')),
      body: ListView(
        children: [
          for (final (title, page) in examples)
            ListTile(
              title: Text(title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              ),
            ),
        ],
      ),
    );
  }
}
