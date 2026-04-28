import 'package:flutter/material.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';

class SensorTemperatureCard extends StatelessWidget {
  const SensorTemperatureCard({required this.state, super.key});

  final MqttSensorState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final temperature = state.temperatureCelsius;
    final lastUpdated = state.lastUpdated;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latest bowl weight', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.monitor_weight_rounded,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    temperature == null
                        ? '—'
                        : '${temperature.toStringAsFixed(1)} g',
                    style: theme.textTheme.displaySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (state.lastPayload != null)
              Text('Raw payload: ${state.lastPayload}'),
            if (lastUpdated != null)
              Text(
                'Updated: ${_formatTime(lastUpdated)}',
                style: theme.textTheme.bodySmall,
              ),
            if (temperature == null && state.lastPayload == null)
              Text(
                'Waiting for the first message on the topic...',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}';
  }
}
