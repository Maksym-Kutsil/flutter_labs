import 'package:flutter/material.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/features/home/widgets/section_card.dart';

/// Read-only profile summary card displayed at the top of the home page.
class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({required this.user, super.key});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Name: ${user.name}'),
          Text('Email: ${user.email}'),
          Text('Pet: ${user.petName}'),
        ],
      ),
    );
  }
}
