import 'package:flutter/material.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({
    required this.mqttSensorService,
    required this.isOnline,
    super.key,
  });

  final MqttSensorService mqttSensorService;
  final bool isOnline;

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isOnline) {
      unawaitedConnect();
    }
  }

  void unawaitedConnect() {
    widget.mqttSensorService.connect();
  }

  Future<void> _switchBroker(MqttBrokerPreset broker) async {
    await widget.mqttSensorService.switchBroker(broker);
    if (!mounted || !widget.isOnline) {
      return;
    }
    unawaitedConnect();
  }

  @override
  void didUpdateWidget(covariant SensorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final status = widget.mqttSensorService.state.value.status;
    if (widget.isOnline &&
        !oldWidget.isOnline &&
        status != MqttSensorStatus.connected &&
        status != MqttSensorStatus.connecting) {
      unawaitedConnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MQTT bowl scale')),
      body: ValueListenableBuilder<MqttSensorState>(
        valueListenable: widget.mqttSensorService.state,
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatusCard(
                state: state,
                isOnline: widget.isOnline,
                onReconnect: widget.isOnline ? unawaitedConnect : null,
                onDisconnect: () => widget.mqttSensorService.disconnect(),
                selectedBroker: widget.mqttSensorService.selectedBroker,
                onBrokerChanged: _switchBroker,
                broker: widget.mqttSensorService.broker,
                topic: widget.mqttSensorService.topic,
              ),
              const SizedBox(height: 16),
              _TemperatureCard(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.state,
    required this.isOnline,
    required this.onReconnect,
    required this.onDisconnect,
    required this.selectedBroker,
    required this.onBrokerChanged,
    required this.broker,
    required this.topic,
  });

  final MqttSensorState state;
  final bool isOnline;
  final VoidCallback? onReconnect;
  final VoidCallback onDisconnect;
  final MqttBrokerPreset selectedBroker;
  final ValueChanged<MqttBrokerPreset> onBrokerChanged;
  final String broker;
  final String topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_statusIcon, color: _statusColor(theme)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_statusText, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<MqttBrokerPreset>(
              initialValue: selectedBroker,
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
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                onBrokerChanged(value);
              },
            ),
            const SizedBox(height: 8),
            Text('Broker: $broker'),
            Text('Topic: $topic'),
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
                    onPressed: state.status == MqttSensorStatus.connecting
                        ? null
                        : onReconnect,
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
                        : onDisconnect,
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('Disconnect'),
                  ),
                ),
              ],
            ),
            if (!isOnline) ...[
              const SizedBox(height: 8),
              Text(
                'Device is offline. MQTT will reconnect when the '
                'network is back.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData get _statusIcon {
    switch (state.status) {
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

  String get _statusText {
    switch (state.status) {
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

  Color _statusColor(ThemeData theme) {
    switch (state.status) {
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

class _TemperatureCard extends StatelessWidget {
  const _TemperatureCard({required this.state});

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
