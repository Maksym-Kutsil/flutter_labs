import 'package:flutter/foundation.dart';

enum MqttSensorStatus { disconnected, connecting, connected, error }

@immutable
class MqttSensorState {
  const MqttSensorState({
    required this.status,
    this.temperatureCelsius,
    this.lastPayload,
    this.lastUpdated,
    this.errorMessage,
  });

  final MqttSensorStatus status;
  final double? temperatureCelsius;
  final String? lastPayload;
  final DateTime? lastUpdated;
  final String? errorMessage;

  static const MqttSensorState initial = MqttSensorState(
    status: MqttSensorStatus.disconnected,
  );

  MqttSensorState copyWith({
    MqttSensorStatus? status,
    double? temperatureCelsius,
    String? lastPayload,
    DateTime? lastUpdated,
    String? errorMessage,
    bool clearError = false,
    bool clearPayload = false,
    bool clearTemperature = false,
    bool clearLastUpdated = false,
  }) {
    return MqttSensorState(
      status: status ?? this.status,
      temperatureCelsius: clearTemperature
          ? null
          : (temperatureCelsius ?? this.temperatureCelsius),
      lastPayload: clearPayload ? null : (lastPayload ?? this.lastPayload),
      lastUpdated: clearLastUpdated ? null : (lastUpdated ?? this.lastUpdated),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

enum MqttBrokerPreset {
  hiveMq(
    label: 'HiveMQ',
    server: 'broker.hivemq.com',
    port: 1883,
    webSocketPort: 8884,
  ),
  emqx(
    label: 'EMQX',
    server: 'broker.emqx.io',
    port: 1883,
    webSocketPort: 8084,
  );

  const MqttBrokerPreset({
    required this.label,
    required this.server,
    required this.port,
    required this.webSocketPort,
  });

  final String label;
  final String server;
  final int port;
  final int webSocketPort;
}
