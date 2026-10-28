import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final IconData icon;

  const Product({required this.name, required this.price, required this.icon});
}

const products = [
  Product(name: 'Sneakers', price: 89.99, icon: Icons.directions_run),
  Product(name: 'Headphones', price: 149.00, icon: Icons.headphones),
  Product(name: 'Backpack', price: 59.50, icon: Icons.backpack),
  Product(name: 'Watch', price: 199.00, icon: Icons.watch),
  Product(name: 'Camera', price: 499.00, icon: Icons.photo_camera),
  Product(name: 'Sunglasses', price: 39.99, icon: Icons.wb_sunny),
  Product(name: 'Laptop', price: 999.00, icon: Icons.laptop_mac),
  Product(name: 'Coffee Mug', price: 12.00, icon: Icons.coffee),
];

/// Example 4 - Product gallery: MaxCrossAxisExtent + childAspectRatio.
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Grid')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .antiAlias,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              child: Icon(product.icon, size: 48, color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: const TextStyle(fontWeight: .bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
