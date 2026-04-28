import 'package:equatable/equatable.dart';
import 'package:my_project/domain/models/app_user.dart';

enum BootstrapStatus { loading, goLogin, goShell }

class BootstrapState extends Equatable {
  const BootstrapState({
    this.status = BootstrapStatus.loading,
    this.user,
    this.showOfflineWarning = false,
  });

  final BootstrapStatus status;
  final AppUser? user;
  final bool showOfflineWarning;

  BootstrapState copyWith({
    BootstrapStatus? status,
    AppUser? user,
    bool? showOfflineWarning,
  }) {
    return BootstrapState(
      status: status ?? this.status,
      user: user ?? this.user,
      showOfflineWarning: showOfflineWarning ?? this.showOfflineWarning,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, user, showOfflineWarning];
}
