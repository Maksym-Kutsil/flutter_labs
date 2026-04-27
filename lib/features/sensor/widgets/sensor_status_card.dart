import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/features/sensor/widgets/sensor_status_indicator.dart';
import 'package:my_project/presentation/cubits/sensor/sensor_cubit.dart';

class SensorStatusCard extends StatelessWidget {
  const SensorStatusCard({
    required this.state,
    required this.isOnline,
    super.key,
  });

  final MqttSensorState state;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<SensorCubit>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SensorStatusIndicator(status: state.status),
            const SizedBox(height: 8),
            DropdownButtonFormField<MqttBrokerPreset>(
              initialValue: cubit.selectedBroker,
              decoration: const InputDecoration(
                labelText: 'MQTT broker',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: MqttBrokerPreset.values
                  .map(
                    (broker) => DropdownMenuItem<MqttBrokerPreset>(
                      value: broker,
                      child: Text('${broker.label} (${broker.server})'),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value == null) {
                  return;
                }
                await cubit.switchBroker(value);
                if (isOnline && context.mounted) {
                  await context.read<SensorCubit>().connect();
                }
              },
            ),
            const SizedBox(height: 8),
            Text('Broker: ${cubit.broker}'),
            Text('Topic: ${cubit.topic}'),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        state.status == MqttSensorStatus.connecting || !isOnline
                        ? null
                        : cubit.connect,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      state.status == MqttSensorStatus.connected
                          ? 'Reconnect'
                          : 'Connect',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.status == MqttSensorStatus.disconnected
                        ? null
                        : cubit.disconnect,
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('Disconnect'),
                  ),
                ),
              ],
            ),
            if (!isOnline) ...[
              const SizedBox(height: 8),
              Text(
                'Device is offline. MQTT will reconnect when the network '
                'is back.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
