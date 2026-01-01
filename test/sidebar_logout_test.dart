import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bdf_school/pages/dashboard/sidebar.dart';
import 'package:bdf_school/state/auth_controller.dart';

class FakeAuthController extends AuthController {
  FakeAuthController() : super(baseUrl: '');

  bool loggedOut = false;

  @override
  Future<void> logout() async {
    loggedOut = true;
    notifyListeners();
  }
}

void main() {
  Widget wrap(Widget child, FakeAuthController controller) {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthController>.value(
        value: controller,
        child: Scaffold(
          drawer: child,
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('Sidebar logout memanggil AuthController.logout setelah konfirmasi', (tester) async {
    final controller = FakeAuthController();

    await tester.pumpWidget(wrap(Sidebar(onLogout: controller.logout), controller));

    // Buka drawer
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Tap tombol logout (label "Keluar")
    final logoutButton = find.text('Keluar');
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Dialog konfirmasi muncul, tekan "Keluar"
    await tester.tap(find.widgetWithText(TextButton, 'Keluar'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(controller.loggedOut, isTrue);
  });
}
