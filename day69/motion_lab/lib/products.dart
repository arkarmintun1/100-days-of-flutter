import 'package:flutter/material.dart';

/// Example products for the gallery. Icons and colors instead of photos,
/// so the demo works offline.
class Product {
  const Product(this.id, this.name, this.price, this.icon, this.color);

  final int id;
  final String name;
  final String price;
  final IconData icon;
  final Color color;
}

const products = [
  Product(1, 'Headphones', r'$129', Icons.headphones, Color(0xFF5E35B1)),
  Product(2, 'Camera', r'$499', Icons.photo_camera, Color(0xFF00897B)),
  Product(3, 'Watch', r'$249', Icons.watch, Color(0xFFF4511E)),
  Product(4, 'Speaker', r'$89', Icons.speaker, Color(0xFF3949AB)),
  Product(5, 'Keyboard', r'$159', Icons.keyboard, Color(0xFF6D4C41)),
  Product(6, 'Game pad', r'$59', Icons.sports_esports, Color(0xFFD81B60)),
];

Product productById(int id) => products.firstWhere((p) => p.id == id);
