import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/application/services/connectivity_service.dart';
import 'package:my_project/presentation/cubits/bootstrap/bootstrap_state.dart';

/// Decides whether to start at the login screen or the authenticated shell
/// using the persisted session. The auto-login path is the only place where
/// the auth service is consulted directly outside of [AuthCubit] (allowed
/// per lab requirements).
class BootstrapCubit extends Cubit<BootstrapState> {
  BootstrapCubit({
    required AuthService authService,
    required ConnectivityService connectivityService,
  }) : _authService = authService,
       _connectivityService = connectivityService,
       super(const BootstrapState());

  final AuthService _authService;
  final ConnectivityService _connectivityService;

  Future<void> start() async {
    final user = await _authService.restoreSession();
    if (user == null) {
      emit(state.copyWith(status: BootstrapStatus.goLogin));
      return;
    }
    final isOnline = await _connectivityService.isOnline();
    emit(
      state.copyWith(
        status: BootstrapStatus.goShell,
        user: user,
        showOfflineWarning: !isOnline,
      ),
    );
  }
}
