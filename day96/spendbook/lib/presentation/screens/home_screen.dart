import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n.dart';
import '../providers/dependencies.dart';
import 'assistant_screen.dart';
import 'dashboard_screen.dart';
import 'expenses_screen.dart';

/// Two tabs: the list and the dashboard. Both use the same month filter.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _tab = 0;

  @override
  Widget build(BuildContext context) {
    // Day 73: a third tab when AI is on.
    final ai = ref.watch(aiEnabledProvider);
    return Scaffold(
      // IndexedStack keeps both tabs alive, with their scroll positions.
      body: IndexedStack(
        index: _tab,
        children: [
          const ExpensesScreen(),
          const DashboardScreen(),
          if (ai) const AssistantScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (tab) => setState(() => _tab = tab),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list_alt),
            label: context.l10n.navExpenses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: context.l10n.navDashboard,
          ),
          if (ai)
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon: const Icon(Icons.auto_awesome),
              label: context.l10n.navAsk,
            ),
        ],
      ),
    );
  }
}
