// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../tugas/tugas_page.dart';
import '../jadwal/jadwal_page.dart';
import '../presensi/presensi_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import 'nilai_detail.dart';
import '../../utils/api_client.dart';
import '../../state/auth_controller.dart';
import '../../theme/brand.dart';

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  final _searchController = TextEditingController();
  String _selectedKelas = 'Semua Kelas';
  List<_StudentRecord> _students = [];
  bool _isLoading = false;
  String? _error;
  late ApiClient _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<_StudentRecord> get _filteredStudents {
    final query = _searchController.text.toLowerCase();
    return _students.where((s) {
      final matchName = s.name.toLowerCase().contains(query);
      final matchKelas = _selectedKelas == 'Semua Kelas' || s.kelas == _selectedKelas;
      return matchName && matchKelas;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<AuthController>());
    _fetchStudents();
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
          final list = (data['data'] as List)
              .map((e) => _StudentRecord.fromApi(e))
              .toList();
          setState(() {
            _students = list;
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to load students');
        }
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: BrandColors.gray100,
      appBar: AppBar(
        backgroundColor: BrandColors.navy900,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Nilai', style: BrandTextStyles.appBarTitle),
      ),
      drawer: Sidebar(
        selectedIndex: 3,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(const TugasPage()),
        onTapJadwal: () => goTo(const JadwalPage()),
        onTapPresensi: () => goTo(const PresensiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onTapNilai: () => Navigator.of(context).pop(),
        onLogout: logout,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: BrandColors.navy900,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Manajemen Nilai',
                    style: BrandTextStyles.heading.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  'Kelola nilai siswa untuk semua mata pelajaran',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: BrandButtons.accent(),
                    onPressed: _showAddSubjectDialog,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: BrandColors.navy900),
                        SizedBox(width: 8),
                        Text(
                          'Tambah Mata Pelajaran',
                          style: TextStyle(
                            color: BrandColors.navy900,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: BrandColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BrandColors.gray300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKelas,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: const [
                          DropdownMenuItem(value: 'Semua Kelas', child: Text('Semua Kelas')),
                          DropdownMenuItem(value: 'Kelas 1', child: Text('Kelas 1')),
                          DropdownMenuItem(value: 'Kelas 2', child: Text('Kelas 2')),
                          DropdownMenuItem(value: 'Kelas 3', child: Text('Kelas 3')),
                          DropdownMenuItem(value: 'Kelas 4', child: Text('Kelas 4')),
                        ],
                        onChanged: (v) {
                          setState(() => _selectedKelas = v!);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BrandColors.gray300),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Nama Siswa',
                        hintStyle: TextStyle(color: BrandColors.gray500),
                        prefixIcon: Icon(Icons.search, color: BrandColors.gray500),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                _StatChip(
                  label: 'Total Siswa',
                  value: _students.length.toString(),
                  icon: Icons.people_alt,
                  color: BrandColors.navy900,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Ditampilkan',
                  value: _filteredStudents.length.toString(),
                  icon: Icons.visibility,
                  color: BrandColors.amber400,
                  textColor: BrandColors.navy900,
                ),
              ],
            ),
          ),
          // Student List
          Expanded(
            child: RefreshIndicator(
              color: BrandColors.navy900,
              backgroundColor: Colors.white,
              onRefresh: _fetchStudents,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddSubjectDialog() async {
    final formKey = GlobalKey<FormState>();
    final mapelCtrl = TextEditingController();
    final tugasCtrl = TextEditingController();
    final utsCtrl = TextEditingController();
    final uasCtrl = TextEditingController();
    String selectedSemester = 'Ganjil';
    String selectedTahun = '2024/2025';
    _StudentRecord? selectedSiswa;

    InputDecoration brandedInput(String label) => InputDecoration(
          labelText: label,
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
            borderSide: const BorderSide(color: BrandColors.navy900, width: 1.6),
          ),
        );

    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(builder: (context, setStateDialog) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tambah Nilai',
                          style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<_StudentRecord>(
                      value: selectedSiswa,
                      decoration: brandedInput('Pilih Siswa'),
                      items: _students
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text('${s.name} • ${s.kelas}'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setStateDialog(() => selectedSiswa = v),
                      validator: (v) => v == null ? 'Pilih siswa' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: mapelCtrl,
                      decoration: brandedInput('Mata Pelajaran'),
                      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tugasCtrl,
                            keyboardType: TextInputType.number,
                            decoration: brandedInput('Nilai Tugas'),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: utsCtrl,
                            keyboardType: TextInputType.number,
                            decoration: brandedInput('Nilai UTS'),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: uasCtrl,
                      keyboardType: TextInputType.number,
                      decoration: brandedInput('Nilai UAS'),
                      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSemester,
                            decoration: brandedInput('Semester'),
                            items: const [
                              DropdownMenuItem(value: 'Ganjil', child: Text('Ganjil')),
                              DropdownMenuItem(value: 'Genap', child: Text('Genap')),
                            ],
                            onChanged: (v) => setStateDialog(() => selectedSemester = v ?? 'Ganjil'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedTahun,
                            decoration: brandedInput('Tahun Ajaran'),
                            items: const [
                              DropdownMenuItem(value: '2024/2025', child: Text('2024/2025')),
                              DropdownMenuItem(value: '2023/2024', child: Text('2023/2024')),
                              DropdownMenuItem(value: '2022/2023', child: Text('2022/2023')),
                            ],
                            onChanged: (v) => setStateDialog(() => selectedTahun = v ?? '2024/2025'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: BrandButtons.primary().copyWith(
                              backgroundColor: MaterialStateProperty.all(BrandColors.gray500),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: BrandButtons.primary(),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  final response = await _api.post(
                                    '/api/nilai',
                                    body: jsonEncode({
                                      'siswa_id': selectedSiswa?.id,
                                      'mata_pelajaran': mapelCtrl.text.trim(),
                                      'tugas': int.tryParse(tugasCtrl.text) ?? 0,
                                      'uts': int.tryParse(utsCtrl.text) ?? 0,
                                      'uas': int.tryParse(uasCtrl.text) ?? 0,
                                      'semester': selectedSemester,
                                      'tahun_ajaran': selectedTahun,
                                    }),
                                  );

                                  if (response.statusCode == 201) {
                                    Navigator.of(context).pop();
                                    await _fetchStudents();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Nilai berhasil ditambahkan'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    final body = jsonDecode(response.body);
                                    throw Exception(body['message'] ?? 'Gagal menambah nilai');
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(BrandColors.navy900),
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 56, color: BrandColors.error.withOpacity(0.8)),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: BrandTextStyles.body.copyWith(color: BrandColors.gray700),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: BrandButtons.primary(),
              onPressed: _fetchStudents,
              child: const Text('Ulangi'),
            ),
          ],
        ),
      );
    }
    final students = _filteredStudents;
    if (_students.isEmpty) {
      return const Center(
        child: Text('Belum ada data siswa'),
      );
    }
    if (students.isEmpty) {
      return const Center(child: Text('Tidak ada hasil untuk filter/pencarian'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return _StudentCard(
          student: student,
          onTap: () {
            Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => NilaiDetailPage(
                  studentId: student.id,
                  studentName: student.name,
                  kelas: student.kelas,
                ),
              ),
            ).then((changed) {
              if (changed == true) {
                _fetchStudents();
              }
            });
          },
        );
      },
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({required this.student, required this.onTap});

  final _StudentRecord student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BrandShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: student.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.school_rounded,
                    size: 22,
                    color: student.color.computeLuminance() > 0.5 ? BrandColors.navy900 : Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: BrandTextStyles.subheading.copyWith(fontSize: 16, color: BrandColors.navy900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.kelas,
                        style: BrandTextStyles.caption.copyWith(color: BrandColors.gray700),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: BrandColors.sand200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.book_outlined, size: 16, color: BrandColors.navy900),
                      const SizedBox(width: 6),
                      Text(
                        '${student.mapelCount} mapel',
                        style: BrandTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: BrandColors.navy900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentRecord {
  final String? id;
  final String name;
  final String kelas;
  final int mapelCount;
  final String avatar;
  final Color color;

  const _StudentRecord({
    this.id,
    required this.name,
    required this.kelas,
    required this.mapelCount,
    required this.avatar,
    required this.color,
  });

  factory _StudentRecord.fromApi(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final firstChar = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final colors = [
      const Color(0xFFE3F2FD),
      const Color(0xFFE8F5E9),
      const Color(0xFFFFF3E0),
      const Color(0xFFF3E5F5),
    ];
    final colorIndex = (name.codeUnits.fold(0, (a, b) => a + b)) % colors.length;
    return _StudentRecord(
      id: json['id']?.toString(),
      name: name,
      kelas: json['kelas'] as String? ?? '',
      mapelCount: json['mapel_count'] as int? ?? 3,
      avatar: firstChar,
      color: colors[colorIndex],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.textColor = Colors.white,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(color: textColor.withOpacity(0.85), fontSize: 12),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}