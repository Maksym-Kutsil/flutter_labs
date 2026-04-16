import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/core/validation/input_validators.dart';
import 'package:my_project/domain/models/app_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    required this.authService,
    super.key,
  });

  final AuthService authService;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your name',
                    ),
                    validator: (value) {
                      return InputValidators.validateName(value ?? '');
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      return InputValidators.validateEmail(value ?? '');
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _petNameController,
                    decoration: const InputDecoration(
                      labelText: 'Pet name',
                    ),
                    validator: (value) {
                      return InputValidators.validateName(value ?? '');
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      return InputValidators.validatePassword(value ?? '');
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _register,
                      child: Text(_isLoading ? 'Saving...' : 'Create account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final user = AppUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      petName: _petNameController.text.trim(),
    );

    await widget.authService.register(
      user: user,
      password: _passwordController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration saved locally.')),
    );
    Navigator.of(context).pop();
  }
}
