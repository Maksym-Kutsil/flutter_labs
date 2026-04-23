import 'package:my_project/domain/models/app_user.dart';

abstract class AuthRepository {
  Future<void> register({required AppUser user, required String password});

  Future<AppUser?> login({required String email, required String password});

  Future<AppUser?> getRegisteredUser();

  Future<void> updateUser(AppUser user);

  Future<void> saveSession(String email);

  Future<String?> getSessionEmail();

  Future<void> clearSession();
}
