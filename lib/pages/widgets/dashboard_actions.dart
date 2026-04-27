import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/dashboard/dashboard_cubit.dart';

class DashboardActions extends StatelessWidget {
  const DashboardActions({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: cubit.feed,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Feed +10g'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: cubit.useWater,
                icon: const Icon(Icons.water_drop_outlined),
                label: const Text('Use water'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: cubit.refillWater,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refill water'),
          ),
        ),
      ],
    );
  }
}
