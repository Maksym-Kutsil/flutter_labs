import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient defaultMqttClientFactory(
  String server,
  String clientId,
  int port,
  int webSocketPort,
) {
  final webSocketUrl = 'wss://$server:$webSocketPort/mqtt';
  return MqttBrowserClient(webSocketUrl, clientId)
    ..websocketProtocols = ['mqtt']
    ..port = webSocketPort;
}
