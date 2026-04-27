import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_project/data/local/key_value_storage.dart';
import 'package:my_project/data/remote/api_client.dart';
import 'package:my_project/data/remote/auth_api.dart';
import 'package:my_project/data/repositories/local_auth_repository.dart';
import 'package:my_project/data/repositories/remote_auth_repository.dart';
import 'package:my_project/domain/models/app_user.dart';

void main() {
  group('RemoteAuthRepository', () {
    test('login caches the user and persists the token', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode(<String, dynamic>{
            'username': 'emilys',
            'firstName': 'Emily',
            'lastName': 'Stone',
            'email': 'emily@example.com',
            'accessToken': 'token-abc',
          }),
          200,
          headers: <String, String>{'content-type': 'application/json'},
        );
      });
      final storage = _InMemoryStorage();
      final apiClient = ApiClient(client: mock);
      final repo = RemoteAuthRepository(
        authApi: AuthApi(apiClient),
        apiClient: apiClient,
        localRepository: LocalAuthRepository(storage),
        storage: storage,
      );

      final user = await repo.login(email: 'emily@example.com', password: 'pw');

      expect(user, isNotNull);
      expect(user!.email, 'emily@example.com');
      final cachedUser = await repo.getRegisteredUser();
      expect(cachedUser?.email, 'emily@example.com');
      expect(await storage.getString('auth_access_token'), 'token-abc');
    });

    test('falls back to local repo when the API returns an error', () async {
      final storage = _InMemoryStorage();
      final local = LocalAuthRepository(storage);
      await local.register(
        user: const AppUser(
          name: 'Cached',
          email: 'offline@example.com',
          petName: 'Rex',
        ),
        password: 'pw',
      );
      final mock = MockClient((request) async {
        return http.Response('boom', 401);
      });
      final apiClient = ApiClient(client: mock);
      final repo = RemoteAuthRepository(
        authApi: AuthApi(apiClient),
        apiClient: apiClient,
        localRepository: local,
        storage: storage,
      );

      final user = await repo.login(
        email: 'offline@example.com',
        password: 'pw',
      );

      expect(user?.email, 'offline@example.com');
      expect(await storage.getString('auth_access_token'), isNull);
    });
  });
}

class _InMemoryStorage implements KeyValueStorage {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> getString(String key) async => _store[key];

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> setString(String key, String value) async => _store[key] = value;
}
