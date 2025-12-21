import 'dart:async';

import 'package:flutter/material.dart';

enum UserRole { student, teacher }

class AuthUser {
  const AuthUser({required this.username, required this.role});

  final String username;
  final UserRole role;
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}

class AuthController extends ChangeNotifier {
  AuthUser? _user;
  AuthUser? get user => _user;

  static const _demoCredentials = [
    _Credential(username: 'siswa', password: 'siswa123', role: UserRole.student),
    _Credential(username: 'guru', password: 'guru123', role: UserRole.teacher),
  ];

  Future<void> login(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final normalized = username.trim().toLowerCase();

    final credential = _demoCredentials.firstWhere(
      (cred) => cred.username == normalized,
      orElse: () => const _Credential(username: '', password: '', role: UserRole.student),
    );

    if (credential.username.isEmpty) {
      throw AuthException('Pengguna tidak ditemukan');
    }
    if (credential.password != password.trim()) {
      throw AuthException('Password salah');
    }

    _user = AuthUser(username: normalized, role: credential.role);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

class _Credential {
  const _Credential({
    required this.username,
    required this.password,
    required this.role,
  });

  final String username;
  final String password;
  final UserRole role;
}
