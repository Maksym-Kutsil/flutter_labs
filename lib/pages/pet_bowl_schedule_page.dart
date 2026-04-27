import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/pages/widgets/weekend_snack_card.dart';
import 'package:my_project/presentation/cubits/schedule/schedule_cubit.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_schedule_row.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlSchedulePage extends StatelessWidget {
  const PetBowlSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleCubit>(
      create: (_) => ScheduleCubit(),
      child: Scaffold(
        appBar: const PetBowlAppBar(title: 'Feeding schedule'),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            PetBowlSectionHeader(
              title: 'Daily meals',
              subtitle: 'Simulate schedule adjustments for this week.',
            ),
            PetBowlCard(
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
            SizedBox(height: 20),
            PetBowlSectionHeader(
              title: 'Weekend tweak',
              subtitle: 'Enable or update optional snack portion.',
            ),
            WeekendSnackCard(),
          ],
        ),
      ),
    );
  }
}
