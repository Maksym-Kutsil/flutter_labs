import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/history/history_cubit.dart';
import 'package:my_project/presentation/cubits/history/history_state.dart';

class HistoryFilterChips extends StatelessWidget {
  const HistoryFilterChips({super.key});

  static const List<_FilterOption> _options = <_FilterOption>[
    _FilterOption(id: 'all', label: 'All'),
    _FilterOption(id: 'meal', label: 'Meals'),
    _FilterOption(id: 'water', label: 'Water'),
    _FilterOption(id: 'alerts', label: 'Alerts'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      buildWhen: (previous, current) => previous.filter != current.filter,
      builder: (context, state) {
        final cubit = context.read<HistoryCubit>();
        return Wrap(
          spacing: 8,
          children: _options.map((option) {
            return ChoiceChip(
              label: Text(option.label),
              selected: state.filter == option.id,
              onSelected: (_) => cubit.setFilter(option.id),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.id, required this.label});

  final String id;
  final String label;
}
