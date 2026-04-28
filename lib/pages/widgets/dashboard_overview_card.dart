import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';

class DashboardOverviewCard extends StatelessWidget {
  const DashboardOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PetBowlCard(
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                Icons.water_drop_rounded,
                size: 40,
                color: scheme.onPrimaryContainer,
              ),
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
                  avatar: Icon(Icons.circle, size: 12, color: scheme.tertiary),
                  label: const Text('Demo UI — no device'),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
