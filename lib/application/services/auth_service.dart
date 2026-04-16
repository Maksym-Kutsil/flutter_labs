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
    return _repository.login(email: email, password: password);
  }

  Future<AppUser?> getRegisteredUser() async {
    return _repository.getRegisteredUser();
  }

  Future<void> updateUser(AppUser user) async {
    await _repository.updateUser(user);
  }
}
