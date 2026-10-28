import 'package:flutter/material.dart';

/// Example 1 - GridView.count: a fixed number of columns.
class GridCountExample extends StatelessWidget {
  const GridCountExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView.count')),
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: List.generate(12, (index) {
          return Container(
            alignment: .center,
            color: Colors.teal.shade200,
            child: Text('${index + 1}'),
          );
        }),
      ),
    );
  }
}
