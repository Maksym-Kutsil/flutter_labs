import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_project/application/services/mqtt_client_factory.dart';

/// Result of attempting to open an MQTT connection: either the connected
/// client or an error message describing why the attempt failed.
class MqttConnectionResult {
  const MqttConnectionResult.success(this.client) : errorMessage = null;
  const MqttConnectionResult.failure(this.errorMessage) : client = null;

  final MqttClient? client;
  final String? errorMessage;

  bool get succeeded => client != null;
}

Future<MqttConnectionResult> openMqttConnection({
  required MqttClientFactory factory,
  required String broker,
  required String clientId,
  required int port,
  required int webSocketPort,
  required void Function() onConnected,
  required void Function() onDisconnected,
}) async {
  final client = factory(broker, clientId, port, webSocketPort)
    ..logging(on: false)
    ..keepAlivePeriod = 20
    ..autoReconnect = true
    ..onDisconnected = onDisconnected
    ..onConnected = onConnected;
  client.connectionMessage = MqttConnectMessage()
      .withClientIdentifier(clientId)
      .startClean()
      .withWillQos(MqttQos.atMostOnce);
  try {
    await client.connect();
  } catch (error) {
    client.disconnect();
    return MqttConnectionResult.failure('Connection failed: $error');
  }
  if (client.connectionStatus?.state != MqttConnectionState.connected) {
    client.disconnect();
    return const MqttConnectionResult.failure('Broker refused connection');
  }
  return MqttConnectionResult.success(client);
}
