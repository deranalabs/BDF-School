// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/auth_controller.dart';
import '../../utils/feedback.dart';
import '../../theme/brand.dart';
import 'register_screen.dart';
import '../dashboard/dashboard_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onLoginSuccess});

  final VoidCallback? onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();
  final _usernameFieldKey = GlobalKey();
  final _passwordFieldKey = GlobalKey();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _scrollTo(GlobalKey key) async {
    await Future.delayed(const Duration(milliseconds: 60));
    final ctx = key.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 260),
        alignment: 0.2,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    const radius = BorderRadius.all(Radius.circular(14));

    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: BrandColors.gray500, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: BrandColors.gray500),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: BrandColors.gray300, width: 1.1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: BrandColors.navy800, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final view = MediaQuery.of(context);
    final topSpacing = view.size.height > 720 ? 32.0 : 20.0;
    return Scaffold(
      backgroundColor: BrandColors.gray100,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final cardMaxWidth = isWide ? 420.0 : 400.0;
            final horizontalPadding = isWide ? 24.0 : 18.0;
            final logoSize = isWide ? 180.0 : 150.0;

            return Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(
                  isWide ? 32 : 20,
                  topSpacing,
                  isWide ? 32 : 20,
                  16,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardMaxWidth,
                    minWidth: 260,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: topSpacing * 0.2),
                      _BrandMark(size: logoSize),
                      const SizedBox(height: 24),
                      const Text(
                        'Selamat Datang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: BrandColors.navy900,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Masuk ke Admin Panel untuk melanjutkan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: BrandColors.gray700,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: BrandShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Username',
                                    style: TextStyle(
                                      color: BrandColors.gray900,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    key: _usernameFieldKey,
                                    controller: _usernameController,
                                    textInputAction: TextInputAction.next,
                                    scrollPadding: const EdgeInsets.only(bottom: 120),
                                    onTap: () => _scrollTo(_usernameFieldKey),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).nextFocus();
                                      _scrollTo(_passwordFieldKey);
                                    },
                                    style: const TextStyle(fontSize: 15.5),
                                    decoration: _inputDecoration(
                                      hintText: 'Masukkan username',
                                      prefixIcon: Icons.person_outline,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Username tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                      color: BrandColors.gray900,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    key: _passwordFieldKey,
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    scrollPadding: const EdgeInsets.only(bottom: 140),
                                    onTap: () => _scrollTo(_passwordFieldKey),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 22),
                                  _LoginButton(
                                    isLoading: _isLoading,
                                    onLogin: () async {
                                      if (_isLoading) return;
                                      final formValid = _formKey.currentState?.validate() ?? false;
                                      if (!formValid) return;
                                      FocusScope.of(context).unfocus();
                                      final auth = context.read<AuthController>();
                                      setState(() => _isLoading = true);
                                      try {
                                        await auth.login(
                                          _usernameController.text.trim(),
                                          _passwordController.text,
                                        );
                                        showFeedback(context, 'Login berhasil');
                                        if (!mounted) return;
                                        if (widget.onLoginSuccess != null) {
                                          widget.onLoginSuccess!();
                                        } else {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                          );
                                        }
                                      } on AuthException catch (e) {
                                        showFeedback(context, e.message);
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isLoading = false);
                                        }
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  const _DemoHint(),
                                  const SizedBox(height: 12),
                                  Center(
                                    child: TextButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                              );
                                            },
                                      child: const Text(
                                        'Belum punya akun? Daftar',
                                        style: TextStyle(
                                          color: BrandColors.navy800,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        '© ${DateTime.now().year} BDF School',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: BrandColors.gray500,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.size = 160});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset('lib/assets/images/logo_bulat.png', width: size, height: size);
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onLogin,
    this.isLoading = false,
  });

  final Future<void> Function() onLogin;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: BrandButtons.primary().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(54)),
          elevation: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled) ? 0 : 4,
          ),
        ),
        onPressed: isLoading ? null : onLogin,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          child: isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Memproses...',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : Row(
                  key: const ValueKey('idle'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.login_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E9F5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1F3B77), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Demo: admin / admin123 (huruf kecil)',
                  style: TextStyle(
                    color: Color(0xFF1F3B77),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.copy_rounded, size: 18, color: Color(0xFF1F3B77)),
            onPressed: () {
              showFeedback(context, 'Kredensial demo disalin');
            },
            tooltip: 'Salin kredensial demo',
          ),
        ],
      ),
    );
  }
}

