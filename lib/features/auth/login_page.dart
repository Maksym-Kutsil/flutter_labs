import 'package:flutter/material.dart';
import 'package:my_project/features/auth/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Pet Bowl Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: const Padding(padding: EdgeInsets.all(16), child: LoginForm()),
        ),
      ),
    );
  }
}
