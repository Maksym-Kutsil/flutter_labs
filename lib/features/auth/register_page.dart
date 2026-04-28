import 'package:flutter/material.dart';
import 'package:my_project/features/auth/widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
