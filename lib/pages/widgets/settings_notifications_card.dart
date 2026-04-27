import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/settings/settings_cubit.dart';
import 'package:my_project/presentation/cubits/settings/settings_state.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';

class SettingsNotificationsCard extends StatelessWidget {
  const SettingsNotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.mealReminders != current.mealReminders ||
          previous.lowLevelAlerts != current.lowLevelAlerts,
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        return PetBowlCard(
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Meal reminders'),
                subtitle: const Text('Notify before scheduled feed'),
                value: state.mealReminders,
                onChanged: cubit.toggleMealReminders,
              ),
              Divider(height: 1, color: scheme.outlineVariant),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Low food / water'),
                subtitle: const Text('Alert when sensors report low'),
                value: state.lowLevelAlerts,
                onChanged: cubit.toggleLowLevelAlerts,
              ),
            ],
          ),
        );
      },
    );
  }
}
