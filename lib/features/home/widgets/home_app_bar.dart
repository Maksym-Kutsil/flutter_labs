import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/features/auth/login_page.dart';
import 'package:my_project/features/profile/profile_page.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_project/presentation/cubits/bowl_entries/bowl_entries_cubit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({required this.email, super.key});

  final String email;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Smart Bowl - $email'),
      actions: [
        IconButton(
          onPressed: () => context.read<BowlEntriesCubit>().load(),
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh from API',
        ),
        IconButton(
          onPressed: () => _openProfile(context),
          icon: const Icon(Icons.person_rounded),
          tooltip: 'Edit profile',
        ),
        IconButton(
          onPressed: () => _confirmLogout(context),
          icon: const Icon(Icons.logout_rounded),
          tooltip: 'Logout',
        ),
      ],
    );
  }

  Future<void> _openProfile(BuildContext context) async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfilePage()));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm logout'),
        content: const Text('Sign out of this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await context.read<AuthCubit>().logout();
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}
