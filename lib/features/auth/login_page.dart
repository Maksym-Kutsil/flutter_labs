import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/core/validation/input_validators.dart';
import 'package:my_project/features/app/authenticated_shell_page.dart';
import 'package:my_project/features/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.authService,
    required this.bowlEntryService,
    required this.connectivityService,
    required this.mqttSensorService,
    super.key,
  });

  final AuthService authService;
  final BowlEntryService bowlEntryService;
  final ConnectivityService connectivityService;
  final MqttSensorService mqttSensorService;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Pet Bowl Login')),
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
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      return InputValidators.validateEmail(value ?? '');
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      return InputValidators.validatePassword(value ?? '');
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _login,
                      child: Text(_isLoading ? 'Checking...' : 'Login'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _openRegistration,
                    child: const Text('Create local account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final isOnline = await widget.connectivityService.isOnline();
    if (!mounted) {
      return;
    }
    if (!isOnline) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No internet connection. Please connect and try again.',
          ),
        ),
      );
      return;
    }

    final user = await widget.authService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login failed. Check email/password or register first.',
          ),
        ),
      );
      return;
    }

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => AuthenticatedShellPage(
          authService: widget.authService,
          bowlEntryService: widget.bowlEntryService,
          connectivityService: widget.connectivityService,
          mqttSensorService: widget.mqttSensorService,
          user: user,
        ),
      ),
    );
  }

  Future<void> _openRegistration() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RegisterPage(authService: widget.authService),
      ),
    );
  }
}
