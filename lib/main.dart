import 'package:flutter/material.dart';
import 'package:my_project/app/my_app.dart';
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

  runApp(
    MyApp(
      authService: AuthService(remoteAuthRepository),
      bowlEntryService: BowlEntryService(bowlEntryRepository),
      connectivityService: ConnectivityService(),
      mqttSensorService: MqttSensorService(),
    ),
  );
}
