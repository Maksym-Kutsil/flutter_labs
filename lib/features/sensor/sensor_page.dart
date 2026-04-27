import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/features/sensor/widgets/sensor_status_card.dart';
import 'package:my_project/features/sensor/widgets/sensor_temperature_card.dart';
import 'package:my_project/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:my_project/presentation/cubits/sensor/sensor_cubit.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SensorCubit>(
      create: (context) =>
          SensorCubit(context.read<MqttSensorService>())..connect(),
      child: const _SensorScaffold(),
    );
  }
}

class _SensorScaffold extends StatelessWidget {
  const _SensorScaffold();

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityCubit>().state;
    return BlocListener<ConnectivityCubit, bool>(
      listenWhen: (previous, current) => !previous && current,
      listener: (context, _) {
        final cubit = context.read<SensorCubit>();
        final status = cubit.state.status;
        if (status != MqttSensorStatus.connected &&
            status != MqttSensorStatus.connecting) {
          cubit.connect();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('MQTT bowl scale')),
        body: BlocBuilder<SensorCubit, MqttSensorState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SensorStatusCard(state: state, isOnline: isOnline),
                const SizedBox(height: 16),
                SensorTemperatureCard(state: state),
              ],
            );
          },
        ),
      ),
    );
  }
}
