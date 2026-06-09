import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/features/auth/login_page.dart';
import 'package:my_project/features/home/flashlight_actions.dart';
import 'package:my_project/features/profile/profile_page.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_project/presentation/cubits/bowl_entries/bowl_entries_cubit.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({required this.email, super.key});

  final String email;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  static const int _secretTapsRequired = 5;
  static const Duration _secretTapWindow = Duration(milliseconds: 1500);

  int _tapCount = 0;
  DateTime? _firstTapAt;

  void _onTitleTap() {
    final now = DateTime.now();
    final firstTap = _firstTapAt;
    if (firstTap == null || now.difference(firstTap) > _secretTapWindow) {
      _firstTapAt = now;
      _tapCount = 1;
      return;
    }
    _tapCount += 1;
    if (_tapCount < _secretTapsRequired) {
      return;
    }
    _tapCount = 0;
    _firstTapAt = null;
    FlashlightActions.secretToggle(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTitleTap,
        child: Text('Smart Bowl - ${widget.email}'),
      ),
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
