import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/settings/settings_cubit.dart';
import 'package:my_project/presentation/cubits/settings/settings_state.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';

class SettingsPetCard extends StatelessWidget {
  const SettingsPetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => previous.petName != current.petName,
      builder: (context, state) {
        return PetBowlCard(
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
                      state.petName,
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
        );
      },
    );
  }
}
