import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/pages/widgets/dashboard_actions.dart';
import 'package:my_project/pages/widgets/dashboard_metrics.dart';
import 'package:my_project/pages/widgets/dashboard_overview_card.dart';
import 'package:my_project/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlDashboardPage extends StatelessWidget {
  const PetBowlDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => DashboardCubit(),
      child: Scaffold(
        appBar: const PetBowlAppBar(title: 'Smart Pet Bowl'),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            DashboardOverviewCard(),
            SizedBox(height: 20),
            PetBowlSectionHeader(
              title: 'At a glance',
              subtitle: 'Quick actions update these metrics.',
            ),
            PetBowlCard(
              child: Column(
                children: [
                  DashboardMetrics(),
                  Divider(height: 24),
                  DashboardActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
