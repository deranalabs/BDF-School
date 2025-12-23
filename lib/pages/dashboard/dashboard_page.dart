// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../presensi/presensi_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../tugas/tugas_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import 'sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => page),
      );
    }
    void logout() {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
    const background = Color(0xFFF3F5F9);
    const titleStyle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2F80FF),
    );
    const subtitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.black87,
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Dashboard',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      drawer: Sidebar(
        onTapDashboard: () => Navigator.of(context).pop(),
        onTapTugas: () => goTo(TugasPage()),
        onTapJadwal: () => goTo(JadwalPage()),
        onTapPresensi: () => goTo(PresensiPage()),
        onTapNilai: () => goTo(NilaiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapProfile: () => goTo(const ProfilePage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onLogout: logout,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Dashboard Admin', style: titleStyle),
              const SizedBox(height: 6),
              Text(
                'Selamat datang kembali! Berikut ringkasan aktivitas sekolah hari ini',
                style: subtitleStyle,
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: const _StatCard(
                          title: 'Total Siswa',
                          value: '245',
                          subtitle: '+12 dari bulan lalu',
                          gradient: LinearGradient(
                            colors: [Color(0xFFEAF3FF), Color(0xFFB0D3FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          icon: Icons.group_outlined,
                          iconBg: Color(0xFF2F80FF),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: const _StatCard(
                          title: 'Kehadiran Hari Ini',
                          value: '98%',
                          subtitle: '240 dari 245 siswa',
                          gradient: LinearGradient(
                            colors: [Color(0xFFE6FFF4), Color(0xFFC6F0DB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          icon: Icons.check_circle_outline,
                          iconBg: Color(0xFF219653),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: const _StatCard(
                          title: 'Tugas Aktif',
                          value: '12',
                          subtitle: '8 deadline minggu ini',
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFF5E6), Color(0xFFFFE3B0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          icon: Icons.assignment_outlined,
                          iconBg: Color(0xFFF2994A),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: const _StatCard(
                          title: 'Pengumuman',
                          value: '5',
                          subtitle: '2 belum dibaca',
                          gradient: LinearGradient(
                            colors: [Color(0xFFF3E8FF), Color(0xFFE0C7FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          icon: Icons.notifications_none_outlined,
                          iconBg: Color(0xFF9B51E0),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              _ActivityCard(
                title: 'Aktivitas Terbaru',
                activities: const [
                  _ActivityItem(
                    title: 'Tugas Matematika ditambahkan',
                    subtitle: 'Kelas 12A',
                    time: '5 menit lalu',
                  ),
                  _ActivityItem(
                    title: 'Presensi Kelas 11B diupdate',
                    subtitle: 'Kelas 11B',
                    time: '15 menit lalu',
                  ),
                  _ActivityItem(
                    title: 'Siswa baru terdaftar',
                    subtitle: 'Ahmad Rizki - Kelas 10A',
                    time: '1 jam lalu',
                  ),
                  _ActivityItem(
                    title: 'Pengumuman libur nasional',
                    subtitle: 'Semua Kelas',
                    time: '2 jam lalu',
                  ),
                  _ActivityItem(
                    title: 'Nilai UTS diinput',
                    subtitle: 'Kelas 12C',
                    time: '3 jam lalu',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.iconBg,
  });

  final String title;
  final String value;
  final String subtitle;
  final LinearGradient gradient;
  final IconData icon;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.title,
    required this.activities,
  });

  final String title;
  final List<_ActivityItem> activities;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildItems(),
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    final widgets = <Widget>[];
    for (var i = 0; i < activities.length; i++) {
      final item = activities[i];
      widgets.add(_ActivityRow(item: item));
      if (i != activities.length - 1) {
        widgets.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: Color(0xFFE6E6E6)),
        ));
      }
    }
    return widgets;
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final String title;
  final String subtitle;
  final String time;
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: CircleAvatar(
            radius: 4,
            backgroundColor: Color(0xFF2F80FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6C737F),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.time,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
