import 'package:mqtt_client/mqtt_client.dart';

import 'package:my_project/application/services/mqtt_client_factory_stub.dart'
    if (dart.library.io) 'package:my_project/application/services/mqtt_client_factory_io.dart'
    if (dart.library.html) 'package:my_project/application/services/mqtt_client_factory_web.dart'
    as impl;

typedef MqttClientFactory =
    MqttClient Function(
      String server,
      String clientId,
      int port,
      int webSocketPort,
    );

MqttClient defaultMqttClientFactory(
  String server,
  String clientId,
  int port,
  int webSocketPort,
) {
  return impl.defaultMqttClientFactory(server, clientId, port, webSocketPort);
}
