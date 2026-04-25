import 'package:flutter/material.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/features/home/widgets/bowl_entry_tile.dart';
import 'package:my_project/features/home/widgets/section_card.dart';

/// Displays the list of bowl entries fetched from the [BowlEntryService].
///
/// Uses a [FutureBuilder] so loading and error states are handled
/// declaratively. Pass a new [refreshToken] to force a refetch (the future
/// is re-created whenever the token changes).
class BowlEntriesSection extends StatefulWidget {
  const BowlEntriesSection({
    required this.bowlEntryService,
    required this.refreshToken,
    required this.onEdit,
    required this.onDelete,
    required this.onClear,
    super.key,
  });

  final BowlEntryService bowlEntryService;
  final Object refreshToken;
  final ValueChanged<BowlEntry> onEdit;
  final ValueChanged<String> onDelete;
  final VoidCallback onClear;

  @override
  State<BowlEntriesSection> createState() => _BowlEntriesSectionState();
}

class _BowlEntriesSectionState extends State<BowlEntriesSection> {
  late Future<List<BowlEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.bowlEntryService.getEntries();
  }

  @override
  void didUpdateWidget(covariant BowlEntriesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _future = widget.bowlEntryService.getEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: FutureBuilder<List<BowlEntry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Text('Failed to load entries: ${snapshot.error}');
          }
          final entries = snapshot.data ?? <BowlEntry>[];
          return _buildContent(context, entries);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<BowlEntry> entries) {
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
              onPressed: entries.isEmpty ? null : widget.onClear,
              child: const Text('Delete all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          const Text('No entries yet. Tap + to add.')
        else
          ...entries.map((entry) {
            return Column(
              children: [
                BowlEntryTile(
                  entry: entry,
                  onEdit: () => widget.onEdit(entry),
                  onDelete: () => widget.onDelete(entry.id),
                ),
                const Divider(height: 1),
              ],
            );
          }),
      ],
    );
  }
}
