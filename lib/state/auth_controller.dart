import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _user;
  
  // Use your machine's IP address instead of localhost
  static const String _baseUrl = 'http://192.168.110.83:3000';
  
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  
  Future<void> login(String username, String password) async {
    try {
      print('Attempting login to: $_baseUrl/api/auth/login');
      print('Username: $username');
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          _token = data['token'];
          _user = data['user'];
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
      print('Login error: $e');
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Tidak dapat terhubung ke server. Pastikan backend berjalan.');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
      
      // Verify token with backend
      final response = await _client.get(
        Uri.parse('$_baseUrl/api/auth/verify'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _token = token;
          _user = data['decoded'];
          _isAuthenticated = true;
          notifyListeners();
          return true;
        }
      }
      
      // Token invalid, remove it
      await prefs.remove('token');
      _token = null;
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } catch (e) {
      // Network error or other issue, clear auth state
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _token = null;
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }
}
