import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/history/history_cubit.dart';
import 'package:my_project/presentation/cubits/history/history_state.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_history_tile.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final visible = state.visibleEvents;
        return PetBowlCard(
          child: Column(
            children: [
              if (visible.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No events for this filter.'),
                )
              else
                ...visible.map((event) {
                  final isLast = visible.last == event;
                  return Column(
                    children: [
                      PetBowlHistoryTile(
                        title: event.title,
                        subtitle: event.subtitle,
                        icon: event.icon,
                      ),
                      if (!isLast) const Divider(height: 1),
                    ],
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
