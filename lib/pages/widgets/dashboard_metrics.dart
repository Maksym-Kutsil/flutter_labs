import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:my_project/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:my_project/widgets/pet_bowl_metric_tile.dart';

class DashboardMetrics extends StatelessWidget {
  const DashboardMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Column(
          children: [
            PetBowlMetricTile(
              icon: Icons.restaurant_rounded,
              label: 'Portion today',
              value: '${state.portionToday} g',
            ),
            const Divider(height: 24),
            PetBowlMetricTile(
              icon: Icons.opacity_rounded,
              label: 'Water level',
              value: state.waterLabel,
            ),
          ],
        );
      },
    );
  }
}
