import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/features/home/widgets/bowl_entry_tile.dart';
import 'package:my_project/features/home/widgets/entry_editor_dialog.dart';
import 'package:my_project/features/home/widgets/section_card.dart';
import 'package:my_project/presentation/cubits/bowl_entries/bowl_entries_cubit.dart';
import 'package:my_project/presentation/cubits/bowl_entries/bowl_entries_state.dart';

/// Displays the list of bowl entries owned by [BowlEntriesCubit].
class BowlEntriesSection extends StatelessWidget {
  const BowlEntriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: BlocBuilder<BowlEntriesCubit, BowlEntriesState>(
        builder: (context, state) {
          if (state.status == BowlEntriesStatus.loading ||
              state.status == BowlEntriesStatus.initial) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.status == BowlEntriesStatus.error) {
            return Text(state.errorMessage ?? 'Failed to load entries');
          }
          return _BowlEntriesList(entries: state.entries);
        },
      ),
    );
  }
}

class _BowlEntriesList extends StatelessWidget {
  const _BowlEntriesList({required this.entries});

  final List<BowlEntry> entries;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BowlEntriesCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Feeding entries',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: entries.isEmpty ? null : cubit.clearEntries,
              child: const Text('Delete all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          const Text('No entries yet. Tap + to add.')
        else
          ...entries.map(
            (entry) => Column(
              children: [
                BowlEntryTile(
                  entry: entry,
                  onEdit: () => _editEntry(context, entry),
                  onDelete: () => cubit.deleteEntry(entry.id),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _editEntry(BuildContext context, BowlEntry entry) async {
    final updated = await showDialog<BowlEntry>(
      context: context,
      builder: (_) => EntryEditorDialog(initialEntry: entry),
    );
    if (updated == null || !context.mounted) {
      return;
    }
    await context.read<BowlEntriesCubit>().updateEntry(updated);
  }
}
