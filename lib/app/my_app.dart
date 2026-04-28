import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/features/bootstrap/bootstrap_page.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_project/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:my_project/theme/pet_bowl_theme.dart';

/// Wires application-wide singletons (services) and globally-scoped cubits
/// into the widget tree. Per-feature cubits are provided lower in the tree.
class MyApp extends StatelessWidget {
  const MyApp({
    required this.authService,
    required this.bowlEntryService,
    required this.connectivityService,
    required this.mqttSensorService,
    super.key,
  });

  final AuthService authService;
  final BowlEntryService bowlEntryService;
  final ConnectivityService connectivityService;
  final MqttSensorService mqttSensorService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>.value(value: authService),
        RepositoryProvider<BowlEntryService>.value(value: bowlEntryService),
        RepositoryProvider<ConnectivityService>.value(
          value: connectivityService,
        ),
        RepositoryProvider<MqttSensorService>.value(value: mqttSensorService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ConnectivityCubit>(
            create: (context) => ConnectivityCubit(connectivityService),
          ),
          BlocProvider<AuthCubit>(create: (context) => AuthCubit(authService)),
        ],
        child: MaterialApp(
          title: 'Smart Pet Bowl',
          debugShowCheckedModeBanner: false,
          theme: PetBowlTheme.light(),
          home: const BootstrapPage(),
        ),
      ),
    );
  }
}
