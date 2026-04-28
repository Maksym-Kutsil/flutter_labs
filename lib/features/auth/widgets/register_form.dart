import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/validation/input_validators.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _petNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Your name'),
            validator: (value) => InputValidators.validateName(value ?? ''),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) => InputValidators.validateEmail(value ?? ''),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _petNameController,
            decoration: const InputDecoration(labelText: 'Pet name'),
            validator: (value) => InputValidators.validateName(value ?? ''),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => InputValidators.validatePassword(value ?? ''),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSaving ? null : _submit,
              child: Text(_isSaving ? 'Saving...' : 'Create account'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isSaving = true);
    final user = AppUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      petName: _petNameController.text.trim(),
    );
    await context.read<AuthCubit>().register(
      user: user,
      password: _passwordController.text.trim(),
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration saved locally.')),
    );
    Navigator.of(context).pop();
  }
}
