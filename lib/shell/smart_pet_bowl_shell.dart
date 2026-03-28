import 'package:flutter/material.dart';
import 'package:my_project/pages/pet_bowl_dashboard_page.dart';
import 'package:my_project/pages/pet_bowl_history_page.dart';
import 'package:my_project/pages/pet_bowl_schedule_page.dart';
import 'package:my_project/pages/pet_bowl_settings_page.dart';

class SmartPetBowlShell extends StatefulWidget {
  const SmartPetBowlShell({super.key});

  @override
  State<SmartPetBowlShell> createState() => _SmartPetBowlShellState();
}

class _SmartPetBowlShellState extends State<SmartPetBowlShell> {
  int _index = 0;

  static const List<Widget> _pages = [
    PetBowlDashboardPage(),
    PetBowlSchedulePage(),
    PetBowlHistoryPage(),
    PetBowlSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
