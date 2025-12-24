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
      description: 'Sekolah libur dalam rangka hari natal',
      date: '25 Desember 2025',
      target: 'Semua Kelas',
    ),
    _Announcement(
      title: 'Ujian Tengah Semester',
      description: 'Harap siswa mempersiapkan diri dengan baik',
      date: '5 Desember 2025',
      target: 'Semua Kelas',
    ),
    _Announcement(
      title: 'Lomba Karya Ilmiah',
      description: 'Pendaftaran lomba karya ilmiah antar sekolah dibuka hingga 30 Desember 2025',
      date: '5 Desember 2025',
      target: 'Semua Kelas',
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
          backgroundColor: const Color(0xFF0A1E4A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  _LabeledField(
                    label: 'Judul Pengumuman',
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Masukkan judul'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: 'Kategori',
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1A3A6B),
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Pilih kategori'),
                      items: const [
                        DropdownMenuItem(value: 'Libur', child: Text('Libur')),
                        DropdownMenuItem(value: 'Ujian', child: Text('Ujian')),
                        DropdownMenuItem(value: 'Acara', child: Text('Acara')),
                      ],
                      onChanged: (v) => _categoryController.text = v ?? '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: 'Target',
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1A3A6B),
                      style: const TextStyle(color: Colors.white),
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
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: 'Tanggal',
                    child: TextField(
                      controller: _dateController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('dd/mm/yyyy').copyWith(
                        suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: 'Pesan',
                    child: TextField(
                      controller: _messageController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Masukkan isi pengumuman'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8D5B5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_titleController.text.isEmpty ||
                            _dateController.text.isEmpty ||
                            _messageController.text.isEmpty ||
                            _categoryController.text.isEmpty ||
                            _targetController.text.isEmpty) {
                          showFeedback(context, 'Lengkapi semua field');
                          return;
                        }
                        Navigator.of(context).pop();
                        showFeedback(context, 'Pengumuman berhasil dibuat');
                      },
                      child: const Text(
                        'Buat Pengumuman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A1E4A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1F44),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Pengumuman',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 5,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(TugasPage()),
        onTapJadwal: () => goTo(JadwalPage()),
        onTapPresensi: () => goTo(PresensiPage()),
        onTapNilai: () => goTo(NilaiPage()),
        onTapPengumuman: () => Navigator.of(context).pop(),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onLogout: logout,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section dengan latar gelap
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF0A1F44),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manajemen Pengumuman',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kelola dan publikasikan pengumuman untuk siswa',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB45B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          elevation: 0,
                        ),
                        onPressed: _openCreateDialog,
                        icon: const Icon(Icons.add, color: Color(0xFF0A1F44)),
                        label: const Text(
                          'Buat Pengumuman',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0A1F44),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Konten daftar pengumuman di panel terang
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
                  children: _announcements.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _AnnouncementCard(data: item),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8D5B5), width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.data});

  final _Announcement data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A1E4A),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                data.date,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.groups, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                data.target,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
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
  final String description;
  final String date;
  final String target;

  const _Announcement({
    required this.title,
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}