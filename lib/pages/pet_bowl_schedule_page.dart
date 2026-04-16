import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_schedule_row.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlSchedulePage extends StatefulWidget {
  const PetBowlSchedulePage({super.key});

  @override
  State<PetBowlSchedulePage> createState() => _PetBowlSchedulePageState();
}

class _PetBowlSchedulePageState extends State<PetBowlSchedulePage> {
  bool _weekendSnackEnabled = false;
  int _extraPortion = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PetBowlAppBar(title: 'Feeding schedule'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PetBowlSectionHeader(
            title: 'Daily meals',
            subtitle: 'Simulate schedule adjustments for this week.',
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
            subtitle: 'Enable or update optional snack portion.',
          ),
          PetBowlCard(
            child: Column(
              children: [
                PetBowlScheduleRow(
                  timeLabel: '21:00 · Sat & Sun',
                  portionLabel: 'Light snack · $_extraPortion g',
                  enabled: _weekendSnackEnabled,
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Enable weekend snack'),
                  value: _weekendSnackEnabled,
                  onChanged: (value) {
                    setState(() {
                      _weekendSnackEnabled = value;
                    });
                  },
                ),
                Slider(
                  value: _extraPortion.toDouble(),
                  min: 5,
                  max: 40,
                  divisions: 7,
                  label: '$_extraPortion g',
                  onChanged: (value) {
                    setState(() {
                      _extraPortion = value.toInt();
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
}
