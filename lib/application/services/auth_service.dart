import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';

class AuthService {
  AuthService(this._repository);

  final AuthRepository _repository;

  Future<void> register({
    required AppUser user,
    required String password,
  }) async {
    await _repository.register(user: user, password: password);
  }

  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    final user = await _repository.login(email: email, password: password);
    if (user != null) {
      await _repository.saveSession(user.email);
    }
    return user;
  }

  Future<AppUser?> getRegisteredUser() async {
    return _repository.getRegisteredUser();
  }

  Future<void> updateUser(AppUser user) async {
    await _repository.updateUser(user);
  }

  /// Returns the active session's user if a session is saved and the
  /// registered user still matches, otherwise returns `null`.
  Future<AppUser?> restoreSession() async {
    final sessionEmail = await _repository.getSessionEmail();
    if (sessionEmail == null) {
      return null;
    }
    final user = await _repository.getRegisteredUser();
    if (user == null || user.email != sessionEmail) {
      await _repository.clearSession();
      return null;
    }
    return user;
  }

  Future<void> logout() async {
    await _repository.clearSession();
  }
}
