import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/auth_controller.dart';
import '../../utils/api_client.dart';
import '../../utils/feedback.dart';
import '../../theme/brand.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _fullName = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _fullName.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? suffix}) {
    const radius = BorderRadius.all(Radius.circular(14));
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: BrandColors.gray500, fontSize: 14),
      prefixIcon: Icon(icon, color: BrandColors.gray500),
      suffixIcon: suffix,
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
    final auth = Provider.of<AuthController>(context, listen: false);
    final api = ApiClient(auth);
    final view = MediaQuery.of(context);
    final topSpacing = view.size.height > 720 ? 32.0 : 20.0;

    Future<void> register() async {
      if (_loading) return;
      final valid = _formKey.currentState?.validate() ?? false;
      if (!valid) return;
      if (_password.text != _confirm.text) {
        showFeedback(context, 'Password dan konfirmasi tidak sama');
        return;
      }
      setState(() => _loading = true);
      try {
        final res = await api.postPublic('/api/auth/register', body: {
          'username': _username.text.trim(),
          'password': _password.text,
          'email': _email.text.trim(),
          'full_name': _fullName.text.trim(),
        });
        if (res.statusCode != 201) {
          throw Exception('Registrasi gagal: ${res.body}');
        }
        showFeedback(context, 'Registrasi berhasil, silakan login');
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } catch (e) {
        if (mounted) showFeedback(context, 'Gagal registrasi: $e');
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }

    return Scaffold(
      backgroundColor: BrandColors.gray100,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final cardMaxWidth = isWide ? 520.0 : 400.0;
            final horizontalPadding = isWide ? 24.0 : 18.0;
            final logoSize = isWide ? 180.0 : 150.0;

            return Center(
              child: SingleChildScrollView(
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
                        'Buat Akun Baru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: BrandColors.navy900,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Daftar untuk mengakses dashboard',
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nama Lengkap',
                                style: TextStyle(
                                  color: BrandColors.gray900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _fullName,
                                textInputAction: TextInputAction.next,
                                scrollPadding: const EdgeInsets.only(bottom: 120),
                                decoration: _inputDecoration(
                                  hint: 'Nama lengkap',
                                  icon: Icons.badge_outlined,
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Nama tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Email',
                                style: TextStyle(
                                  color: BrandColors.gray900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                scrollPadding: const EdgeInsets.only(bottom: 120),
                                decoration: _inputDecoration(
                                  hint: 'Alamat email',
                                  icon: Icons.email_outlined,
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!v.contains('@')) return 'Email tidak valid';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
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
                                controller: _username,
                                textInputAction: TextInputAction.next,
                                scrollPadding: const EdgeInsets.only(bottom: 120),
                                decoration: _inputDecoration(
                                  hint: 'Pilih username',
                                  icon: Icons.person_outline,
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Username tidak boleh kosong';
                                  }
                                  if (v.length < 3) return 'Min 3 karakter';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
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
                                controller: _password,
                                obscureText: _obscurePass,
                                textInputAction: TextInputAction.next,
                                scrollPadding: const EdgeInsets.only(bottom: 140),
                                decoration: _inputDecoration(
                                  hint: 'Minimal 6 karakter',
                                  icon: Icons.lock_outline,
                                  suffix: IconButton(
                                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                                    icon: Icon(
                                      _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: const Color(0xFF95A2B7),
                                    ),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
                                  if (v.length < 6) return 'Minimal 6 karakter';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Konfirmasi Password',
                                style: TextStyle(
                                  color: BrandColors.gray900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _confirm,
                                obscureText: _obscureConfirm,
                                textInputAction: TextInputAction.done,
                                scrollPadding: const EdgeInsets.only(bottom: 140),
                                decoration: _inputDecoration(
                                  hint: 'Ulangi password',
                                  icon: Icons.lock_clock_outlined,
                                  suffix: IconButton(
                                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                    icon: Icon(
                                      _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: const Color(0xFF95A2B7),
                                    ),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Konfirmasi password diperlukan';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 22),
                              _RegisterButton(
                                isLoading: _loading,
                                onPressed: _loading ? null : register,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              },
                        child: const Text(
                          'Sudah punya akun? Masuk',
                          style: TextStyle(
                            color: BrandColors.navy800,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
  const _BrandMark({this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset('lib/assets/images/logo_bulat.png', width: size, height: size);
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({required this.onPressed, required this.isLoading});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: BrandButtons.primary().copyWith(
          minimumSize: MaterialStateProperty.all(const Size.fromHeight(54)),
          elevation: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.disabled) ? 0 : 4,
          ),
        ),
        onPressed: onPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
          child: isLoading
              ? Row(
                  key: const ValueKey('reg_loading'),
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
                  key: const ValueKey('reg_idle'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.person_add_alt, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 17.5,
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
