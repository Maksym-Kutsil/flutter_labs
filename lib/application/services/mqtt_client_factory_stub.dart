import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient defaultMqttClientFactory(
  String server,
  String clientId,
  int port,
  int webSocketPort,
) {
  return MqttServerClient(server, clientId)..port = port;
}
