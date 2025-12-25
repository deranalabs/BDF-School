// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../state/auth_controller.dart';
import '../../utils/feedback.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    const radius = BorderRadius.all(Radius.circular(14));
    const outlineColor = Color(0xFFD7DDE5);

    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF9AA5B5), fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF95A2B7)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: outlineColor, width: 1.1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Color(0xFF0F1F5C), width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  const _BrandMark(),
                  const SizedBox(height: 24),
                  const Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1F5C),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Masuk ke Admin Panel untuk melanjutkan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 15.5),
                          decoration: _inputDecoration(
                            hintText: 'Masukkan username',
                            prefixIcon: Icons.person_outline,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 15.5),
                          decoration: _inputDecoration(
                            hintText: 'Masukkan password',
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF95A2B7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _LoginButton(
                          onLogin: () async {
                            FocusScope.of(context).unfocus();
                            final auth = context.read<AuthController>();
                            try {
                              await auth.login(
                                _usernameController.text,
                                _passwordController.text,
                              );
                              showFeedback(context, 'Login berhasil');
                            } on AuthException catch (e) {
                              showFeedback(context, e.message);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        // Debug connection test button
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                final response = await http.post(
                                  Uri.parse('http://192.168.110.83:3000/api/auth/login'),
                                  body: jsonEncode({'username': 'admin', 'password': 'admin123'}),
                                  headers: {'Content-Type': 'application/json'},
                                );
                                showFeedback(context, 'Test: ${response.statusCode} - ${response.body}');
                              } catch (e) {
                                showFeedback(context, 'Test Error: $e');
                              }
                            },
                            child: const Text(
                              'Test Connection',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E8EF)),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Demo Admin',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F1F5C),
                                  fontSize: 13.5,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Username: admin\nPassword: admin123',
                                style: TextStyle(
                                  color: Color(0xFF4A5568),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    '© 2025 BDF School',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8E95A9),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Image.asset('lib/assets/images/logo_bulat.png', width: 160, height: 160);
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onLogin});

  final Future<void> Function() onLogin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E1B4F),
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onLogin,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Masuk',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoHint extends StatelessWidget {
  const _DemoHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD7E4FF)),
      ),
      child: Wrap(
        runSpacing: 6,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: const [
          Text(
            'Akun demo administrator:',
            style: TextStyle(
              color: Color(0xFF1F3B77),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'admin / admin123',
                style: TextStyle(
                  color: Color(0xFF2F80FF),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Pastikan huruf kecil semua',
                style: TextStyle(
                  color: Color(0xFF4A4A4A),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
