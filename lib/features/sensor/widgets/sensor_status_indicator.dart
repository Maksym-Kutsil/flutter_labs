import 'package:flutter/material.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';

/// Renders a row with an icon and human-readable label for the sensor status.
class SensorStatusIndicator extends StatelessWidget {
  const SensorStatusIndicator({required this.status, super.key});

  final MqttSensorStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(_iconFor(status), color: _colorFor(theme, status)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(_textFor(status), style: theme.textTheme.titleMedium),
        ),
      ],
    );
  }

  IconData _iconFor(MqttSensorStatus status) {
    switch (status) {
      case MqttSensorStatus.connected:
        return Icons.cloud_done_rounded;
      case MqttSensorStatus.connecting:
        return Icons.cloud_sync_rounded;
      case MqttSensorStatus.disconnected:
        return Icons.cloud_off_rounded;
      case MqttSensorStatus.error:
        return Icons.error_outline_rounded;
    }
  }

  String _textFor(MqttSensorStatus status) {
    switch (status) {
      case MqttSensorStatus.connected:
        return 'Connected to broker';
      case MqttSensorStatus.connecting:
        return 'Connecting...';
      case MqttSensorStatus.disconnected:
        return 'Disconnected';
      case MqttSensorStatus.error:
        return 'Connection error';
    }
  }

  Color _colorFor(ThemeData theme, MqttSensorStatus status) {
    switch (status) {
      case MqttSensorStatus.connected:
        return Colors.green;
      case MqttSensorStatus.connecting:
        return theme.colorScheme.primary;
      case MqttSensorStatus.disconnected:
        return theme.colorScheme.outline;
      case MqttSensorStatus.error:
        return theme.colorScheme.error;
    }
  }
}
