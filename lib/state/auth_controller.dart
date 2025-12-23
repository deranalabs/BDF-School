import 'package:flutter/foundation.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthController extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String username, String password) async {
    // Demo credential: admin / admin123
    if (username.trim() == 'admin' && password == 'admin123') {
      _isAuthenticated = true;
      notifyListeners();
      return;
    }
    throw const AuthException('Username atau password salah');
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
