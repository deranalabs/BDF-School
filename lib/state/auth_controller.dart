import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthController extends ChangeNotifier {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isAuthenticated = false;
  
  bool get isAuthenticated => _isAuthenticated;
  
  Future<void> login(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await _storage.write(key: 'token', value: data['token']);
          _isAuthenticated = true;
          notifyListeners();
        } else {
          throw AuthException(data['message'] ?? 'Login gagal');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw AuthException(errorData['message'] ?? 'Login gagal');
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Tidak dapat terhubung ke server. Pastikan backend berjalan.');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    final token = await _storage.read(key: 'token');
    _isAuthenticated = token != null;
    notifyListeners();
    return _isAuthenticated;
  }
}
