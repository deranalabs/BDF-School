import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../theme/brand.dart';

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
import '../../utils/api_client.dart';
import '../../state/auth_controller.dart';

class DaftarSiswaPage extends StatefulWidget {
  const DaftarSiswaPage({super.key});

  @override
  State<DaftarSiswaPage> createState() => _DaftarSiswaPageState();
}

class _DaftarSiswaPageState extends State<DaftarSiswaPage> {
  final _searchController = TextEditingController();
  String _selectedClass = 'Semua Kelas';

  List<_Student> _students = [];
  bool _isLoading = false;
  String? _error;
  late ApiClient _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<AuthController>());
    _fetchStudents();
  }

  List<_Student> get _filteredStudents {
    final query = _searchController.text.trim().toLowerCase();
    return _students.where((student) {
      final matchClass = _selectedClass == 'Semua Kelas' || student.kelas == _selectedClass;
      final matchQuery = query.isEmpty ||
          student.name.toLowerCase().contains(query) ||
          student.nis.toLowerCase().contains(query);
      return matchClass && matchQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchStudents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.get('/api/siswa');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final students = (data['data'] as List)
              .map<_Student>((student) => _Student(
                    id: student['id']?.toString(),
                    name: student['nama'] ?? '',
                    nis: student['nis'] ?? '',
                    kelas: student['kelas'] ?? '',
                    jurusan: student['jurusan'] ?? '',
                    alamat: student['alamat'] ?? '',
                    noTelp: student['no_telp'] ?? '',
                  ))
              .toList();
          
          setState(() {
            _students = students;
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Gagal memuat siswa');
        }
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to load students');
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat siswa: $e';
        _isLoading = false;
      });
    }
  }

  void _openAddStudentDialog() {
    final nameController = TextEditingController();
    final nisController = TextEditingController();
    final alamatController = TextEditingController();
    final noTelpController = TextEditingController();
    String? kelas;
    String? jurusan;
    const jurusanItems = ['IPA', 'IPS', 'Umum'];
    final baseDecoration = InputDecoration(
      filled: true,
      fillColor: BrandColors.gray100,
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
      labelStyle: BrandTextStyles.bodySecondary.copyWith(color: BrandColors.gray700),
      hintStyle: BrandTextStyles.bodySecondary.copyWith(color: BrandColors.gray500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          title: Text(
            'Tambah Siswa Baru',
            style: BrandTextStyles.subheading.copyWith(
              color: BrandColors.navy900,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: baseDecoration.copyWith(labelText: 'Nama Lengkap'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: nisController,
                        decoration: baseDecoration.copyWith(labelText: 'NIS'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: alamatController,
                  decoration: baseDecoration.copyWith(labelText: 'Alamat'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noTelpController,
                  decoration: baseDecoration.copyWith(labelText: 'No. Telepon'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: baseDecoration.copyWith(labelText: 'Jurusan'),
                  items: jurusanItems
                      .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                      .toList(),
                  onChanged: (v) => jurusan = v,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: baseDecoration.copyWith(labelText: 'Kelas'),
                  items: const [
                    DropdownMenuItem(value: 'Kelas 10', child: Text('Kelas 10')),
                    DropdownMenuItem(value: 'Kelas 11', child: Text('Kelas 11')),
                    DropdownMenuItem(value: 'Kelas 12', child: Text('Kelas 12')),
                  ],
                  onChanged: (v) => kelas = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: BrandColors.gray700)),
            ),
            ElevatedButton.icon(
              style: BrandButtons.primary(),
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    nisController.text.isEmpty ||
                    alamatController.text.isEmpty ||
                    noTelpController.text.isEmpty ||
                    kelas == null ||
                    jurusan == null) {
                  showFeedback(context, 'Harap lengkapi data (nama, NIS, alamat, no. telepon, kelas, jurusan)');
                  return;
                }

                try {
                  final res = await _api.post(
                    '/api/siswa',
                    body: jsonEncode({
                      'nama': nameController.text,
                      'nis': nisController.text,
                      'kelas': kelas,
                      'jurusan': jurusan,
                      'alamat': alamatController.text,
                      'no_telp': noTelpController.text,
                    }),
                  );

                  if (res.statusCode == 201) {
                    Navigator.of(context).pop();
                    await _fetchStudents();
                    showFeedback(context, 'Siswa berhasil ditambahkan');
                  } else {
                    final body = jsonDecode(res.body);
                    showFeedback(context, body['message']?.toString() ?? 'Gagal menambah siswa');
                  }
                } catch (e) {
                  showFeedback(context, 'Error: $e');
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan Data'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = _students.length;
    final activeStudents = _students.length; // belum ada field status, anggap semua aktif
    final kelasCount = _students.map((s) => s.kelas).toSet().length;

    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
    }
    
    void logout() async {
      try {
        final authController = Provider.of<AuthController>(context, listen: false);
        await authController.logout();
        if (!mounted) return;
        _scaffoldKey.currentState?.closeDrawer();
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
        title: const Text(
          'Daftar Siswa',
          style: BrandTextStyles.appBarTitle,
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
        child: RefreshIndicator(
          color: BrandColors.navy900,
          backgroundColor: Colors.white,
          onRefresh: _fetchStudents,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header navy dengan CTA dan stat
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  decoration: const BoxDecoration(
                    color: BrandColors.navy900,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manajemen Daftar Siswa',
                        style: BrandTextStyles.heading.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kelola data siswa dan pendaftaran akun',
                        style: BrandTextStyles.bodySecondary.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          style: BrandButtons.accent().copyWith(
                            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          onPressed: _openAddStudentDialog,
                          icon: const Icon(Icons.person_add, color: BrandColors.navy900),
                          label: const Text('Tambah Siswa Baru'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              value: totalStudents.toString(),
                              label: 'Total',
                              color: BrandColors.gray700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              value: activeStudents.toString(),
                              label: 'Aktif',
                              color: BrandColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              value: kelasCount.toString(),
                              label: 'Kelas',
                              color: BrandColors.amber400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Konten di panel putih
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kelas',
                        style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedClass,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: BrandColors.gray100,
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Semua Kelas', child: Text('Semua Kelas')),
                          DropdownMenuItem(value: 'Kelas 10', child: Text('Kelas 10')),
                          DropdownMenuItem(value: 'Kelas 11', child: Text('Kelas 11')),
                          DropdownMenuItem(value: 'Kelas 12', child: Text('Kelas 12')),
                        ],
                        onChanged: (v) => setState(() => _selectedClass = v ?? 'Semua Kelas'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cari Siswa',
                        style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Nama Siswa',
                          prefixIcon: const Icon(Icons.search, color: BrandColors.gray500),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: BrandColors.gray100,
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
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final students = _filteredStudents;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(BrandColors.amber400),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: BrandColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: BrandTextStyles.body.copyWith(color: BrandColors.gray700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: BrandButtons.primary(),
              onPressed: _fetchStudents,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 64,
              color: BrandColors.gray300,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data siswa',
              style: BrandTextStyles.bodySecondary.copyWith(color: BrandColors.gray700),
            ),
          ],
        ),
      );
    }

    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: BrandColors.gray300,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada siswa untuk filter/pencarian ini',
              style: BrandTextStyles.bodySecondary.copyWith(color: BrandColors.gray700),
            ),
          ],
        ),
      );
    }

    return Column(
      children: students
          .asMap()
          .entries
          .map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _StudentCard(
                  student: entry.value,
                  onEdit: () => _showEditStudentDialog(entry.value),
                  onDelete: () => _showDeleteStudentDialog(entry.value),
                ),
              ))
          .toList(),
    );
  }

  void _showEditStudentDialog(_Student student) {
    final nameController = TextEditingController(text: student.name);
    final nisController = TextEditingController(text: student.nis);
    final alamatController = TextEditingController(text: student.alamat);
    final noTelpController = TextEditingController(text: student.noTelp);
    String? kelas = student.kelas;
    String? jurusan = student.jurusan;
    const jurusanItems = ['IPA', 'IPS', 'Umum'];
    final baseDecoration = InputDecoration(
      filled: true,
      fillColor: BrandColors.gray100,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        title: Text(
          'Edit Siswa',
          style: BrandTextStyles.subheading.copyWith(
            color: BrandColors.navy900,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: baseDecoration.copyWith(labelText: 'Nama Siswa'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nisController,
                decoration: baseDecoration.copyWith(labelText: 'NIS'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: alamatController,
                decoration: baseDecoration.copyWith(labelText: 'Alamat'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noTelpController,
                decoration: baseDecoration.copyWith(labelText: 'No. Telepon'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: kelas,
                decoration: baseDecoration.copyWith(labelText: 'Kelas'),
                items: const ['Kelas 10', 'Kelas 11', 'Kelas 12']
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => kelas = v,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: jurusanItems.contains(jurusan) ? jurusan : null,
                decoration: baseDecoration.copyWith(labelText: 'Jurusan'),
                items: jurusanItems
                    .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                    .toList(),
                onChanged: (v) => jurusan = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: BrandColors.gray700)),
          ),
          ElevatedButton(
            style: BrandButtons.primary(),
            onPressed: () async {
              try {
                final response = await _api.put(
                  '/api/siswa/${student.id}',
                  body: jsonEncode({
                    'nama': nameController.text,
                    'nis': nisController.text,
                    'kelas': kelas,
                    'jurusan': jurusan,
                    'alamat': alamatController.text,
                    'no_telp': noTelpController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  Navigator.of(ctx).pop();
                  _fetchStudents();
                  showFeedback(context, 'Data siswa berhasil diperbarui');
                } else {
                  final body = jsonDecode(response.body);
                  showFeedback(context, body['message'] ?? 'Gagal memperbarui siswa');
                }
              } catch (e) {
                showFeedback(context, 'Error: $e');
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteStudentDialog(_Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Siswa', style: BrandTextStyles.subheading),
        content: Text('Apakah Anda yakin ingin menghapus siswa "${student.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(color: BrandColors.gray700)),
          ),
          ElevatedButton(
            style: BrandButtons.destructive(),
            onPressed: () async {
              try {
                final response = await _api.delete('/api/siswa/${student.id}');

                if (response.statusCode == 200) {
                  Navigator.of(ctx).pop();
                  _fetchStudents();
                  showFeedback(context, 'Siswa berhasil dihapus');
                } else {
                  final body = jsonDecode(response.body);
                  final msg = body['message']?.toString().toLowerCase().contains('constraint') == true
                      ? 'Tidak bisa menghapus: data siswa masih terpakai (presensi/nilai).'
                      : body['message'] ?? 'Gagal menghapus siswa';
                  showFeedback(context, msg);
                }
              } catch (e) {
                showFeedback(context, 'Error: $e');
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
        boxShadow: BrandShadows.card,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: BrandTextStyles.heading.copyWith(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: BrandTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({required this.student, required this.onEdit, required this.onDelete});

  final _Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BrandShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: BrandColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
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
                        style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: BrandColors.gray500),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: BrandColors.error),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Chip(text: 'NIS : ${student.nis}', color: BrandColors.gray700, bg: BrandColors.gray100),
                    _Chip(text: student.kelas, color: BrandColors.navy900, bg: BrandColors.sand200),
                    _Chip(text: student.jurusan, color: BrandColors.success, bg: BrandColors.gray100),
                  ],
                ),
                const SizedBox(height: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: BrandTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Student {
  final String? id;
  final String name;
  final String nis;
  final String kelas;
  final String jurusan;
  final String alamat;
  final String noTelp;

  const _Student({
    this.id,
    required this.name,
    required this.nis,
    required this.kelas,
    required this.jurusan,
    required this.alamat,
    required this.noTelp,
  });
}