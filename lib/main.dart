import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/dashboard/dashboard_page.dart';
import 'pages/auth/login_screen.dart';
import 'state/auth_controller.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController()..checkAuthStatus(),
      child: MaterialApp(
        title: 'BDF School',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F80FF)),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            hintStyle: const TextStyle(color: Color(0xFF9AA5B5), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFD7DDE5), width: 1.1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFD7DDE5), width: 1.1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0F1F5C), width: 1.4),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: const Color(0xFF0E1B4F),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0x3310216A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.pressed)
                    ? const Color(0xFF0E1B4F).withValues(alpha: 0.12)
                    : null,
              ),
              elevation: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.disabled) ? 0 : 4,
              ),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Color(0xFF4A4A4A), fontSize: 14, height: 1.4),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthController>(
          builder: (_, auth, __) {
            if (auth.isAuthenticated) {
              return const DashboardScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
