import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'products.dart';
import 'screens/counter_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/home_screen.dart';
import 'screens/magic_box_screen.dart';
import 'screens/product_screen.dart';
import 'screens/sidebar_screen.dart';

/// A new router each time: the app makes one, and so does each test.
GoRouter createRouter() => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(path: 'magic-box', builder: (_, _) => const MagicBoxScreen()),
        GoRoute(path: 'sidebar', builder: (_, _) => const SidebarScreen()),
        GoRoute(path: 'counter', builder: (_, _) => const CounterScreen()),
        GoRoute(
          path: 'gallery',
          builder: (_, _) => const GalleryScreen(),
          routes: [
            GoRoute(
              path: ':id',
              // A link like /gallery/99 (no such product) goes back to the
              // grid instead of crashing.
              redirect: (context, state) {
                final id = int.tryParse(state.pathParameters['id']!);
                return id != null && products.any((p) => p.id == id)
                    ? null
                    : '/gallery';
              },
              // Day 68: our own transition instead of the platform's.
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: ProductScreen(
                  id: int.parse(state.pathParameters['id']!),
                ),
                transitionDuration: const Duration(milliseconds: 400),
                reverseTransitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: fadeScaleTransition,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Fades in while growing from 90% to full size. On the way back
/// (pop), the same animation runs in reverse.
Widget fadeScaleTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  // drive + CurveTween: safe to create in a builder (nothing to dispose),
  // unlike a CurvedAnimation, which adds a listener to its parent.
  final curved = animation.drive(CurveTween(curve: Curves.easeOutCubic));
  return FadeTransition(
    opacity: curved,
    child: ScaleTransition(
      scale: curved.drive(Tween<double>(begin: 0.9, end: 1)),
      child: child,
    ),
  );
}
