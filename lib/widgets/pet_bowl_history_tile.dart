import 'package:flutter/material.dart';

class PetBowlHistoryTile extends StatelessWidget {
  const PetBowlHistoryTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: Icon(icon, size: 22),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
