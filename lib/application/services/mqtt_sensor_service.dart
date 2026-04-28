import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_project/application/services/mqtt_client_factory.dart';
import 'package:my_project/application/services/mqtt_connection_helper.dart';
import 'package:my_project/application/services/mqtt_payload_parser.dart';
import 'package:my_project/application/services/mqtt_sensor_state.dart';

export 'package:my_project/application/services/mqtt_sensor_state.dart';

/// Manages an MQTT connection and exposes the latest numeric reading via a
/// [ValueNotifier]. Designed to be lazily started and safely restarted after
/// a disconnect.
class MqttSensorService {
  MqttSensorService({
    MqttBrokerPreset brokerPreset = MqttBrokerPreset.hiveMq,
    this.topic = 'smartpetbowl/bowl/grams',
    String? clientId,
    MqttClientFactory? clientFactory,
  }) : clientId =
           clientId ??
           'flutter_pet_bowl_${DateTime.now().millisecondsSinceEpoch}',
       _clientFactory = clientFactory ?? defaultMqttClientFactory,
       _selectedBroker = brokerPreset;

  final String topic;
  final String clientId;
  final MqttClientFactory _clientFactory;
  MqttBrokerPreset _selectedBroker;

  MqttBrokerPreset get selectedBroker => _selectedBroker;
  String get broker => _selectedBroker.server;
  int get port => _selectedBroker.port;
  int get webSocketPort => _selectedBroker.webSocketPort;

  final ValueNotifier<MqttSensorState> state = ValueNotifier<MqttSensorState>(
    MqttSensorState.initial,
  );

  MqttClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _subscription;

  Future<void> switchBroker(MqttBrokerPreset brokerPreset) async {
    if (brokerPreset == _selectedBroker) {
      return;
    }
    await disconnect();
    _selectedBroker = brokerPreset;
  }

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
    final result = await openMqttConnection(
      factory: _clientFactory,
      broker: broker,
      clientId: clientId,
      port: port,
      webSocketPort: webSocketPort,
      onConnected: _handleConnected,
      onDisconnected: _handleDisconnect,
    );
    if (!result.succeeded) {
      state.value = state.value.copyWith(
        status: MqttSensorStatus.error,
        errorMessage: result.errorMessage,
      );
      _client = null;
      return;
    }
    final client = result.client!..subscribe(topic, MqttQos.atMostOnce);
    _client = client;
    _subscription = client.updates?.listen(_handleMessages);
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    _client?.disconnect();
    _client = null;
    state.value = state.value.copyWith(
      status: MqttSensorStatus.disconnected,
      clearError: true,
      clearPayload: true,
      clearTemperature: true,
      clearLastUpdated: true,
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
    final parsed = parseFirstMessage(messages);
    if (parsed == null) {
      return;
    }
    state.value = state.value.copyWith(
      status: MqttSensorStatus.connected,
      lastPayload: parsed.payload,
      temperatureCelsius: parsed.numericValue ?? state.value.temperatureCelsius,
      lastUpdated: DateTime.now(),
      clearError: true,
    );
  }
}
