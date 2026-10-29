import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../products.dart';

/// A grid of products. Tap one: its picture flies to the detail screen.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
        children: [
          for (final product in products)
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/gallery/${product.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // The same tag on both screens: one per product, so
                    // the tags on this screen are all different.
                    child: Hero(
                      tag: 'product-${product.id}',
                      flightShuttleBuilder: productFlight,
                      child: ProductPicture(product),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(product.price),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The "photo" of a product: a colored card with its icon.
class ProductPicture extends StatelessWidget {
  const ProductPicture(this.product, {super.key, this.radius = 16});

  final Product product;

  /// Rounded in the grid, square (0) on the detail screen.
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            product.color,
            Color.lerp(product.color, Colors.black, 0.4)!,
          ],
        ),
      ),
      child: SizedBox.expand(
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(product.icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// What flies between the screens: the picture, with its corners going
/// from rounded (grid) to square (detail).
///
/// [animation] is the detail route's: 0 = grid, 1 = detail. On the way
/// back (pop) it runs from 1 to 0, so the same code works both ways.
Widget productFlight(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection direction,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final hero = toHeroContext.widget as Hero;
  final picture = hero.child as ProductPicture;
  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) => ProductPicture(
      picture.product,
      radius: lerpDouble(16, 0, animation.value)!,
    ),
  );
}
