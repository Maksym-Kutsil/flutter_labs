import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_metric_tile.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlDashboardPage extends StatefulWidget {
  const PetBowlDashboardPage({super.key});

  @override
  State<PetBowlDashboardPage> createState() => _PetBowlDashboardPageState();
}

class _PetBowlDashboardPageState extends State<PetBowlDashboardPage> {
  int _portionToday = 120;
  int _waterLevel = 70;

  String get _waterLabel {
    if (_waterLevel > 65) {
      return 'Comfortable ($_waterLevel%)';
    }
    if (_waterLevel > 35) {
      return 'Moderate ($_waterLevel%)';
    }
    return 'Low ($_waterLevel%)';
  }

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
            subtitle: 'Quick actions update these metrics.',
          ),
          PetBowlCard(
            child: Column(
              children: [
                PetBowlMetricTile(
                  icon: Icons.restaurant_rounded,
                  label: 'Portion today',
                  value: '$_portionToday g',
                ),
                const Divider(height: 24),
                PetBowlMetricTile(
                  icon: Icons.opacity_rounded,
                  label: 'Water level',
                  value: _waterLabel,
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _portionToday += 10;
                          });
                        },
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Feed +10g'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _waterLevel = (_waterLevel - 10).clamp(0, 100);
                          });
                        },
                        icon: const Icon(Icons.water_drop_outlined),
                        label: const Text('Use water'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _waterLevel = 100;
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Refill water'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
