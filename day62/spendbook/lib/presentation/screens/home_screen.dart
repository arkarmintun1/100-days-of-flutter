import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'expenses_screen.dart';

/// Two tabs: the list and the dashboard. Both use the same month filter.
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
      // IndexedStack keeps both tabs alive, with their scroll positions.
      body: IndexedStack(
        index: _tab,
        children: const [ExpensesScreen(), DashboardScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (tab) => setState(() => _tab = tab),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Expenses'),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
