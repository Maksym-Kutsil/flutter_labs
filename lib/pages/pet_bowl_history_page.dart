import 'package:flutter/material.dart';
import 'package:my_project/widgets/pet_bowl_app_bar.dart';
import 'package:my_project/widgets/pet_bowl_card.dart';
import 'package:my_project/widgets/pet_bowl_history_tile.dart';
import 'package:my_project/widgets/pet_bowl_section_header.dart';

class PetBowlHistoryPage extends StatefulWidget {
  const PetBowlHistoryPage({super.key});

  @override
  State<PetBowlHistoryPage> createState() => _PetBowlHistoryPageState();
}

class _PetBowlHistoryPageState extends State<PetBowlHistoryPage> {
  final List<_HistoryEvent> _events = <_HistoryEvent>[
    const _HistoryEvent(
      title: 'Meal dispensed',
      subtitle: 'Yesterday · 18:02 · 50 g',
      icon: Icons.restaurant_rounded,
      kind: 'meal',
    ),
    const _HistoryEvent(
      title: 'Water refill reminder',
      subtitle: 'Yesterday · 09:15',
      icon: Icons.water_drop_outlined,
      kind: 'water',
    ),
    const _HistoryEvent(
      title: 'Bowl cleaned (manual)',
      subtitle: 'Mon · 07:40',
      icon: Icons.cleaning_services_rounded,
      kind: 'care',
    ),
    const _HistoryEvent(
      title: 'Low food detected',
      subtitle: 'Sun · 20:11',
      icon: Icons.warning_amber_rounded,
      kind: 'alerts',
    ),
  ];
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final visibleEvents = _events.where((event) {
      if (_selectedFilter == 'all') {
        return true;
      }
      return event.kind == _selectedFilter;
    }).toList();

    return Scaffold(
      appBar: const PetBowlAppBar(title: 'Activity log'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PetBowlSectionHeader(
            title: 'Recent events',
            subtitle: 'Use filters and clear log actions.',
          ),
          Wrap(
            spacing: 8,
            children: [
              _filterChip('all', 'All'),
              _filterChip('meal', 'Meals'),
              _filterChip('water', 'Water'),
              _filterChip('alerts', 'Alerts'),
            ],
          ),
          const SizedBox(height: 12),
          PetBowlCard(
            child: Column(
              children: [
                if (visibleEvents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No events for this filter.'),
                  )
                else
                  ...visibleEvents.map((event) {
                    final isLast = visibleEvents.last == event;
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
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _events.isEmpty
                      ? null
                      : () => setState(_events.clear),
                  icon: const Icon(Icons.delete_sweep_rounded),
                  label: const Text('Clear log'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _events.isNotEmpty
                      ? null
                      : () {
                          setState(() => _events.addAll(_defaultEvents));
                        },
                  icon: const Icon(Icons.restore_rounded),
                  label: const Text('Restore demo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String id, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedFilter == id,
      onSelected: (_) {
        setState(() {
          _selectedFilter = id;
        });
      },
    );
  }
}

class _HistoryEvent {
  const _HistoryEvent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String kind;
}

const List<_HistoryEvent> _defaultEvents = <_HistoryEvent>[
  _HistoryEvent(
    title: 'Meal dispensed',
    subtitle: 'Yesterday · 18:02 · 50 g',
    icon: Icons.restaurant_rounded,
    kind: 'meal',
  ),
  _HistoryEvent(
    title: 'Water refill reminder',
    subtitle: 'Yesterday · 09:15',
    icon: Icons.water_drop_outlined,
    kind: 'water',
  ),
  _HistoryEvent(
    title: 'Bowl cleaned (manual)',
    subtitle: 'Mon · 07:40',
    icon: Icons.cleaning_services_rounded,
    kind: 'care',
  ),
  _HistoryEvent(
    title: 'Low food detected',
    subtitle: 'Sun · 20:11',
    icon: Icons.warning_amber_rounded,
    kind: 'alerts',
  ),
];
