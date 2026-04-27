import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/features/app/authenticated_shell_page.dart';
import 'package:my_project/features/auth/login_page.dart';
import 'package:my_project/features/bootstrap/widgets/bootstrap_loader.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_project/presentation/cubits/bootstrap/bootstrap_cubit.dart';
import 'package:my_project/presentation/cubits/bootstrap/bootstrap_state.dart';

/// Decides on app start whether to show the login screen or jump straight
/// into the authenticated shell using the persisted session. Auto-login is
/// the only place where the auth service is consulted directly outside of a
/// state-management container (allowed by the lab requirements).
class BootstrapPage extends StatelessWidget {
  const BootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BootstrapCubit>(
      create: (context) => BootstrapCubit(
        authService: context.read<AuthService>(),
        connectivityService: context.read<ConnectivityService>(),
      )..start(),
      child: BlocListener<BootstrapCubit, BootstrapState>(
        listener: _onBootstrapStateChanged,
        child: const BootstrapLoader(),
      ),
    );
  }

  void _onBootstrapStateChanged(BuildContext context, BootstrapState state) {
    switch (state.status) {
      case BootstrapStatus.loading:
        return;
      case BootstrapStatus.goLogin:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const LoginPage()),
        );
      case BootstrapStatus.goShell:
        final user = state.user;
        if (user == null) {
          return;
        }
        context.read<AuthCubit>().seedUser(user);
        if (state.showOfflineWarning) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Offline mode: auto-login succeeded but some features '
                'are unavailable.',
              ),
            ),
          );
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const AuthenticatedShellPage(),
          ),
        );
    }
  }
}
