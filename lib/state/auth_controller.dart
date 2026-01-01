import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  AuthController({String? baseUrl})
      : _baseUrl = (baseUrl ?? dotenv.env['BASE_URL'] ?? 'http://localhost:3000').trim();

  final http.Client _client = http.Client();
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _user;
  final String _baseUrl;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  String? get avatar => _user?['avatar'] as String?;

  void updateUserProfile(Map<String, dynamic> profile) {
    _user = {...?_user, ...profile};
    notifyListeners();
  }

  void setAvatar(String? avatarValue) {
    if (_user == null) return;
    _user = {
      ..._user!,
      'avatar': avatarValue ?? '',
    };
    notifyListeners();
  }
  
  Future<void> login(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          _token = data['token'];
          _user = data['user'];
          _isAuthenticated = true;
          // Segera beritahu listener agar home bergeser ke dashboard
          notifyListeners();
          // kemudian coba sinkron profil (jika gagal, tidak blok navigasi)
          await _fetchAndCacheProfile();
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
          notifyListeners(); // pastikan UI bergeser meski fetch profil gagal
          // sinkronkan profil dari API agar avatar langsung ada (best effort)
          await _fetchAndCacheProfile();
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

  Future<void> _fetchAndCacheProfile() async {
    if (_token == null) return;
    try {
      final res = await _client.get(
        Uri.parse('$_baseUrl/api/profile'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is Map<String, dynamic>) {
          final profile = Map<String, dynamic>.from(data['data'] as Map);
          final avatarVal = profile['avatar'];
          if (avatarVal is String && avatarVal.isNotEmpty && !avatarVal.startsWith('http')) {
            profile['avatar'] = 'lib/assets/images/avatar/$avatarVal';
          }
          _user = {...?_user, ...profile};
          notifyListeners();
        }
      }
    } catch (_) {
      // abaikan, tidak blokir login
    }
  }

  @visibleForTesting
  void setAuthStateForTesting({
    String? token,
    Map<String, dynamic>? user,
    bool? isAuthenticated,
  }) {
    _token = token ?? _token;
    _user = user ?? _user;
    if (isAuthenticated != null) {
      _isAuthenticated = isAuthenticated;
    }
    notifyListeners();
  }
}
