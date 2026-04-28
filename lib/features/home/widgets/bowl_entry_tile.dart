import 'package:flutter/material.dart';
import 'package:my_project/domain/models/bowl_entry.dart';

class BowlEntryTile extends StatelessWidget {
  const BowlEntryTile({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final BowlEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text('${entry.portionGrams}g')),
      title: Text(entry.title),
      subtitle: Text(entry.note.isEmpty ? 'No note' : entry.note),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_rounded),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
