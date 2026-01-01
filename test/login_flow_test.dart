import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bdf_school/pages/auth/login_screen.dart';
import 'package:bdf_school/state/auth_controller.dart';

class FakeAuthController extends AuthController {
  FakeAuthController() : super(baseUrl: '');

  bool loggedIn = false;

  @override
  bool get isAuthenticated => loggedIn;

  @override
  Future<void> login(String username, String password) async {
    loggedIn = true;
    notifyListeners();
  }

  @override
  Future<bool> checkAuthStatus() async => loggedIn;
}

void main() {
  Widget wrapWithProvider(AuthController controller) {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthController>.value(
        value: controller,
        child: const Scaffold(body: LoginScreen()),
      ),
    );
  }

  testWidgets('Alur login memanggil AuthController.login dan set loggedIn', (tester) async {
    final controller = FakeAuthController();

    await tester.pumpWidget(wrapWithProvider(controller));

    final usernameField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    await tester.enterText(usernameField, 'admin');
    await tester.enterText(passwordField, 'admin123');

    final loginButtonFinder = find.widgetWithText(ElevatedButton, 'Masuk');
    expect(loginButtonFinder, findsOneWidget);
    await tester.ensureVisible(loginButtonFinder);
    await tester.tap(loginButtonFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(controller.loggedIn, isTrue);
  });
}
