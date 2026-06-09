import 'package:flashlight_plugin/flashlight_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper that mediates between the secret UI gesture in `HomePage` and the
/// `flashlight_plugin` static API.
///
/// Encapsulating this keeps the UI widgets agnostic of the plugin and makes
/// sure the iOS / unsupported-platform warning dialog is shown in exactly
/// one place.
class FlashlightActions {
  const FlashlightActions._();

  /// Triggered by the secret gesture on the home page. Toggles the torch
  /// when running on Android, otherwise shows a friendly warning dialog.
  static Future<void> secretToggle(BuildContext context) async {
    try {
      await Flashlight.toggle();
      if (!context.mounted) {
        return;
      }
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            Flashlight.isOn
                ? 'Secret flashlight enabled'
                : 'Secret flashlight disabled',
          ),
        ),
      );
    } on FlashlightUnsupportedException catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showUnsupportedDialog(
        context,
        title: 'Flashlight not supported',
        message:
            'The secret flashlight feature is implemented natively for '
            'Android only. ${error.toString()}',
      );
    } on PlatformException catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showUnsupportedDialog(
        context,
        title: 'Could not switch the flashlight',
        message: error.message ?? 'The native layer rejected the call.',
      );
    }
  }

  static Future<void> _showUnsupportedDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
