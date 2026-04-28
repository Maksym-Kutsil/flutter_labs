import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/schedule/schedule_cubit.dart';
import 'package:my_project/presentation/cubits/schedule/schedule_state.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_schedule_row.dart';

class WeekendSnackCard extends StatelessWidget {
  const WeekendSnackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleCubit>();
        return PetBowlCard(
          child: Column(
            children: [
              PetBowlScheduleRow(
                timeLabel: '21:00 · Sat & Sun',
                portionLabel: 'Light snack · ${state.extraPortion} g',
                enabled: state.weekendSnackEnabled,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable weekend snack'),
                value: state.weekendSnackEnabled,
                onChanged: cubit.setWeekendSnackEnabled,
              ),
              Slider(
                value: state.extraPortion.toDouble(),
                min: 5,
                max: 40,
                divisions: 7,
                label: '${state.extraPortion} g',
                onChanged: (value) => cubit.setExtraPortion(value.toInt()),
              ),
            ],
          ),
        );
      },
    );
  }
}
