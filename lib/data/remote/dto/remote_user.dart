import 'package:my_project/domain/models/app_user.dart';

/// Auth payload returned by `POST /auth/login` on dummyjson.com.
///
/// We pull out only the fields we care about and keep the original token
/// alongside the [AppUser] domain model.
class RemoteAuthResult {
  const RemoteAuthResult({required this.user, required this.accessToken});

  final AppUser user;
  final String accessToken;

  factory RemoteAuthResult.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final email = json['email'] as String? ?? '';
    final username = json['username'] as String? ?? '';
    final fullName = <String>[
      firstName,
      lastName,
    ].where((part) => part.isNotEmpty).join(' ');
    final token =
        (json['accessToken'] as String?) ?? (json['token'] as String? ?? '');

    return RemoteAuthResult(
      user: AppUser(
        name: fullName.isEmpty ? username : fullName,
        email: email,
        petName: username,
      ),
      accessToken: token,
    );
  }
}
