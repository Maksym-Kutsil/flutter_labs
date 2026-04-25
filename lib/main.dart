import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/bowl_entry_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/application/services/mqtt_sensor_service.dart';
import 'package:my_project/data/local/shared_prefs_storage.dart';
import 'package:my_project/data/remote/api_client.dart';
import 'package:my_project/data/remote/auth_api.dart';
import 'package:my_project/data/remote/bowl_entry_api.dart';
import 'package:my_project/data/repositories/cached_bowl_entry_repository.dart';
import 'package:my_project/data/repositories/local_auth_repository.dart';
import 'package:my_project/data/repositories/local_bowl_entry_repository.dart';
import 'package:my_project/data/repositories/remote_auth_repository.dart';
import 'package:my_project/features/bootstrap/bootstrap_page.dart';
import 'package:my_project/theme/pet_bowl_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await SharedPrefsStorage.create();

  final apiClient = ApiClient();
  final authApi = AuthApi(apiClient);
  final bowlEntryApi = BowlEntryApi(apiClient);

  final remoteAuthRepository = RemoteAuthRepository(
    authApi: authApi,
    apiClient: apiClient,
    localRepository: LocalAuthRepository(storage),
    storage: storage,
  );
  await remoteAuthRepository.restoreAuthToken();

  final bowlEntryRepository = CachedBowlEntryRepository(
    api: bowlEntryApi,
    localRepository: LocalBowlEntryRepository(storage),
  );

  final authService = AuthService(remoteAuthRepository);
  final bowlEntryService = BowlEntryService(bowlEntryRepository);
  final connectivityService = ConnectivityService();
  final mqttSensorService = MqttSensorService();

  runApp(
    MyApp(
      authService: authService,
      bowlEntryService: bowlEntryService,
      connectivityService: connectivityService,
      mqttSensorService: mqttSensorService,
    ),
  );
}

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
    return MaterialApp(
      title: 'Smart Pet Bowl',
      debugShowCheckedModeBanner: false,
      theme: PetBowlTheme.light(),
      home: BootstrapPage(
        authService: authService,
        bowlEntryService: bowlEntryService,
        connectivityService: connectivityService,
        mqttSensorService: mqttSensorService,
      ),
    );
  }
}
