import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/student/dashboard_screen.dart';
import 'pages/auth/login_screen.dart';
import 'pages/teacher/teacher_dashboard_screen.dart';
import 'state/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: MaterialApp(
        title: 'BDF School',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F80FF)),
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthController>(
          builder: (_, auth, __) {
            final user = auth.user;
            if (user == null) return const LoginScreen();
            if (user.role == UserRole.teacher) {
              return const TeacherDashboardScreen();
            }
            return const DashboardScreen();
          },
        ),
      ),
    );
  }
}
