import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/features/home/home_actions.dart';
import 'package:my_project/features/home/widgets/bowl_entries_section.dart';
import 'package:my_project/features/home/widgets/profile_summary_card.dart';
import 'package:my_project/features/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppUser _user = widget.user;
  late final HomeActions _actions = HomeActions(
    authService: widget.authService,
    bowlEntryService: widget.bowlEntryService,
    connectivityService: widget.connectivityService,
    mqttSensorService: widget.mqttSensorService,
  );
  Object _refreshToken = Object();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Bowl - ${_user.email}'),
        actions: [
          IconButton(
            onPressed: _refreshEntries,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh from API',
          ),
          IconButton(
            onPressed: _openEditProfile,
            icon: const Icon(Icons.person_rounded),
            tooltip: 'Edit profile',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfileSummaryCard(user: _user),
          const SizedBox(height: 16),
          BowlEntriesSection(
            bowlEntryService: widget.bowlEntryService,
            refreshToken: _refreshToken,
            onEdit: _editEntry,
            onDelete: _deleteEntry,
            onClear: _clearEntries,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _refreshEntries() {
    setState(() {
      _refreshToken = Object();
    });
  }

  Future<void> _addEntry() async {
    final created = await _actions.showEntryDialog(context);
    if (created == null) {
      return;
    }
    await widget.bowlEntryService.addEntry(created);
    _refreshEntries();
  }

  Future<void> _editEntry(BowlEntry entry) async {
    final updated = await _actions.showEntryDialog(
      context,
      initialEntry: entry,
    );
    if (updated == null) {
      return;
    }
    await widget.bowlEntryService.updateEntry(updated);
    _refreshEntries();
  }

  Future<void> _deleteEntry(String id) async {
    await widget.bowlEntryService.deleteEntry(id);
    _refreshEntries();
  }

  Future<void> _clearEntries() async {
    await widget.bowlEntryService.clearEntries();
    _refreshEntries();
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.of(context).push<AppUser>(
      MaterialPageRoute<AppUser>(
        builder: (context) =>
            ProfilePage(authService: widget.authService, user: _user),
      ),
    );
    if (!mounted || updated == null) {
      return;
    }
    setState(() => _user = updated);
  }

  Future<void> _logout() async {
    final confirmed = await _actions.confirmLogout(context);
    if (!confirmed || !mounted) {
      return;
    }
    await _actions.performLogout(context);
  }
}
