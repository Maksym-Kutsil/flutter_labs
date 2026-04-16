import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_history_tile.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlHistoryPage extends StatelessWidget {
  const PetBowlHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PetBowlAppBar(title: 'Activity log'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PetBowlSectionHeader(
            title: 'Recent events',
            subtitle: 'Sample history rows — no real sensor data.',
          ),
          const PetBowlCard(
            child: Column(
              children: [
                PetBowlHistoryTile(
                  title: 'Meal dispensed',
                  subtitle: 'Yesterday · 18:02 · 50 g',
                  icon: Icons.restaurant_rounded,
                ),
                Divider(height: 1),
                PetBowlHistoryTile(
                  title: 'Water refill reminder',
                  subtitle: 'Yesterday · 09:15',
                  icon: Icons.water_drop_outlined,
                ),
                Divider(height: 1),
                PetBowlHistoryTile(
                  title: 'Bowl cleaned (manual)',
                  subtitle: 'Mon · 07:40',
                  icon: Icons.cleaning_services_rounded,
                ),
                Divider(height: 1),
                PetBowlHistoryTile(
                  title: 'Low food detected',
                  subtitle: 'Sun · 20:11',
                  icon: Icons.warning_amber_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
