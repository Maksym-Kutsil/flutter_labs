import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/features/profile/widgets/profile_form.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: user == null
                ? const Center(child: CircularProgressIndicator())
                : ProfileForm(user: user),
          ),
        ),
      ),
    );
  }
}
