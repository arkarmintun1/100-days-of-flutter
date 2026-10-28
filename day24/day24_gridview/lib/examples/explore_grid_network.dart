import 'package:flutter/material.dart';

/// The same explore grid with real photos from the network.
class ExploreGridNetwork extends StatelessWidget {
  const ExploreGridNetwork({super.key});

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
          return Image.network(
            'https://picsum.photos/seed/$index/300/300',
            fit: .cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image),
              );
            },
          );
        },
      ),
    );
  }
}
