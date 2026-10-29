import 'package:flutter/material.dart';

/// A sidebar that slides in over the content, with a dimmed background.
class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  var _open = false;

  static const width = 260.0;
  static const duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sidebar'),
        leading: IconButton(
          tooltip: _open ? 'Close menu' : 'Open menu',
          icon: Icon(_open ? Icons.close : Icons.menu),
          onPressed: () => setState(() => _open = !_open),
        ),
      ),
      body: Stack(
        children: [
          const Center(child: Text('The page content')),
          // The scrim: fades in, and closes the menu when tapped.
          IgnorePointer(
            ignoring: !_open,
            child: GestureDetector(
              onTap: () => setState(() => _open = false),
              child: AnimatedOpacity(
                opacity: _open ? 1 : 0,
                duration: duration,
                child: Container(color: Colors.black54),
              ),
            ),
          ),
          // The sidebar: slides from off screen (left: -width) to 0.
          AnimatedPositioned(
            duration: duration,
            curve: Curves.easeOutCubic,
            top: 0,
            bottom: 0,
            left: _open ? 0 : -width,
            width: width,
            child: Material(
              color: colors.surfaceContainer,
              elevation: 8,
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.home), title: Text('Home')),
                  ListTile(leading: Icon(Icons.star), title: Text('Favorites')),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
