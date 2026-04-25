import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/domain/models/bowl_entry.dart';
import 'package:my_project/features/auth/login_page.dart';
import 'package:my_project/features/home/widgets/entry_editor_dialog.dart';

/// Side-effecting helpers used by [HomePage]. Extracted so the page widget
/// stays small and focused on layout.
class HomeActions {
  const HomeActions({
    required this.authService,
    required this.bowlEntryService,
    required this.connectivityService,
    required this.mqttSensorService,
  });

  final AuthService authService;
  final BowlEntryService bowlEntryService;
  final ConnectivityService connectivityService;
  final MqttSensorService mqttSensorService;

  Future<BowlEntry?> showEntryDialog(
    BuildContext context, {
    BowlEntry? initialEntry,
  }) {
    return showDialog<BowlEntry>(
      context: context,
      builder: (context) => EntryEditorDialog(initialEntry: initialEntry),
    );
  }

  Future<bool> confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm logout'),
        content: const Text('Sign out of this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> performLogout(BuildContext context) async {
    await authService.logout();
    await mqttSensorService.disconnect();
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => LoginPage(
          authService: authService,
          bowlEntryService: bowlEntryService,
          connectivityService: connectivityService,
          mqttSensorService: mqttSensorService,
        ),
      ),
      (route) => false,
    );
  }
}
