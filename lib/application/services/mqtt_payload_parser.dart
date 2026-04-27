import 'package:mqtt_client/mqtt_client.dart';

/// Decodes a list of MQTT messages into a `(payload, parsedNumeric?)` pair.
class ParsedMqttMessage {
  const ParsedMqttMessage({required this.payload, this.numericValue});

  final String payload;
  final double? numericValue;
}

ParsedMqttMessage? parseFirstMessage(
  List<MqttReceivedMessage<MqttMessage>> messages,
) {
  if (messages.isEmpty) {
    return null;
  }
  final recMess = messages.first.payload as MqttPublishMessage;
  final payload = MqttPublishPayload.bytesToStringAsString(
    recMess.payload.message,
  );
  return ParsedMqttMessage(
    payload: payload,
    numericValue: double.tryParse(payload.trim()),
  );
}
