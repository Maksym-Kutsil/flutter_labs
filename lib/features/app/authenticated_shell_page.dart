import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/features/home/home_page.dart';
import 'package:my_project/pages/pet_bowl_dashboard_page.dart';
import 'package:my_project/pages/pet_bowl_history_page.dart';
import 'package:my_project/pages/pet_bowl_schedule_page.dart';
import 'package:my_project/pages/pet_bowl_settings_page.dart';

class AuthenticatedShellPage extends StatefulWidget {
  const AuthenticatedShellPage({
    required this.authService,
    required this.bowlEntryService,
    required this.user,
    super.key,
  });

  final AuthService authService;
  final BowlEntryService bowlEntryService;
  final AppUser user;

  @override
  State<AuthenticatedShellPage> createState() => _AuthenticatedShellPageState();
}

class _AuthenticatedShellPageState extends State<AuthenticatedShellPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(
        authService: widget.authService,
        bowlEntryService: widget.bowlEntryService,
        user: widget.user,
      ),
      const PetBowlDashboardPage(),
      const PetBowlSchedulePage(),
      const PetBowlHistoryPage(),
      const PetBowlSettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt_rounded),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Overview',
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
