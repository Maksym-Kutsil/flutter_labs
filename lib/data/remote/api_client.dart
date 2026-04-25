import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Thrown when a remote call returns a non 2xx status.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thin wrapper around `package:http` that handles JSON encoding,
/// authorization headers and error mapping. Repositories depend on this
/// abstraction instead of `http.Client` directly so it can be swapped or
/// faked in tests.
class ApiClient {
  ApiClient({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 10);

  final http.Client _client;
  final Duration _timeout;
  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<Map<String, dynamic>> getJson(String url) async {
    final response = await _client
        .get(Uri.parse(url), headers: _headers())
        .timeout(_timeout);
    return _decode(response);
  }

  Future<Map<String, dynamic>> postJson(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await _client
        .post(
          Uri.parse(url),
          headers: _headers(includeJsonContent: true),
          body: jsonEncode(body ?? <String, dynamic>{}),
        )
        .timeout(_timeout);
    return _decode(response);
  }

  Future<Map<String, dynamic>> putJson(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await _client
        .put(
          Uri.parse(url),
          headers: _headers(includeJsonContent: true),
          body: jsonEncode(body ?? <String, dynamic>{}),
        )
        .timeout(_timeout);
    return _decode(response);
  }

  Future<Map<String, dynamic>> deleteJson(String url) async {
    final response = await _client
        .delete(Uri.parse(url), headers: _headers())
        .timeout(_timeout);
    return _decode(response);
  }

  Map<String, String> _headers({bool includeJsonContent = false}) {
    return <String, String>{
      'Accept': 'application/json',
      if (includeJsonContent) 'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
    if (response.body.isEmpty) {
      return <String, dynamic>{};
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
