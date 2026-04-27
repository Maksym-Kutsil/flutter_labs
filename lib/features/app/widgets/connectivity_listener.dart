import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/presentation/cubits/connectivity/connectivity_cubit.dart';

/// Watches the [ConnectivityCubit] and shows a snackbar when the network
/// status flips so the shell itself can stay simple.
class ConnectivityListener extends StatelessWidget {
  const ConnectivityListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, bool>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, isOnline) {
        final messenger = ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                isOnline
                    ? 'Internet connection restored.'
                    : 'Internet connection lost. Working offline.',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
      },
      child: child,
    );
  }
}
