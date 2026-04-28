import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/pages/widgets/settings_device_card.dart';
import 'package:my_project/pages/widgets/settings_notifications_card.dart';
import 'package:my_project/pages/widgets/settings_pet_card.dart';
import 'package:my_project/presentation/cubits/settings/settings_cubit.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlSettingsPage extends StatelessWidget {
  const PetBowlSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        appBar: const PetBowlAppBar(title: 'Pet & device'),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SettingsPetCard(),
            SizedBox(height: 20),
            PetBowlSectionHeader(
              title: 'Device',
              subtitle: 'Use mock controls to update device state.',
            ),
            SettingsDeviceCard(),
            SizedBox(height: 20),
            PetBowlSectionHeader(
              title: 'Notifications',
              subtitle: 'Toggles are visual placeholders.',
            ),
            SettingsNotificationsCard(),
          ],
        ),
      ),
    );
  }
}
