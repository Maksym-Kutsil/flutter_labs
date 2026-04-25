import 'package:my_project/data/remote/api_client.dart';
import 'package:my_project/data/remote/api_endpoints.dart';
import 'package:my_project/data/remote/dto/remote_user.dart';
import 'package:my_project/domain/models/app_user.dart';

/// Remote auth endpoints used by [RemoteAuthRepository].
class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  /// Calls `POST /auth/login` and returns the parsed user + token.
  ///
  /// dummyjson.com expects a `username`. If the UI provides an email we
  /// first try to resolve the username from `/users/filter`.
  Future<RemoteAuthResult> login({
    required String email,
    required String password,
  }) async {
    final username = await _resolveUsername(email);
    final json = await _client.postJson(
      ApiEndpoints.login,
      body: <String, dynamic>{
        'username': username,
        'password': password,
        'expiresInMins': 60,
      },
    );
    return RemoteAuthResult.fromJson(json);
  }

  /// Validates the currently configured token by calling `GET /auth/me`.
  /// Returns the user from the API or `null` if the token is invalid.
  Future<AppUser?> me() async {
    try {
      final json = await _client.getJson(ApiEndpoints.me);
      return RemoteAuthResult.fromJson(json).user;
    } on ApiException {
      return null;
    }
  }

  Future<String> _resolveUsername(String email) async {
    try {
      final encoded = Uri.encodeQueryComponent(email);
      final json = await _client.getJson(ApiEndpoints.usersByEmail(encoded));
      final users = json['users'] as List<dynamic>? ?? <dynamic>[];
      final first = users.isEmpty ? null : users.first;
      if (first is Map<String, dynamic>) {
        final username = first['username'] as String?;
        if (username != null && username.isNotEmpty) {
          return username;
        }
      }
    } on ApiException {
      // Fallback below.
    } catch (_) {
      // Fallback below.
    }
    return _usernameFromEmail(email);
  }

  String _usernameFromEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 0) {
      return email;
    }
    return email.substring(0, atIndex);
  }
}
