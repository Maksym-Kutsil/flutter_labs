import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

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
  }) {
    return MqttSensorState(
      status: status ?? this.status,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      lastPayload: clearPayload ? null : (lastPayload ?? this.lastPayload),
      lastUpdated: lastUpdated ?? this.lastUpdated,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

typedef MqttClientFactory =
    MqttClient Function(String server, String clientId, int port);

/// Service that manages an MQTT connection and exposes the latest sensor
/// readings via a [ValueNotifier]. Designed to be lazily started and safely
/// restarted after a disconnect.
class MqttSensorService {
  MqttSensorService({
    this.broker = 'broker.hivemq.com',
    this.port = 1883,
    this.topic = 'sensor/temperature',
    String? clientId,
    MqttClientFactory? clientFactory,
  }) : clientId =
           clientId ??
           'flutter_pet_bowl_${DateTime.now().millisecondsSinceEpoch}',
       _clientFactory = clientFactory ?? _defaultClientFactory;

  final String broker;
  final int port;
  final String topic;
  final String clientId;
  final MqttClientFactory _clientFactory;

  final ValueNotifier<MqttSensorState> state = ValueNotifier<MqttSensorState>(
    MqttSensorState.initial,
  );

  MqttClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _subscription;

  Future<void> connect() async {
    final current = state.value.status;
    if (current == MqttSensorStatus.connecting ||
        current == MqttSensorStatus.connected) {
      return;
    }

    state.value = state.value.copyWith(
      status: MqttSensorStatus.connecting,
      clearError: true,
    );

    final client = _clientFactory(broker, clientId, port)
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..autoReconnect = true
      ..onDisconnected = _handleDisconnect
      ..onConnected = _handleConnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;
    _client = client;

    try {
      await client.connect();
    } catch (error) {
      state.value = state.value.copyWith(
        status: MqttSensorStatus.error,
        errorMessage: 'Connection failed: $error',
      );
      client.disconnect();
      _client = null;
      return;
    }

    final connectionState = client.connectionStatus?.state;
    if (connectionState != MqttConnectionState.connected) {
      state.value = state.value.copyWith(
        status: MqttSensorStatus.error,
        errorMessage: 'Broker refused connection: $connectionState',
      );
      client.disconnect();
      _client = null;
      return;
    }

    client.subscribe(topic, MqttQos.atMostOnce);

    final updates = client.updates;
    if (updates != null) {
      _subscription = updates.listen(_handleMessages);
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    _client?.disconnect();
    _client = null;
    state.value = state.value.copyWith(
      status: MqttSensorStatus.disconnected,
      clearError: true,
    );
  }

  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    _client?.disconnect();
    _client = null;
    state.dispose();
  }

  void _handleConnected() {
    state.value = state.value.copyWith(
      status: MqttSensorStatus.connected,
      clearError: true,
    );
  }

  void _handleDisconnect() {
    if (state.value.status == MqttSensorStatus.error) {
      return;
    }
    state.value = state.value.copyWith(status: MqttSensorStatus.disconnected);
  }

  void _handleMessages(List<MqttReceivedMessage<MqttMessage>> messages) {
    if (messages.isEmpty) {
      return;
    }
    final recMess = messages.first.payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );
    final parsed = double.tryParse(payload.trim());
    state.value = state.value.copyWith(
      status: MqttSensorStatus.connected,
      lastPayload: payload,
      temperatureCelsius: parsed ?? state.value.temperatureCelsius,
      lastUpdated: DateTime.now(),
      clearError: true,
    );
  }

  static MqttClient _defaultClientFactory(
    String server,
    String clientId,
    int port,
  ) {
    return MqttServerClient(server, clientId)..port = port;
  }
}
