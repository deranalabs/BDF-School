import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/brand.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../presensi/presensi_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../tugas/tugas_page.dart';
import '../auth/login_screen.dart';
import '../profile/profile_page.dart';
import '../../utils/feedback.dart';
import '../../state/auth_controller.dart';
import '../../utils/api_client.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool emailNotif = true;
  bool pushNotif = false;
  bool dailyDigest = false;
  bool darkMode = false;
  String language = 'id';
  bool _loading = false;
  ApiClient? _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _currentPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthController>(context, listen: false);
      setState(() {
        _api = ApiClient(auth);
      });
      _loadProfilePrefs();
    });
  }

  @override
  void dispose() {
    _currentPass.dispose();
    _newPass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  Future<void> _loadProfilePrefs() async {
    if (_api == null) return;
    setState(() => _loading = true);
    try {
      final res = await _api!.get('/api/profile');
      if (res.statusCode != 200) throw Exception('Gagal memuat pengaturan');
      final data = jsonDecode(res.body)['data'] as Map<String, dynamic>;
      setState(() {
        emailNotif = (data['email_notif'] ?? 1) == 1;
        pushNotif = (data['push_notif'] ?? 0) == 1;
        dailyDigest = (data['daily_digest'] ?? 0) == 1;
        darkMode = (data['dark_mode'] ?? 0) == 1;
        language = (data['language'] ?? 'id').toString();
      });
    } catch (e) {
      if (mounted) showFeedback(context, 'Gagal memuat pengaturan: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _savePrefs() async {
    if (_api == null) return;
    setState(() => _loading = true);
    try {
      final res = await _api!.put('/api/profile', body: {
        'email_notif': emailNotif,
        'push_notif': pushNotif,
        'daily_digest': dailyDigest,
        'dark_mode': darkMode,
        'language': language,
      });
      if (res.statusCode != 200) {
        final msg = jsonDecode(res.body)['message'] ?? 'Gagal menyimpan pengaturan';
        throw Exception(msg);
      }
      showFeedback(context, 'Pengaturan tersimpan');
    } catch (e) {
      if (mounted) showFeedback(context, 'Gagal menyimpan: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _changePassword() async {
    if (_api == null) return;
    if (_currentPass.text.isEmpty ||
        _newPass.text.isEmpty ||
        _confirmPass.text.isEmpty) {
      showFeedback(context, 'Lengkapi semua field password');
      return;
    }
    if (_newPass.text.length < 6) {
      showFeedback(context, 'Password baru minimal 6 karakter');
      return;
    }
    if (_newPass.text != _confirmPass.text) {
      showFeedback(context, 'Password baru dan konfirmasi tidak sama');
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await _api!.post('/api/auth/change-password', body: {
        'currentPassword': _currentPass.text,
        'newPassword': _newPass.text,
      });
      if (res.statusCode != 200) {
        final msg = jsonDecode(res.body)['message'] ?? 'Gagal mengubah password';
        throw Exception(msg);
      }
      showFeedback(context, 'Password berhasil diubah');
      _currentPass.clear();
      _newPass.clear();
      _confirmPass.clear();
    } catch (e) {
      if (mounted) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        showFeedback(context, 'Gagal mengubah password: $msg');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      await authController.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout gagal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
    }
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: BrandColors.navy900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Pengaturan', style: BrandTextStyles.appBarTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Sidebar(
        selectedIndex: 8,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(TugasPage()),
        onTapJadwal: () => goTo(JadwalPage()),
        onTapPresensi: () => goTo(PresensiPage()),
        onTapNilai: () => goTo(NilaiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapSettings: () => Navigator.of(context).pop(),
        onLogout: _logout,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _SectionCard(
                      icon: Icons.security,
                      iconColor: BrandColors.error,
                      title: 'Keamanan',
                      subtitle: 'Pengaturan keamanan dan privasi akun',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubah Password',
                            style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
                          ),
                          const SizedBox(height: 12),
                          _PasswordField(
                            controller: _currentPass,
                            hint: 'Password Saat Ini',
                          ),
                          const SizedBox(height: 12),
                          _PasswordField(
                            controller: _newPass,
                            hint: 'Password Baru',
                          ),
                          const SizedBox(height: 12),
                          _PasswordField(
                            controller: _confirmPass,
                            hint: 'Konfirmasi Password',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: BrandButtons.primary(),
                              onPressed: _loading ? null : _changePassword,
                              icon: const Icon(Icons.lock, color: Colors.white),
                              label: const Text('Ubah Password'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.notifications_active,
                      iconColor: BrandColors.amber400,
                      title: 'Notifikasi',
                      subtitle: 'Atur preferensi notifikasi Anda',
                      child: Column(
                        children: [
                          _SwitchTile(
                            title: 'Notifikasi Email',
                            subtitle: 'Terima pembaruan melalui email',
                            value: emailNotif,
                            onChanged: (v) => setState(() => emailNotif = v),
                          ),
                          const SizedBox(height: 12),
                          _SwitchTile(
                            title: 'Notifikasi Push',
                            subtitle: 'Notifikasi real-time di browser',
                            value: pushNotif,
                            onChanged: (v) => setState(() => pushNotif = v),
                          ),
                          const SizedBox(height: 12),
                          _SwitchTile(
                            title: 'Ringkasan Harian',
                            subtitle: 'Laporan aktivitas dikirim setiap hari',
                            value: dailyDigest,
                            onChanged: (v) => setState(() => dailyDigest = v),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: BrandButtons.primary(),
                              onPressed: _loading ? null : _savePrefs,
                              child: Text(
                                _loading ? 'Menyimpan...' : 'Simpan Pengaturan',
                                style: BrandTextStyles.body.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.language,
                      iconColor: BrandColors.info,
                      title: 'Tampilan',
                      subtitle: 'Sesuaikan tampilan aplikasi',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SwitchTile(
                            title: 'Mode Gelap',
                            subtitle: 'Ubah tema aplikasi menjadi gelap',
                            value: darkMode,
                            onChanged: (v) => setState(() => darkMode = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BrandShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: BrandColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: BrandTextStyles.caption.copyWith(color: BrandColors.gray700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.navy900, width: 2),
        ),
        filled: true,
        fillColor: BrandColors.gray100,
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A1E4A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF0A1E4A),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}