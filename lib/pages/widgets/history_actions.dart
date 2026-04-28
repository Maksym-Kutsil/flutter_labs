import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/history/history_cubit.dart';
import 'package:my_project/presentation/cubits/history/history_state.dart';

class HistoryActions extends StatelessWidget {
  const HistoryActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      buildWhen: (previous, current) =>
          previous.events.isEmpty != current.events.isEmpty,
      builder: (context, state) {
        final cubit = context.read<HistoryCubit>();
        final hasEvents = state.events.isNotEmpty;
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: hasEvents ? cubit.clear : null,
                icon: const Icon(Icons.delete_sweep_rounded),
                label: const Text('Clear log'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: hasEvents ? null : cubit.restore,
                icon: const Icon(Icons.restore_rounded),
                label: const Text('Restore demo'),
              ),
            ),
          ],
        );
      },
    );
  }
}
