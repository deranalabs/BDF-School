import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../dashboard/sidebar.dart';
import '../presensi/presensi_page.dart';
import '../tugas/tugas_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';

class DaftarSiswaPage extends StatefulWidget {
  const DaftarSiswaPage({super.key});

  @override
  State<DaftarSiswaPage> createState() => _DaftarSiswaPageState();
}

class _DaftarSiswaPageState extends State<DaftarSiswaPage> {
  final _searchController = TextEditingController();
  String _selectedClass = 'Semua Kelas';

  final List<_Student> _students = const [
    _Student(
      name: 'Ahmad Fauzi',
      nis: '202503',
      kelas: 'Kelas 1',
      email: 'ahmad.fauzi@student.com',
      phone: '081234567890',
      status: 'Aktif',
      initial: 'A',
    ),
    _Student(
      name: 'Bayu Mulyana',
      nis: '202501',
      kelas: 'Kelas 2',
      email: 'bayu.mulyana@student.com',
      phone: '081234565431',
      status: 'Aktif',
      initial: 'B',
    ),
    _Student(
      name: 'Dava Pratama',
      nis: '202502',
      kelas: 'Kelas 3',
      email: 'dava.pratama@student.com',
      phone: '080987654321',
      status: 'Aktif',
      initial: 'D',
    ),
    _Student(
      name: 'Fira Riyanti',
      nis: '202503',
      kelas: 'Kelas 4',
      email: 'fira.riyanti@student.com',
      phone: '089876123450',
      status: 'Aktif',
      initial: 'F',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddStudentDialog() {
    final nameController = TextEditingController();
    final nisController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    String? kelas;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0A1E4A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tambah Siswa Baru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Nama Lengkap',
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Nama lengkap'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'NIS',
                        child: TextField(
                          controller: nisController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('NIS'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Email',
                        child: TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('email@student.com'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'No. Telepon',
                        child: TextField(
                          controller: phoneController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('08123456789'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: 'Kelas',
                  child: DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF1A3A6B),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Pilih kelas'),
                    items: const [
                      DropdownMenuItem(value: 'Kelas 10', child: Text('Kelas 10')),
                      DropdownMenuItem(value: 'Kelas 11', child: Text('Kelas 11')),
                      DropdownMenuItem(value: 'Kelas 12', child: Text('Kelas 12')),
                    ],
                    onChanged: (v) => kelas = v,
                  ),
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: 'Alamat',
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Alamat lengkap'),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Akun Login Siswa',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Username',
                              child: TextField(
                                controller: usernameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration('Username'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LabeledField(
                              label: 'Password',
                              child: TextField(
                                controller: passwordController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration('Password'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8D5B5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          nisController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          kelas == null ||
                          usernameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showFeedback(context, 'Lengkapi semua field');
                        return;
                      }
                      Navigator.of(context).pop();
                      showFeedback(context, 'Siswa berhasil ditambahkan');
                    },
                    icon: const Icon(Icons.person_add, color: Color(0xFF0A1E4A)),
                    label: const Text(
                      'Daftarkan Siswa',
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
        backgroundColor: const Color(0xFF0A1E4A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Daftar Siswa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 6,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(const TugasPage()),
        onTapJadwal: () => goTo(const JadwalPage()),
        onTapPresensi: () => goTo(const PresensiPage()),
        onTapNilai: () => goTo(NilaiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => Navigator.of(context).pop(),
        onTapSettings: () => goTo(const PengaturanPage()),
        onLogout: logout,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with dark background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF0A1E4A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manajemen Daftar Siswa',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kelola data siswa dan pendaftaran akun',
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
                          backgroundColor: const Color(0xFFE8D5B5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: _openAddStudentDialog,
                        icon: const Icon(Icons.person_add, color: Color(0xFF0A1E4A)),
                        label: const Text(
                          'Tambah Siswa Baru',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0A1E4A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            value: '4',
                            label: 'Total',
                            color: Color(0xFF5B8DEF),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            value: '4',
                            label: 'Aktif',
                            color: Color(0xFF45C27C),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            value: '3',
                            label: 'Kelas',
                            color: Color(0xFFE67E22),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content panel on light background
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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
                        value: _selectedClass,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Semua Kelas', child: Text('Semua Kelas')),
                          DropdownMenuItem(value: 'Kelas 10', child: Text('Kelas 10')),
                          DropdownMenuItem(value: 'Kelas 11', child: Text('Kelas 11')),
                          DropdownMenuItem(value: 'Kelas 12', child: Text('Kelas 12')),
                        ],
                        onChanged: (v) => setState(() => _selectedClass = v ?? 'Semua Kelas'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cari Siswa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Nama Siswa',
                        prefixIcon: const Icon(Icons.search, color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._students.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _StudentCard(student: s),
                    )),
                  ],
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({required this.student});

  final _Student student;

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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                student.initial,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B8DEF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 16,
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
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Chip(text: 'NIS : ${student.nis}', color: Colors.black54, bg: Colors.grey[200]!),
                    _Chip(text: student.kelas, color: const Color(0xFF5B8DEF), bg: const Color(0xFFE8F0FF)),
                    _Chip(text: student.status, color: const Color(0xFF45C27C), bg: const Color(0xFFE8F8EF)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    _InfoRow(icon: Icons.email_outlined, text: student.email),
                    _InfoRow(icon: Icons.phone_outlined, text: student.phone),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.color, required this.bg});

  final String text;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black54),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _Student {
  final String name;
  final String nis;
  final String kelas;
  final String email;
  final String phone;
  final String status;
  final String initial;

  const _Student({
    required this.name,
    required this.nis,
    required this.kelas,
    required this.email,
    required this.phone,
    required this.status,
    required this.initial,
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