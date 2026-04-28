import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/features/home/widgets/bowl_entries_section.dart';
import 'package:my_project/features/home/widgets/entry_editor_dialog.dart';
import 'package:my_project/features/home/widgets/home_app_bar.dart';
import 'package:my_project/features/home/widgets/profile_summary_card.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_project/presentation/cubits/auth/auth_state.dart';
import 'package:my_project/presentation/cubits/bowl_entries/bowl_entries_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: HomeAppBar(email: user.email),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ProfileSection(),
          SizedBox(height: 16),
          BowlEntriesSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEntry(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _addEntry(BuildContext context) async {
    final created = await showDialog<BowlEntry>(
      context: context,
      builder: (_) => const EntryEditorDialog(),
    );
    if (created == null || !context.mounted) {
      return;
    }
    await context.read<BowlEntriesCubit>().addEntry(created);
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        final user =
            state.user ?? const AppUser(name: '', email: '', petName: '');
        return ProfileSummaryCard(user: user);
      },
    );
  }
}
