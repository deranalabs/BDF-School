import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../presensi/presensi_page.dart';
import '../profile/profile_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../tugas/tugas_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';

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

  final _currentPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();

  @override
  void dispose() {
    _currentPass.dispose();
    _newPass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
    }
    
    void logout() {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0A1F44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1F44),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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
        onLogout: logout,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kelola pengaturan aplikasi sesuai preferensi Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _SectionCard(
                      icon: Icons.security,
                      iconColor: Colors.red,
                      title: 'Keamanan',
                      subtitle: 'Pengaturan keamanan dan privasi akun',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ubah Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0A1E4A),
                            ),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A1E4A),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                if (_currentPass.text.isEmpty ||
                                    _newPass.text.isEmpty ||
                                    _confirmPass.text.isEmpty) {
                                  showFeedback(context, 'Lengkapi semua field password');
                                  return;
                                }
                                if (_newPass.text != _confirmPass.text) {
                                  showFeedback(context, 'Password baru dan konfirmasi tidak sama');
                                  return;
                                }
                                showFeedback(context, 'Password berhasil diubah');
                              },
                              icon: const Icon(Icons.lock, color: Colors.white),
                              label: const Text(
                                'Ubah Password',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.notifications_active,
                      iconColor: const Color(0xFFF5A524),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      icon: Icons.language,
                      iconColor: const Color(0xFF9B51E0),
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
                          const SizedBox(height: 16),
                          const Text(
                            'Bahasa',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0A1E4A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: language,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
                                DropdownMenuItem(value: 'en', child: Text('English')),
                              ],
                              onChanged: (v) => setState(() => language = v ?? 'id'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
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
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0A1E4A), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
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