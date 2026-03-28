import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_metric_tile.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlDashboardPage extends StatelessWidget {
  const PetBowlDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PetBowlAppBar(title: 'Smart Pet Bowl'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PetBowlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.water_drop_rounded,
                        size: 40,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bowl overview',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Chip(
                            avatar: Icon(
                              Icons.circle,
                              size: 12,
                              color: scheme.tertiary,
                            ),
                            label: const Text('Demo UI — no device'),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const PetBowlSectionHeader(
            title: 'At a glance',
            subtitle: 'Placeholder metrics for your pet’s bowl.',
          ),
          const PetBowlCard(
            child: Column(
              children: [
                PetBowlMetricTile(
                  icon: Icons.restaurant_rounded,
                  label: 'Portion today',
                  value: '120 g (demo)',
                ),
                Divider(height: 24),
                PetBowlMetricTile(
                  icon: Icons.opacity_rounded,
                  label: 'Water level',
                  value: 'Comfortable (demo)',
                ),
                Divider(height: 24),
                PetBowlMetricTile(
                  icon: Icons.event_repeat_rounded,
                  label: 'Next scheduled meal',
                  value: '18:00',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
