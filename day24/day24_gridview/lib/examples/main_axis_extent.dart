import 'package:flutter/material.dart';

/// Example 5 - mainAxisExtent: fixed tile height instead of a ratio.
class FixedHeightGrid extends StatelessWidget {
  const FixedHeightGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('mainAxisExtent')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 20,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 120,
        ),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.folder),
              title: Text('Folder ${index + 1}'),
              subtitle: Text('${(index + 1) * 3} files'),
            ),
          );
        },
      ),
    );
  }
}
