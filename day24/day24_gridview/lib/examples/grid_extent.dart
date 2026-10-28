import 'package:flutter/material.dart';

/// Example 2 - GridView.extent: a maximum tile width, column count adapts.
class GridExtentExample extends StatelessWidget {
  const GridExtentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView.extent')),
      body: GridView.extent(
        maxCrossAxisExtent: 150,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: List.generate(12, (index) {
          return Container(
            alignment: .center,
            color: Colors.orange.shade200,
            child: Text('${index + 1}'),
          );
        }),
      ),
    );
  }
}
