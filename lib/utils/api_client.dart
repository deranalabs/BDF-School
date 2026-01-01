import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../state/auth_controller.dart';

class ApiClient {
  ApiClient(this.auth, {http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = (baseUrl ?? dotenv.env['BASE_URL'] ?? 'http://localhost:3000').trim();

  final AuthController auth;
  final http.Client _client;
  final String baseUrl;

  Future<String?> _getToken() async {
    if (auth.token != null) return auth.token;
    await auth.checkAuthStatus();
    return auth.token;
  }

  Future<http.Response> postPublic(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> get(String path) async {
    final token = await _getToken();
    if (token == null) {
      throw const AuthException('Token tidak tersedia, silakan login ulang');
    }
    final uri = Uri.parse('$baseUrl$path');
    return _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> post(String path, {Object? body}) async {
    final token = await _getToken();
    if (token == null) {
      throw const AuthException('Token tidak tersedia, silakan login ulang');
    }
    final uri = Uri.parse('$baseUrl$path');
    final requestBody = body is String ? body : (body != null ? jsonEncode(body) : null);
    return _client.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );
  }

  Future<http.Response> put(String path, {Object? body}) async {
    final token = await _getToken();
    if (token == null) {
      throw const AuthException('Token tidak tersedia, silakan login ulang');
    }
    final uri = Uri.parse('$baseUrl$path');
    final requestBody = body is String ? body : (body != null ? jsonEncode(body) : null);
    return _client.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );
  }

  Future<http.Response> delete(String path) async {
    final token = await _getToken();
    if (token == null) {
      throw const AuthException('Token tidak tersedia, silakan login ulang');
    }
    final uri = Uri.parse('$baseUrl$path');
    return _client.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
