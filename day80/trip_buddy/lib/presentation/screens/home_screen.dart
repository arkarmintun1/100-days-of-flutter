import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'itinerary_screen.dart';
import 'memory_screen.dart';

/// Day 79: the vault and the chat, as two tabs. Day 80: the itinerary.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps both tabs alive: the chat isn't lost when you
      // look at your documents.
      body: IndexedStack(
        index: _tab,
        children: const [MemoryScreen(), ChatScreen(), ItineraryScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (tab) => setState(() => _tab = tab),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage),
            label: 'Trip',
          ),
        ],
      ),
    );
  }
}
