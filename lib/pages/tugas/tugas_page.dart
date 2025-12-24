// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../jadwal/jadwal_page.dart';
import '../presensi/presensi_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  final _searchController = TextEditingController();

  final _tasks = [
    TaskItem(
      title: 'Tugas Matematika Bab 5',
      description: 'Kerjakan soal nomor 1-20 halaman 45',
      subject: 'Matematika',
      kelas: 'Kelas 1',
      deadline: '22 Desember 2025',
      status: TaskStatus.aktif,
      attachment: 'soal_matematika.pdf',
    ),
    TaskItem(
      title: 'Essay Bahasa Indonesia',
      description: 'Buat essay tentang pahlawan nasional minimal 500 kata',
      subject: 'Bahasa Indonesia',
      kelas: 'Kelas 2',
      deadline: '25 Desember 2025',
      status: TaskStatus.aktif,
    ),
    TaskItem(
      title: 'Tugas Bahasa Inggris Bab 5',
      description: 'Kerjakan soal nomor 1-10 halaman 23',
      subject: 'Bahasa Inggris',
      kelas: 'Kelas 3',
      deadline: '28 Desember 2025',
      status: TaskStatus.aktif,
    ),
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
      backgroundColor: const Color(0xFF0A1F44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1F44),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Tugas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 4,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => Navigator.of(context).pop(),
        onTapJadwal: () => goTo(const JadwalPage()),
        onTapPresensi: () => goTo(const PresensiPage()),
        onTapNilai: () => goTo(const NilaiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onLogout: logout,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0A1F44),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manajemen Tugas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Kelola dan pantau tugas untuk semua kelas',
                  style: TextStyle(
                    color: Color(0xFFBFCFEA),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB45B),
                          foregroundColor: const Color(0xFF0A1F44),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _showAddTaskDialog,
                        icon: const Icon(Icons.add, size: 24),
                        label: const Text(
                          'Tambah Tugas Baru',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.search, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content Section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return _TaskCard(task: _tasks[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String? subject;
    String? kelas;
    DateTime? deadline;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tambah Tugas Baru',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _DialogField(
                      label: 'Judul Tugas',
                      child: TextField(
                        controller: titleController,
                        decoration: _fieldDecoration('Masukkan judul tugas'),
                      ),
                    ),
                    _DialogField(
                      label: 'Mata Pelajaran',
                      child: DropdownButtonFormField<String>(
                        decoration: _fieldDecoration('Pilih mata pelajaran'),
                        items: const [
                          DropdownMenuItem(value: 'Matematika', child: Text('Matematika')),
                          DropdownMenuItem(value: 'Bahasa Indonesia', child: Text('Bahasa Indonesia')),
                          DropdownMenuItem(value: 'Bahasa Inggris', child: Text('Bahasa Inggris')),
                        ],
                        onChanged: (v) => setState(() => subject = v),
                      ),
                    ),
                    _DialogField(
                      label: 'Kelas',
                      child: DropdownButtonFormField<String>(
                        decoration: _fieldDecoration('Pilih kelas'),
                        items: const [
                          DropdownMenuItem(value: 'Kelas 1', child: Text('Kelas 1')),
                          DropdownMenuItem(value: 'Kelas 2', child: Text('Kelas 2')),
                          DropdownMenuItem(value: 'Kelas 3', child: Text('Kelas 3')),
                        ],
                        onChanged: (v) => setState(() => kelas = v),
                      ),
                    ),
                    _DialogField(
                      label: 'Tanggal Deadline',
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => deadline = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: _fieldDecoration('Pilih tanggal'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                deadline == null
                                    ? 'Pilih tanggal'
                                    : '${deadline!.day}/${deadline!.month}/${deadline!.year}',
                                style: TextStyle(
                                  color: deadline == null ? const Color(0xFF9AA5B5) : const Color(0xFF2D3748),
                                ),
                              ),
                              const Icon(Icons.calendar_month, color: Color(0xFF9AA5B5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _DialogField(
                      label: 'Deskripsi',
                      child: TextField(
                        controller: descController,
                        minLines: 3,
                        maxLines: 4,
                        decoration: _fieldDecoration('Masukkan deskripsi tugas'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (titleController.text.isEmpty ||
                              subject == null ||
                              kelas == null ||
                              deadline == null) {
                            showFeedback(context, 'Lengkapi semua field');
                            return;
                          }
                          Navigator.of(context).pop();
                          showFeedback(context, 'Tugas berhasil ditambahkan');
                        },
                        child: const Text(
                          'Simpan Tugas',
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFE4B5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Aktif',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        _ActionIcon(icon: Icons.edit, color: const Color(0xFF2196F3)),
                        const SizedBox(width: 8),
                        _ActionIcon(icon: Icons.delete, color: const Color(0xFFF44336)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.menu_book, size: 18, color: Color(0xFF718096)),
                    const SizedBox(width: 6),
                    Text(
                      task.subject,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.people, size: 18, color: Color(0xFF718096)),
                    const SizedBox(width: 6),
                    Text(
                      task.kelas,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF718096)),
                    const SizedBox(width: 6),
                    Text(
                      task.deadline,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (task.attachment != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE4B5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Color(0xFFF44336),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.attachment!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
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

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

enum TaskStatus { aktif, selesai }

class TaskItem {
  const TaskItem({
    required this.title,
    required this.description,
    required this.subject,
    required this.kelas,
    required this.deadline,
    required this.status,
    this.attachment,
  });

  final String title;
  final String description;
  final String subject;
  final String kelas;
  final String deadline;
  final TaskStatus status;
  final String? attachment;
}