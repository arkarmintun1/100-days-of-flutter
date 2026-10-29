import 'package:flutter/material.dart';

import '../products.dart';
import 'gallery_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final product = productById(id);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1,
            // The same tag as in the grid: Flutter flies this widget from
            // the grid cell's place and size to this one's.
            child: Hero(
              tag: 'product-${product.id}',
              flightShuttleBuilder: productFlight,
              child: ProductPicture(product, radius: 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: text.headlineMedium),
                Text(product.price, style: text.titleLarge),
                const SizedBox(height: 16),
                const Text(
                  'A made-up product to show a Hero animation: the picture '
                  'flies from the grid to this screen, and back when you go '
                  'back.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
