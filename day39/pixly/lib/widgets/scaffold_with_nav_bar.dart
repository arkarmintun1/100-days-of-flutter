import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixly/config/breakpoints.dart';

/// One tab: the same data feeds the bottom bar and the side rail.
typedef _Destination = ({IconData icon, IconData selectedIcon, String label});

const List<_Destination> _destinations = [
  (
    icon: Icons.photo_library_outlined,
    selectedIcon: Icons.photo_library,
    label: 'Home',
  ),
  (icon: Icons.search, selectedIcon: Icons.search, label: 'Search'),
  (
    icon: Icons.bookmark_border,
    selectedIcon: Icons.bookmark,
    label: 'Bookmarks',
  ),
];

/// The navigation shared by the three tabs: a bottom bar on phones, a rail
/// on the side when the window is wider.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onSelected(int index) {
    navigationShell.goBranch(
      index,
      // Tapping the tab you're already on goes back to its first screen.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // sizeOf only rebuilds this widget when the size changes, not when
    // other MediaQuery values (like the keyboard insets) change.
    final width = MediaQuery.sizeOf(context).width;

    if (width < Breakpoints.medium) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onSelected,
          destinations: [
            for (final d in _destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    // Wide enough: labels next to the icons (expanded) or under them.
    final extended = width >= Breakpoints.expanded;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onSelected,
            extended: extended,
            // Short windows (e.g. a phone in landscape): scroll instead of
            // overflowing.
            scrollable: true,
            // An extended rail already shows its labels; labelType must
            // then be none (or null).
            labelType: extended ? .none : .all,
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
