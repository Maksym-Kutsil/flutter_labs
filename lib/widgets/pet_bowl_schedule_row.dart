import 'package:flutter/material.dart';

class PetBowlScheduleRow extends StatelessWidget {
  const PetBowlScheduleRow({
    required this.timeLabel,
    required this.portionLabel,
    this.enabled = true,
    super.key,
  });

  final String timeLabel;
  final String portionLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: const Icon(Icons.schedule_rounded, size: 22),
      ),
      title: Text(timeLabel),
      subtitle: Text(portionLabel),
      trailing: Icon(
        Icons.pets_rounded,
        color: enabled ? scheme.primary : scheme.outline,
      ),
    );
  }
}
