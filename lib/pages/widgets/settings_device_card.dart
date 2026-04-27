import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/pages/widgets/rename_pet_dialog.dart';
import 'package:my_project/presentation/cubits/settings/settings_cubit.dart';
import 'package:my_project/presentation/cubits/settings/settings_state.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';

class SettingsDeviceCard extends StatelessWidget {
  const SettingsDeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.connected != current.connected ||
          previous.petName != current.petName,
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        return PetBowlCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.wifi_rounded, color: scheme.primary),
                title: const Text('Smart Pet Bowl · Kitchen'),
                subtitle: Text(state.connected ? 'Connected' : 'Not connected'),
                trailing: FilledButton(
                  onPressed: cubit.toggleConnected,
                  child: Text(state.connected ? 'Disconnect' : 'Connect'),
                ),
              ),
              Divider(height: 1, color: scheme.outlineVariant),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.memory_rounded, color: scheme.primary),
                title: const Text('Firmware'),
                subtitle: Text(state.connected ? 'v0.0.1-mock' : 'Unavailable'),
                trailing: IconButton(
                  onPressed: () => _renamePet(context, state.petName),
                  icon: const Icon(Icons.edit_rounded),
                  tooltip: 'Rename pet',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _renamePet(BuildContext context, String currentName) async {
    final newName = await showRenamePetDialog(
      context: context,
      initialName: currentName,
    );
    if (newName == null || !context.mounted) {
      return;
    }
    context.read<SettingsCubit>().renamePet(newName);
  }
}
