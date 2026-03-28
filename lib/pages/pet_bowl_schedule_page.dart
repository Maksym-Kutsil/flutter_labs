import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_schedule_row.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlSchedulePage extends StatelessWidget {
  const PetBowlSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PetBowlAppBar(title: 'Feeding schedule'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PetBowlSectionHeader(
            title: 'Daily meals',
            subtitle: 'Static preview — timers not active.',
          ),
          const PetBowlCard(
            child: Column(
              children: [
                PetBowlScheduleRow(
                  timeLabel: '08:00',
                  portionLabel: 'Breakfast · 40 g dry food',
                ),
                Divider(height: 1),
                PetBowlScheduleRow(
                  timeLabel: '13:00',
                  portionLabel: 'Lunch · 30 g dry food',
                ),
                Divider(height: 1),
                PetBowlScheduleRow(
                  timeLabel: '18:00',
                  portionLabel: 'Dinner · 50 g dry food',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const PetBowlSectionHeader(
            title: 'Weekend tweak',
            subtitle: 'Optional second dinner on Sat/Sun (UI only).',
          ),
          const PetBowlCard(
            child: Column(
              children: [
                PetBowlScheduleRow(
                  timeLabel: '21:00 · Sat & Sun',
                  portionLabel: 'Light snack · 15 g',
                  enabled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
