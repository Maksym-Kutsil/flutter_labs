import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/presentation/cubits/auth/auth_state.dart';

/// Wraps [AuthService] and exposes user/session state for the UI.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(const AuthState());

  final AuthService _authService;

  void seedUser(AppUser user) {
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  Future<bool> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearError: true));
    final user = await _authService.login(email: email, password: password);
    if (user == null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Login failed. Check email/password or register first.',
          clearUser: true,
        ),
      );
      return false;
    }
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    return true;
  }

  Future<void> register({
    required AppUser user,
    required String password,
  }) async {
    await _authService.register(user: user, password: password);
  }

  Future<void> updateUser(AppUser user) async {
    await _authService.updateUser(user);
    emit(state.copyWith(user: user, status: AuthStatus.authenticated));
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
