// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../tugas/tugas_page.dart';
import '../jadwal/jadwal_page.dart';
import '../presensi/presensi_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../../utils/feedback.dart';
import '../auth/login_screen.dart';

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  final _searchController = TextEditingController();

  final _records = const [
    _GradeRecord(name: 'Ahmad Rizki', kelas: '12A', mapel: 'Matematika', jenis: 'UTS', nilai: 85, tanggal: '15/12/2025', grade: 'B'),
    _GradeRecord(name: 'Siti Nurhaliza', kelas: '12A', mapel: 'Matematika', jenis: 'UTS', nilai: 92, tanggal: '15/12/2025', grade: 'A'),
    _GradeRecord(name: 'Budi Santoso', kelas: '12A', mapel: 'Fisika', jenis: 'Tugas', nilai: 78, tanggal: '18/12/2025', grade: 'C'),
    _GradeRecord(name: 'Dewi Lestari', kelas: '11B', mapel: 'Bahasa Indonesia', jenis: 'Ulangan Harian', nilai: 88, tanggal: '20/12/2025', grade: 'B'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
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
          'Nilai',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 3,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(const TugasPage()),
        onTapJadwal: () => goTo(const JadwalPage()),
        onTapPresensi: () => goTo(const PresensiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapProfile: () => goTo(const ProfilePage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onTapNilai: () => Navigator.of(context).pop(),
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
                    const Text(
                      'Manajemen Nilai',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F80FF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola nilai siswa untuk semua mata pelajaran',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _showAddScoreDialog,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Input Nilai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _FilterCard(searchController: _searchController),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(14, 14, 14, 10),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text('Nilai', style: TextStyle(fontWeight: FontWeight.w700))),
                          Expanded(flex: 1, child: Text('Grade', style: TextStyle(fontWeight: FontWeight.w700))),
                          Expanded(flex: 2, child: Text('Tanggal', style: TextStyle(fontWeight: FontWeight.w700))),
                          SizedBox(width: 70, child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.w700))),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE6E6E6)),
                    ..._records.map((r) => _GradeRow(record: r)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddScoreDialog() async {
    final nameController = TextEditingController();
    final nilaiController = TextEditingController();
    String? kelas;
    String? mapel;
    String? jenis;
    DateTime? tanggal;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          'Input Nilai Baru',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _LabeledField(
                      label: 'Nama Siswa',
                      child: TextField(
                        controller: nameController,
                        decoration: _fieldDecoration('Masukkan nama siswa'),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: 'Kelas',
                            child: DropdownButtonFormField<String>(
                              decoration: _fieldDecoration('Pilih kelas'),
                              initialValue: kelas,
                              items: const [
                                DropdownMenuItem(value: '12A', child: Text('12A')),
                                DropdownMenuItem(value: '12B', child: Text('12B')),
                                DropdownMenuItem(value: '11B', child: Text('11B')),
                              ],
                              onChanged: (v) => setState(() => kelas = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledField(
                            label: 'Mata Pelajaran',
                            child: DropdownButtonFormField<String>(
                              decoration: _fieldDecoration('Pilih mapel'),
                              initialValue: mapel,
                              items: const [
                                DropdownMenuItem(value: 'Matematika', child: Text('Matematika')),
                                DropdownMenuItem(value: 'Fisika', child: Text('Fisika')),
                                DropdownMenuItem(value: 'Bahasa Indonesia', child: Text('Bahasa Indonesia')),
                              ],
                              onChanged: (v) => setState(() => mapel = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: 'Jenis Ujian',
                            child: DropdownButtonFormField<String>(
                              decoration: _fieldDecoration('Pilih jenis'),
                              initialValue: jenis,
                              items: const [
                                DropdownMenuItem(value: 'UTS', child: Text('UTS')),
                                DropdownMenuItem(value: 'Ulangan Harian', child: Text('Ulangan Harian')),
                                DropdownMenuItem(value: 'Tugas', child: Text('Tugas')),
                              ],
                              onChanged: (v) => setState(() => jenis = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledField(
                            label: 'Nilai',
                            child: TextField(
                              controller: nilaiController,
                              keyboardType: TextInputType.number,
                              decoration: _fieldDecoration('0-100'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _LabeledField(
                      label: 'Tanggal',
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) setState(() => tanggal = picked);
                        },
                        child: InputDecorator(
                          decoration: _fieldDecoration('mm/dd/yyyy'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tanggal == null
                                    ? 'mm/dd/yyyy'
                                    : '${tanggal!.month}/${tanggal!.day}/${tanggal!.year}',
                                style: TextStyle(
                                  color: tanggal == null ? const Color(0xFF9AA5B5) : Colors.black87,
                                ),
                              ),
                              const Icon(Icons.calendar_month_outlined, color: Color(0xFF9AA5B5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (nameController.text.isEmpty ||
                              nilaiController.text.isEmpty ||
                              kelas == null ||
                              mapel == null ||
                              jenis == null ||
                              tanggal == null) {
                            showFeedback(context, 'Lengkapi nama, nilai, kelas, mapel, jenis, dan tanggal');
                            return;
                          }
                          final value = int.tryParse(nilaiController.text);
                          if (value == null || value < 0 || value > 100) {
                            showFeedback(context, 'Nilai harus 0-100');
                            return;
                          }
                          Navigator.of(context).pop();
                          showFeedback(context, 'Nilai disimpan');
                        },
                        child: const Text(
                          'Simpan Nilai',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9AA5B5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        borderSide: const BorderSide(color: Color(0xFF2F80FF), width: 1.3),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabeledField(
            label: 'Kelas',
            child: DropdownButtonFormField<String>(
              decoration: _fieldDecoration('Semua Kelas'),
              items: const [
                DropdownMenuItem(value: 'Semua Kelas', child: Text('Semua Kelas')),
                DropdownMenuItem(value: 'Kelas 12A', child: Text('Kelas 12A')),
                DropdownMenuItem(value: 'Kelas 11B', child: Text('Kelas 11B')),
              ],
              onChanged: (_) {},
              initialValue: 'Semua Kelas',
            ),
          ),
          _LabeledField(
            label: 'Mata Pelajaran',
            child: DropdownButtonFormField<String>(
              decoration: _fieldDecoration('Semua Mata Pelajaran'),
              items: const [
                DropdownMenuItem(value: 'Semua Mata Pelajaran', child: Text('Semua Mata Pelajaran')),
                DropdownMenuItem(value: 'Matematika', child: Text('Matematika')),
                DropdownMenuItem(value: 'Fisika', child: Text('Fisika')),
                DropdownMenuItem(value: 'Bahasa Indonesia', child: Text('Bahasa Indonesia')),
              ],
              onChanged: (_) {},
              initialValue: 'Semua Mata Pelajaran',
            ),
          ),
          _LabeledField(
            label: 'Cari Siswa',
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Nama siswa...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF9AA5B5)),
                filled: true,
                fillColor: Color(0xFFF8F9FB),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9AA5B5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        borderSide: const BorderSide(color: Color(0xFF2F80FF), width: 1.3),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _GradeRow extends StatelessWidget {
  const _GradeRow({required this.record});

  final _GradeRecord record;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _ScoreBadge(score: record.nilai),
          ),
          Expanded(
            flex: 1,
            child: _GradeBadge(grade: record.grade),
          ),
          Expanded(
            flex: 2,
            child: Text(
              record.tanggal,
              style: const TextStyle(color: Color(0xFF4A5568)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              _ActionIcon(icon: Icons.edit_outlined),
              SizedBox(width: 8),
              _ActionIcon(icon: Icons.delete_outline, color: Color(0xFFD9534F)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    if (score >= 90) {
      bg = const Color(0xFFE6FFFA);
      fg = const Color(0xFF0CA678);
    } else if (score >= 80) {
      bg = const Color(0xFFE7F5FF);
      fg = const Color(0xFF1C7ED6);
    } else if (score >= 70) {
      bg = const Color(0xFFFFF4E6);
      fg = const Color(0xFFE59F00);
    } else {
      bg = const Color(0xFFFFEDEE);
      fg = const Color(0xFFE03131);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score',
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.grade});

  final String grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9DFE7)),
      ),
      child: Text(
        grade,
        style: const TextStyle(
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, this.color});

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E5F1)),
      ),
      child: Icon(icon, size: 18, color: color ?? const Color(0xFF2F80FF)),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _GradeRecord {
  final String name;
  final String kelas;
  final String mapel;
  final String jenis;
  final int nilai;
  final String tanggal;
  final String grade;
  const _GradeRecord({
    required this.name,
    required this.kelas,
    required this.mapel,
    required this.jenis,
    required this.nilai,
    required this.tanggal,
    required this.grade,
  });
}
