// This is a basic Flutter widget test.

// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bdf_school/state/auth_controller.dart';
import 'package:bdf_school/pages/auth/login_screen.dart';

class _FakeAuthController extends AuthController {
  @override
  Future<bool> checkAuthStatus() async {
    // Jangan panggil jaringan saat test.
    return false;
  }

  @override
  Future<void> login(String username, String password) async {
    // No-op untuk menghindari HTTP.
  }
}

void main() {
  testWidgets('LoginScreen renders without crashing', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>(
        create: (_) => _FakeAuthController(),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Selamat Datang'), findsOneWidget);
  });
}
