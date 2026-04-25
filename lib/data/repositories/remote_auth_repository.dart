import 'package:my_project/data/local/key_value_storage.dart';
import 'package:my_project/data/remote/api_client.dart';
import 'package:my_project/data/remote/auth_api.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';

/// Auth repository that uses [AuthApi] for online login while persisting the
/// last authenticated user, password and access token locally so that auto
/// login keeps working when the device is offline.
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository({
    required AuthApi authApi,
    required ApiClient apiClient,
    required AuthRepository localRepository,
    required KeyValueStorage storage,
  }) : _authApi = authApi,
       _apiClient = apiClient,
       _local = localRepository,
       _storage = storage;

  static const String _tokenKey = 'auth_access_token';

  final AuthApi _authApi;
  final ApiClient _apiClient;
  final AuthRepository _local;
  final KeyValueStorage _storage;

  /// Restores any previously persisted access token into the [ApiClient].
  /// Call this once during bootstrap so authenticated requests work after
  /// a cold start.
  Future<void> restoreAuthToken() async {
    final token = await _storage.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      _apiClient.setAuthToken(token);
    }
  }

  @override
  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApi.login(email: email, password: password);
      final remoteUser = result.user.copyWith(email: email);
      await _local.register(user: remoteUser, password: password);
      await _storage.setString(_tokenKey, result.accessToken);
      _apiClient.setAuthToken(result.accessToken);
      return remoteUser;
    } on ApiException {
      return _local.login(email: email, password: password);
    } catch (_) {
      return _local.login(email: email, password: password);
    }
  }

  @override
  Future<void> register({
    required AppUser user,
    required String password,
  }) async {
    await _local.register(user: user, password: password);
  }

  @override
  Future<AppUser?> getRegisteredUser() => _local.getRegisteredUser();

  @override
  Future<void> updateUser(AppUser user) => _local.updateUser(user);

  @override
  Future<void> saveSession(String email) => _local.saveSession(email);

  @override
  Future<String?> getSessionEmail() => _local.getSessionEmail();

  @override
  Future<void> clearSession() async {
    await _local.clearSession();
    await _storage.remove(_tokenKey);
    _apiClient.setAuthToken(null);
  }
}
