import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bdf_school/pages/auth/login_screen.dart';
import 'package:bdf_school/state/auth_controller.dart';

class FakeAuthController extends AuthController {
  FakeAuthController() : super(baseUrl: '');
}

void main() {
  Widget wrapWithProvider(Widget child) {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthController>(
        create: (_) => FakeAuthController(),
        child: child,
      ),
    );
  }

  testWidgets('LoginScreen menampilkan form login', (tester) async {
    await tester.pumpWidget(wrapWithProvider(const LoginScreen()));

    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Belum punya akun? Daftar'), findsOneWidget);

    // Dua TextFormField: username & password.
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('Tombol toggle visibilitas password berubah ikon', (tester) async {
    await tester.pumpWidget(wrapWithProvider(const LoginScreen()));

    // Ikon awal adalah visibility_outlined (tersembunyi).
    final showIcon = find.byIcon(Icons.visibility_outlined);
    expect(showIcon, findsOneWidget);

    await tester.tap(showIcon);
    await tester.pumpAndSettle();

    // Setelah ditekan, ikon berubah menjadi visibility_off_outlined.
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
