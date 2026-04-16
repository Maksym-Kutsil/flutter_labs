import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlSettingsPage extends StatefulWidget {
  const PetBowlSettingsPage({super.key});

  @override
  State<PetBowlSettingsPage> createState() => _PetBowlSettingsPageState();
}

class _PetBowlSettingsPageState extends State<PetBowlSettingsPage> {
  bool _mealReminders = true;
  bool _lowLevelAlerts = false;
  bool _connected = false;
  String _petName = 'Mittens';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PetBowlAppBar(title: 'Pet & device'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PetBowlCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(
                    Icons.pets_rounded,
                    size: 36,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _petName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Demo pet profile',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const PetBowlSectionHeader(
            title: 'Device',
            subtitle: 'Use mock controls to update device state.',
          ),
          PetBowlCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.wifi_rounded, color: scheme.primary),
                  title: const Text('Smart Pet Bowl · Kitchen'),
                  subtitle: Text(
                    _connected ? 'Connected' : 'Not connected',
                  ),
                  trailing: FilledButton(
                    onPressed: () {
                      setState(() {
                        _connected = !_connected;
                      });
                    },
                    child: Text(_connected ? 'Disconnect' : 'Connect'),
                  ),
                ),
                Divider(height: 1, color: scheme.outlineVariant),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.memory_rounded, color: scheme.primary),
                  title: const Text('Firmware'),
                  subtitle: Text(_connected ? 'v0.0.1-mock' : 'Unavailable'),
                  trailing: IconButton(
                    onPressed: () async {
                      final newName = await _showPetNameDialog();
                      if (!mounted || newName == null) {
                        return;
                      }
                      setState(() {
                        _petName = newName;
                      });
                    },
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: 'Rename pet',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const PetBowlSectionHeader(
            title: 'Notifications',
            subtitle: 'Toggles are visual placeholders.',
          ),
          PetBowlCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Meal reminders'),
                  subtitle: const Text('Notify before scheduled feed'),
                  value: _mealReminders,
                  onChanged: (value) {
                    setState(() {
                      _mealReminders = value;
                    });
                  },
                ),
                Divider(height: 1, color: scheme.outlineVariant),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Low food / water'),
                  subtitle: const Text('Alert when sensors report low'),
                  value: _lowLevelAlerts,
                  onChanged: (value) {
                    setState(() {
                      _lowLevelAlerts = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showPetNameDialog() async {
    final controller = TextEditingController(text: _petName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename pet'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Pet name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isEmpty) {
                  return;
                }
                Navigator.of(context).pop(value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }
}
