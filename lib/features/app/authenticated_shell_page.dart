import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/features/app/widgets/connectivity_listener.dart';
import 'package:my_project/features/app/widgets/offline_banner.dart';
import 'package:my_project/features/app/widgets/shell_navigation_bar.dart';
import 'package:my_project/features/app/widgets/shell_pages.dart';
import 'package:my_project/presentation/cubits/bowl_entries/bowl_entries_cubit.dart';
import 'package:my_project/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:my_project/presentation/cubits/shell/shell_nav_cubit.dart';

class AuthenticatedShellPage extends StatelessWidget {
  const AuthenticatedShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShellNavCubit>(create: (_) => ShellNavCubit()),
        BlocProvider<BowlEntriesCubit>(
          create: (context) =>
              BowlEntriesCubit(context.read<BowlEntryService>())..load(),
        ),
      ],
      child: const ConnectivityListener(child: _ShellScaffold()),
    );
  }
}

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold();

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityCubit>().state;
    final selectedIndex = context.watch<ShellNavCubit>().state;
    return Scaffold(
      body: Column(
        children: [
          if (!isOnline) const OfflineBanner(),
          Expanded(
            child: IndexedStack(index: selectedIndex, children: kShellPages),
          ),
        ],
      ),
      bottomNavigationBar: ShellNavigationBar(
        selectedIndex: selectedIndex,
        onSelect: context.read<ShellNavCubit>().select,
      ),
    );
  }
}
