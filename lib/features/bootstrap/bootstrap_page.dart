import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/features/app/authenticated_shell_page.dart';
import 'package:my_project/features/auth/login_page.dart';

/// Decides on app start whether to show the login screen or jump straight
/// into the authenticated shell using the persisted session.
class BootstrapPage extends StatefulWidget {
  const BootstrapPage({
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
  State<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideStartRoute());
  }

  Future<void> _decideStartRoute() async {
    final user = await widget.authService.restoreSession();
    final isOnline = await widget.connectivityService.isOnline();
    if (!mounted) {
      return;
    }

    if (user == null) {
      _goToLogin();
      return;
    }

    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Offline mode: auto-login succeeded but some features are '
            'unavailable.',
          ),
        ),
      );
    }

    _goToShell(user);
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => LoginPage(
          authService: widget.authService,
          bowlEntryService: widget.bowlEntryService,
          connectivityService: widget.connectivityService,
          mqttSensorService: widget.mqttSensorService,
        ),
      ),
    );
  }

  void _goToShell(AppUser user) {
    Navigator.of(context).pushReplacement(
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets_rounded, size: 64),
            SizedBox(height: 16),
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Preparing Smart Pet Bowl...'),
          ],
        ),
      ),
    );
  }
}
