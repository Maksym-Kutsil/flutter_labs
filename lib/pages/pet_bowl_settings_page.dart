import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlSettingsPage extends StatelessWidget {
  const PetBowlSettingsPage({super.key});

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
                        'Mittens',
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
            subtitle: 'Labels only — pairing comes later.',
          ),
          PetBowlCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.wifi_rounded, color: scheme.primary),
                  title: const Text('Smart Pet Bowl · Kitchen'),
                  subtitle: const Text('Not connected (mock)'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
                Divider(height: 1, color: scheme.outlineVariant),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.memory_rounded, color: scheme.primary),
                  title: const Text('Firmware'),
                  subtitle: const Text('v0.0.0-demo'),
                  trailing: const Icon(Icons.chevron_right_rounded),
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
                const SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Meal reminders'),
                  subtitle: Text('Notify before scheduled feed'),
                  value: true,
                  onChanged: null,
                ),
                Divider(height: 1, color: scheme.outlineVariant),
                const SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Low food / water'),
                  subtitle: Text('Alert when sensors report low'),
                  value: false,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
