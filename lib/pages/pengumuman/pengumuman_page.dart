// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../presensi/presensi_page.dart';
import '../tugas/tugas_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _targetController = TextEditingController();
  final _dateController = TextEditingController();
  final _messageController = TextEditingController();

  final List<_Announcement> _announcements = [
    _Announcement(
      title: 'Libur Nasional',
      badgeText: 'Libur',
      badgeColor: const Color(0xFF5FA8F5),
      description: 'Sekolah libur dalam rangka hari kemerdekaan',
      date: '15 Desember 2025',
      target: 'Semua Kelas',
    ),
    _Announcement(
      title: 'Ujian Tengah Semester',
      badgeText: 'Ujian',
      badgeColor: const Color(0xFFE86B6B),
      description:
          'Ujian Tengah Semester akan dimulai pada tanggal 20 Desember 2025. Harap siswa mempersiapkan diri dengan baik.',
      date: '20 Desember 2025',
      target: 'Semua Kelas',
    ),
    _Announcement(
      title: 'Lomba Karya Ilmiah',
      badgeText: 'Acara',
      badgeColor: const Color(0xFF45C27C),
      description:
          'Pendaftaran lomba karya ilmiah antar sekolah dibuka hingga 30 Desember 2025',
      date: '30 Desember 2025',
      target: 'Kelas 11',
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _targetController.dispose();
    _dateController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _openCreateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Buat Pengumuman Baru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Judul Pengumuman',
                  child: TextField(
                    controller: _titleController,
                    decoration: _inputDecoration('Masukkan judul pengumuman'),
                  ),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Kategori',
                  child: DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Pilih kategori'),
                    items: const [
                      DropdownMenuItem(value: 'Libur', child: Text('Libur')),
                      DropdownMenuItem(value: 'Ujian', child: Text('Ujian')),
                      DropdownMenuItem(value: 'Acara', child: Text('Acara')),
                    ],
                    onChanged: (v) => _categoryController.text = v ?? '',
                  ),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Target',
                  child: DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Pilih target'),
                    items: const [
                      DropdownMenuItem(value: 'Semua Kelas', child: Text('Semua Kelas')),
                      DropdownMenuItem(value: 'Kelas 10', child: Text('Kelas 10')),
                      DropdownMenuItem(value: 'Kelas 11', child: Text('Kelas 11')),
                      DropdownMenuItem(value: 'Kelas 12', child: Text('Kelas 12')),
                    ],
                    onChanged: (v) => _targetController.text = v ?? '',
                  ),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Tanggal',
                  child: TextField(
                    controller: _dateController,
                    decoration: _inputDecoration('mm/dd/yyyy').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Pesan',
                  child: TextField(
                    controller: _messageController,
                    maxLines: 3,
                    decoration: _inputDecoration('Masukkan isi pengumuman'),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_titleController.text.isEmpty ||
                          _dateController.text.isEmpty ||
                          _messageController.text.isEmpty ||
                          _categoryController.text.isEmpty ||
                          _targetController.text.isEmpty) {
                        showFeedback(context, 'Lengkapi judul, kategori, target, tanggal, dan pesan');
                        return;
                      }
                      Navigator.of(context).pop();
                      showFeedback(context, 'Pengumuman diposting');
                    },
                    child: const Text(
                      'Posting Pengumuman',
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
        );
      },
    );
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

    const titleStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: Color(0xFF2F80FF),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.black87,
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Pengumuman',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 5,
        onTapDashboard: () => goTo(DashboardScreen()),
        onTapTugas: () => goTo(TugasPage()),
        onTapJadwal: () => goTo(JadwalPage()),
        onTapPresensi: () => goTo(PresensiPage()),
        onTapNilai: () => goTo(NilaiPage()),
        onTapPengumuman: () => Navigator.of(context).pop(),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manajemen Pengumuman', style: titleStyle),
                    const SizedBox(height: 6),
                    const Text(
                      'Kelola dan publikasikan pengumuman untuk siswa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: 200,
                      height: 42,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _openCreateDialog,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Buat Pengumuman',
                          style: TextStyle(
                            fontSize: 14,
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
              ..._announcements.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _AnnouncementCard(data: item),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2F80FF), width: 1.2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.data});

  final _Announcement data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_outlined, color: Color(0xFF5B8DEF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: data.badgeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            data.badgeText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: data.badgeColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () {},
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFD9534F)),
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 6),
                        Text(
                          data.date,
                          style: const TextStyle(
                            color: Color(0xFF4A5568),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 18),
                        const Icon(Icons.groups_outlined, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 6),
                        Text(
                          data.target,
                          style: const TextStyle(
                            color: Color(0xFF4A5568),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Announcement {
  final String title;
  final String badgeText;
  final Color badgeColor;
  final String description;
  final String date;
  final String target;

  const _Announcement({
    required this.title,
    required this.badgeText,
    required this.badgeColor,
    required this.description,
    required this.date,
    required this.target,
  });
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
