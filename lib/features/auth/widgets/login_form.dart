import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/validation/input_validators.dart';
import 'package:my_project/features/app/authenticated_shell_page.dart';
import 'package:my_project/features/auth/register_page.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_project/presentation/cubits/auth/auth_state.dart';
import 'package:my_project/presentation/cubits/connectivity/connectivity_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: _onAuthState,
      builder: (context, state) {
        final isBusy = state.isBusy;
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    InputValidators.validateEmail(value ?? ''),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    InputValidators.validatePassword(value ?? ''),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isBusy ? null : _submit,
                  child: Text(isBusy ? 'Checking...' : 'Login'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _openRegistration,
                child: const Text('Create local account'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    final connectivity = context.read<ConnectivityCubit>();
    await connectivity.refresh();
    if (!mounted) {
      return;
    }
    if (!connectivity.state) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No internet connection. Please connect and try again.',
          ),
        ),
      );
      return;
    }
    await context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void _onAuthState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.failure && state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      return;
    }
    if (state.status == AuthStatus.authenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AuthenticatedShellPage()),
      );
    }
  }

  Future<void> _openRegistration() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RegisterPage()));
  }
}
