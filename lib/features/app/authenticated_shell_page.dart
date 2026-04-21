import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/features/home/home_page.dart';
import 'package:my_project/features/sensor/sensor_page.dart';
import 'package:my_project/pages/pet_bowl_dashboard_page.dart';
import 'package:my_project/pages/pet_bowl_history_page.dart';
import 'package:my_project/pages/pet_bowl_schedule_page.dart';
import 'package:my_project/pages/pet_bowl_settings_page.dart';

class AuthenticatedShellPage extends StatefulWidget {
  const AuthenticatedShellPage({
    required this.authService,
    required this.bowlEntryService,
    required this.connectivityService,
    required this.mqttSensorService,
    required this.user,
    super.key,
  });

  final AuthService authService;
  final BowlEntryService bowlEntryService;
  final ConnectivityService connectivityService;
  final MqttSensorService mqttSensorService;
  final AppUser user;

  @override
  State<AuthenticatedShellPage> createState() => _AuthenticatedShellPageState();
}

class _AuthenticatedShellPageState extends State<AuthenticatedShellPage> {
  int _selectedIndex = 0;
  bool _isOnline = true;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _watchConnectivity();
  }

  Future<void> _watchConnectivity() async {
    _isOnline = await widget.connectivityService.isOnline();
    if (!mounted) {
      return;
    }
    setState(() {});
    _connectivitySubscription = widget.connectivityService.onlineStream.listen(
      _handleConnectivity,
    );
  }

  void _handleConnectivity(bool online) {
    if (!mounted || online == _isOnline) {
      return;
    }
    setState(() {
      _isOnline = online;
    });
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            online
                ? 'Internet connection restored.'
                : 'Internet connection lost. Working offline.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(
        authService: widget.authService,
        bowlEntryService: widget.bowlEntryService,
        connectivityService: widget.connectivityService,
        mqttSensorService: widget.mqttSensorService,
        user: widget.user,
      ),
      const PetBowlDashboardPage(),
      SensorPage(
        mqttSensorService: widget.mqttSensorService,
        isOnline: _isOnline,
      ),
      const PetBowlSchedulePage(),
      const PetBowlHistoryPage(),
      const PetBowlSettingsPage(),
    ];

    return Scaffold(
      body: Column(
        children: [
          if (!_isOnline)
            Material(
              color: Theme.of(context).colorScheme.errorContainer,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No internet connection. Some features are '
                          'unavailable.',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),
        ],
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
            icon: Icon(Icons.thermostat_outlined),
            selectedIcon: Icon(Icons.thermostat_rounded),
            label: 'Sensor',
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
