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

  final List<_Student> _students = const [
    _Student(
      name: 'Ahmad Rizki',
      nis: '2023001',
      kelas: 'Kelas 12A',
      email: 'ahmad.rizki@student.com',
      phone: '081234567890',
      status: 'Aktif',
    ),
    _Student(
      name: 'Dina Putri',
      nis: '2023002',
      kelas: 'Kelas 11B',
      email: 'dina.putri@student.com',
      phone: '081298765432',
      status: 'Aktif',
    ),
    _Student(
      name: 'Budi Santoso',
      nis: '2023003',
      kelas: 'Kelas 10C',
      email: 'budi.santoso@student.com',
      phone: '081212345678',
      status: 'Nonaktif',
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Nama Lengkap',
                        child: TextField(
                          controller: nameController,
                          decoration: _inputDecoration('Nama lengkap siswa'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'NIS',
                        child: TextField(
                          controller: nisController,
                          decoration: _inputDecoration('Nomor Induk Siswa'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Email',
                        child: TextField(
                          controller: emailController,
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
                          decoration: _inputDecoration('081234567890'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Kelas',
                  child: DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Pilih kelas'),
                    items: const [
                      DropdownMenuItem(value: 'Kelas 10', child: Text('Kelas 10')),
                      DropdownMenuItem(value: 'Kelas 11', child: Text('Kelas 11')),
                      DropdownMenuItem(value: 'Kelas 12', child: Text('Kelas 12')),
                    ],
                    onChanged: (v) => kelas = v,
                  ),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Alamat',
                  child: TextField(
                    decoration: _inputDecoration('Alamat lengkap siswa'),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Akun Login Siswa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Username',
                              child: TextField(
                                controller: usernameController,
                                decoration: _inputDecoration('Username untuk login'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LabeledField(
                              label: 'Password',
                              child: TextField(
                                controller: passwordController,
                                decoration: _inputDecoration('Password awal'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          nisController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          kelas == null ||
                          usernameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showFeedback(context, 'Lengkapi nama, NIS, email, telepon, kelas, username, dan password');
                        return;
                      }
                      Navigator.of(context).pop();
                      showFeedback(context, 'Siswa berhasil didaftarkan');
                    },
                    icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
                    label: const Text(
                      'Daftarkan Siswa',
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
          'Daftar Siswa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 6,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(TugasPage()),
        onTapJadwal: () => goTo(JadwalPage()),
        onTapPresensi: () => goTo(PresensiPage()),
        onTapNilai: () => goTo(NilaiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => Navigator.of(context).pop(),
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
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daftar Siswa', style: titleStyle),
                    const SizedBox(height: 6),
                    const Text(
                      'Kelola data siswa dan pendaftaran akun',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: 220,
                      height: 42,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _openAddStudentDialog,
                        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
                        label: const Text(
                          'Tambah Siswa Baru',
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
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.group_outlined,
                      value: '4',
                      label: 'Total Siswa',
                      color: Color(0xFF5B8DEF),
                      bg: Color(0xFFE8F0FF),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.person_outline,
                      value: '4',
                      label: 'Siswa Aktif',
                      color: Color(0xFF45C27C),
                      bg: Color(0xFFE8F8EF),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.school_outlined,
                      value: '7',
                      label: 'Total Kelas',
                      color: Color(0xFF9AA5B5),
                      bg: Color(0xFFF1F3F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelas',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Semua Kelas'),
                      initialValue: 'all',
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Semua Kelas')),
                        DropdownMenuItem(value: '10', child: Text('Kelas 10')),
                        DropdownMenuItem(value: '11', child: Text('Kelas 11')),
                        DropdownMenuItem(value: '12', child: Text('Kelas 12')),
                      ],
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Cari Siswa',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      decoration: _inputDecoration('Nama, NIS, atau email...').copyWith(
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA5B5)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ..._students.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _StudentCard(student: s),
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.bg,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
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
    final statusColor = student.status == 'Aktif' ? const Color(0xFF45C27C) : const Color(0xFFD9534F);
    final statusBg = student.status == 'Aktif' ? const Color(0xFFE8F8EF) : const Color(0xFFFDECEC);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
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
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE9EDFF),
                child: Text(
                  student.name.substring(0, 1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5B8DEF),
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
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                        ),
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
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _Chip(text: 'NIS: ${student.nis}', color: const Color(0xFF6B7280), bg: const Color(0xFFF1F3F6)),
                        _Chip(text: student.kelas, color: const Color(0xFF2F80FF), bg: const Color(0xFFE8F0FF)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        student.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
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
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF4A5568),
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

  const _Student({
    required this.name,
    required this.nis,
    required this.kelas,
    required this.email,
    required this.phone,
    required this.status,
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
