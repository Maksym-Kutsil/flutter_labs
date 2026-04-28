import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HistoryEvent extends Equatable {
  const HistoryEvent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String kind;

  @override
  List<Object?> get props => <Object?>[title, subtitle, icon, kind];
}

const List<HistoryEvent> kDefaultHistoryEvents = <HistoryEvent>[
  HistoryEvent(
    title: 'Meal dispensed',
    subtitle: 'Yesterday · 18:02 · 50 g',
    icon: Icons.restaurant_rounded,
    kind: 'meal',
  ),
  HistoryEvent(
    title: 'Water refill reminder',
    subtitle: 'Yesterday · 09:15',
    icon: Icons.water_drop_outlined,
    kind: 'water',
  ),
  HistoryEvent(
    title: 'Bowl cleaned (manual)',
    subtitle: 'Mon · 07:40',
    icon: Icons.cleaning_services_rounded,
    kind: 'care',
  ),
  HistoryEvent(
    title: 'Low food detected',
    subtitle: 'Sun · 20:11',
    icon: Icons.warning_amber_rounded,
    kind: 'alerts',
  ),
];
