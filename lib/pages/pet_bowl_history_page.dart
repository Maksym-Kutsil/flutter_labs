import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/pages/widgets/history_actions.dart';
import 'package:my_project/pages/widgets/history_filter_chips.dart';
import 'package:my_project/pages/widgets/history_list.dart';
import 'package:my_project/presentation/cubits/history/history_cubit.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlHistoryPage extends StatelessWidget {
  const PetBowlHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (_) => HistoryCubit(),
      child: Scaffold(
        appBar: const PetBowlAppBar(title: 'Activity log'),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            PetBowlSectionHeader(
              title: 'Recent events',
              subtitle: 'Use filters and clear log actions.',
            ),
            HistoryFilterChips(),
            SizedBox(height: 12),
            HistoryList(),
            SizedBox(height: 12),
            HistoryActions(),
          ],
        ),
      ),
    );
  }
}
