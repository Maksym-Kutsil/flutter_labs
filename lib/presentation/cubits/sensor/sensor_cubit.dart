import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';

/// Bridges [MqttSensorService] (a [ValueNotifier]-based service) into a
/// [Cubit] so widgets never call the service directly.
class SensorCubit extends Cubit<MqttSensorState> {
  SensorCubit(this._service) : super(_service.state.value) {
    _service.state.addListener(_onServiceChanged);
  }

  final MqttSensorService _service;

  MqttBrokerPreset get selectedBroker => _service.selectedBroker;
  String get broker => _service.broker;
  String get topic => _service.topic;

  void _onServiceChanged() {
    if (isClosed) {
      return;
    }
    emit(_service.state.value);
  }

  Future<void> connect() => _service.connect();

  Future<void> disconnect() => _service.disconnect();

  Future<void> switchBroker(MqttBrokerPreset preset) async {
    await _service.switchBroker(preset);
    if (isClosed) {
      return;
    }
    emit(_service.state.value);
  }

  @override
  Future<void> close() async {
    _service.state.removeListener(_onServiceChanged);
    return super.close();
  }
}
