import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/features/auth/login_page.dart';
import 'package:my_project/features/home/widgets/bowl_entry_tile.dart';
import 'package:my_project/features/home/widgets/entry_editor_dialog.dart';
import 'package:my_project/features/home/widgets/section_card.dart';
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
  late AppUser _user;
  List<BowlEntry> _entries = <BowlEntry>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Bowl - ${_user.email}'),
        actions: [
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProfileCard(),
                const SizedBox(height: 16),
                _buildEntriesCard(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildProfileCard() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Name: ${_user.name}'),
          Text('Email: ${_user.email}'),
          Text('Pet: ${_user.petName}'),
        ],
      ),
    );
  }

  Widget _buildEntriesCard() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Feeding entries',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: _entries.isEmpty ? null : _clearEntries,
                child: const Text('Delete all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_entries.isEmpty)
            const Text('No entries yet. Tap + to add.')
          else
            ..._entries.map((entry) {
              return Column(
                children: [
                  BowlEntryTile(
                    entry: entry,
                    onEdit: () => _editEntry(entry),
                    onDelete: () => _deleteEntry(entry.id),
                  ),
                  const Divider(height: 1),
                ],
              );
            }),
        ],
      ),
    );
  }

  Future<void> _loadEntries() async {
    final entries = await widget.bowlEntryService.getEntries();
    if (!mounted) {
      return;
    }
    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  Future<void> _addEntry() async {
    final createdEntry = await _showEntryDialog();
    if (createdEntry == null) {
      return;
    }
    await widget.bowlEntryService.addEntry(createdEntry);
    await _loadEntries();
  }

  Future<void> _editEntry(BowlEntry entry) async {
    final updatedEntry = await _showEntryDialog(initialEntry: entry);
    if (updatedEntry == null) {
      return;
    }
    await widget.bowlEntryService.updateEntry(updatedEntry);
    await _loadEntries();
  }

  Future<BowlEntry?> _showEntryDialog({BowlEntry? initialEntry}) async {
    final result = await showDialog<BowlEntry>(
      context: context,
      builder: (context) {
        return EntryEditorDialog(initialEntry: initialEntry);
      },
    );
    return result;
  }

  Future<void> _deleteEntry(String id) async {
    await widget.bowlEntryService.deleteEntry(id);
    await _loadEntries();
  }

  Future<void> _clearEntries() async {
    await widget.bowlEntryService.clearEntries();
    await _loadEntries();
  }

  Future<void> _openEditProfile() async {
    final updatedUser = await Navigator.of(context).push<AppUser>(
      MaterialPageRoute<AppUser>(
        builder: (context) {
          return ProfilePage(authService: widget.authService, user: _user);
        },
      ),
    );
    if (!mounted || updatedUser == null) {
      return;
    }
    setState(() {
      _user = updatedUser;
    });
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm logout'),
          content: const Text(
            'Are you sure you want to log out? You will need to sign in '
            'again next time.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
    if (shouldLogout != true) {
      return;
    }

    await widget.authService.logout();
    await widget.mqttSensorService.disconnect();
    if (!mounted) {
      return;
    }
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => LoginPage(
          authService: widget.authService,
          bowlEntryService: widget.bowlEntryService,
          connectivityService: widget.connectivityService,
          mqttSensorService: widget.mqttSensorService,
        ),
      ),
      (route) => false,
    );
  }
}
