import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/screens/bookmarks_screen.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/screens/not_found_screen.dart';
import 'package:pixly/screens/photo_loader_screen.dart';
import 'package:pixly/screens/search_screen.dart';
import 'package:pixly/widgets/scaffold_with_nav_bar.dart';

/// Every URL Pixly understands, in one place.
abstract final class AppRoutes {
  static const home = '/';
  static const search = '/search';
  static const bookmarks = '/bookmarks';

  static String photo(int id) => '/photo/$id';
  static String searchPhoto(int id) => '/search/photo/$id';
  static String bookmarkPhoto(int id) => '/bookmarks/photo/$id';
}

GoRouter createRouter({String initialLocation = AppRoutes.home}) {
  return GoRouter(
    initialLocation: initialLocation,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  // Child route: /photo/123 sits on top of the home screen.
                  _photoRoute(),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
                routes: [
                  // /search/photo/123: the search tab keeps its own stack.
                  _photoRoute(),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookmarks,
                builder: (context, state) => const BookmarksScreen(),
                routes: [_photoRoute()],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// The detail route, used as a child of every tab.
GoRoute _photoRoute() {
  return GoRoute(
    path: 'photo/:id',
    builder: (context, state) {
      final id = int.tryParse(state.pathParameters['id']!);
      if (id == null) return const NotFoundScreen();
      final extra = state.extra;
      return PhotoLoaderScreen(
        // A new key for a new id, so /photo/1 -> /photo/2
        // builds a fresh screen instead of reusing the old one.
        key: ValueKey(id),
        id: id,
        // Only a Photo when we passed one. A restored browser history
        // entry can give back a decoded map instead, so check the type.
        photo: extra is Photo ? extra : null,
      );
    },
  );
}
