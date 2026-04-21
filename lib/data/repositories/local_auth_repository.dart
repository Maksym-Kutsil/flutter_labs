import 'dart:convert';

import 'package:my_project/data/local/key_value_storage.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._storage);

  static const String _userKey = 'registered_user';
  static const String _passwordKey = 'registered_password';
  static const String _sessionKey = 'active_session_email';

  final KeyValueStorage _storage;

  @override
  Future<AppUser?> getRegisteredUser() async {
    final rawUser = await _storage.getString(_userKey);
    if (rawUser == null || rawUser.isEmpty) {
      return null;
    }
    final map = jsonDecode(rawUser) as Map<String, dynamic>;
    return AppUser.fromJson(map);
  }

  @override
  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    final storedPassword = await _storage.getString(_passwordKey);
    final user = await getRegisteredUser();
    if (storedPassword == null || user == null) {
      return null;
    }

    if (user.email == email && storedPassword == password) {
      return user;
    }
    return null;
  }

  @override
  Future<void> register({
    required AppUser user,
    required String password,
  }) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.setString(_userKey, userJson);
    await _storage.setString(_passwordKey, password);
  }

  @override
  Future<void> updateUser(AppUser user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.setString(_userKey, userJson);
  }

  @override
  Future<void> saveSession(String email) async {
    await _storage.setString(_sessionKey, email);
  }

  @override
  Future<String?> getSessionEmail() async {
    final email = await _storage.getString(_sessionKey);
    if (email == null || email.isEmpty) {
      return null;
    }
    return email;
  }

  @override
  Future<void> clearSession() async {
    await _storage.remove(_sessionKey);
  }
}
