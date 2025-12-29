import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../state/auth_controller.dart';

class ApiClient {
  ApiClient(this.auth, {http.Client? client})
      : _client = client ?? http.Client(),
        baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.110.83:3000';

  final AuthController auth;
  final http.Client _client;
  final String baseUrl;

  Future<String?> _getToken() async {
    if (auth.token != null) return auth.token;
    await auth.checkAuthStatus();
    return auth.token;
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
}
