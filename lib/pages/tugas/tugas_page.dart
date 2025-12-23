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
      kelas: 'Kelas 12A',
      deadline: '22 Desember 2025',
      status: TaskStatus.aktif,
      attachment: 'soal_matematika_bab5.pdf',
    ),
    TaskItem(
      title: 'Essay Bahasa Indonesia',
      description: 'Buat essay tentang pahlawan nasional minimal 500 kata',
      subject: 'Bahasa Indonesia',
      kelas: 'Kelas 11B',
      deadline: '25 Desember 2025',
      status: TaskStatus.aktif,
    ),
    TaskItem(
      title: 'Laporan Praktikum Fisika',
      description: 'Laporan hasil praktikum tentang hukum Newton',
      subject: 'Fisika',
      kelas: 'Kelas 10C',
      deadline: '28 Desember 2025',
      status: TaskStatus.selesai,
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
          'Tugas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 4,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => Navigator.of(context).pop(),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    Text('Manajemen Tugas', style: titleStyle),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola dan pantau tugas untuk semua kelas',
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
                        onPressed: _showAddTaskDialog,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Tambah Tugas Baru',
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
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari tugas berdasarkan judul, mata pelajaran, atau kelas',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF9AA5B5)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Column(
                children: _tasks.map((task) => _TaskCard(task: task)).toList(),
              ),
            ],
          ),
        ),
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
                          'Tambah Tugas Baru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
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
                      label: 'Judul Tugas',
                      child: TextField(
                        controller: titleController,
                        decoration: _fieldDecoration('Masukkan judul tugas'),
                      ),
                    ),
                    _LabeledField(
                      label: 'Mata Pelajaran',
                      child: DropdownButtonFormField<String>(
                        decoration: _fieldDecoration('Pilih mata pelajaran'),
                        initialValue: subject,
                        items: const [
                          DropdownMenuItem(value: 'Matematika', child: Text('Matematika')),
                          DropdownMenuItem(value: 'Bahasa Indonesia', child: Text('Bahasa Indonesia')),
                          DropdownMenuItem(value: 'Fisika', child: Text('Fisika')),
                        ],
                        onChanged: (v) => setState(() => subject = v),
                      ),
                    ),
                    _LabeledField(
                      label: 'Kelas',
                      child: DropdownButtonFormField<String>(
                        decoration: _fieldDecoration('Pilih kelas'),
                        initialValue: kelas,
                        items: const [
                          DropdownMenuItem(value: 'Kelas 12A', child: Text('Kelas 12A')),
                          DropdownMenuItem(value: 'Kelas 11B', child: Text('Kelas 11B')),
                          DropdownMenuItem(value: 'Kelas 10C', child: Text('Kelas 10C')),
                        ],
                        onChanged: (v) => setState(() => kelas = v),
                      ),
                    ),
                    _LabeledField(
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
                          decoration: _fieldDecoration('mm/dd/yyyy'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                deadline == null
                                    ? 'mm/dd/yyyy'
                                    : '${deadline!.month}/${deadline!.day}/${deadline!.year}',
                                style: TextStyle(
                                  color: deadline == null ? const Color(0xFF9AA5B5) : Colors.black87,
                                ),
                              ),
                              const Icon(Icons.calendar_month_outlined, color: Color(0xFF9AA5B5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _LabeledField(
                      label: 'Deskripsi',
                      child: TextField(
                        controller: descController,
                        minLines: 3,
                        maxLines: 4,
                        decoration: _fieldDecoration('Masukkan deskripsi tugas'),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCCE1FF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.cloud_upload_outlined, color: Color(0xFF2F80FF)),
                              SizedBox(width: 8),
                              Text(
                                'Upload File Soal (Optional)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Format: PDF, DOC, DOCX, atau gambar (Maks. 10MB)',
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFD9DFE7)),
                            ),
                            child: const Text(
                              'Choose File No file chosen',
                              style: TextStyle(color: Color(0xFF6C737F)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
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
                          if (titleController.text.isEmpty ||
                              subject == null ||
                              kelas == null ||
                              deadline == null) {
                            showFeedback(context, 'Lengkapi judul, mapel, kelas, dan deadline');
                            return;
                          }
                          Navigator.of(context).pop();
                          showFeedback(context, 'Tugas disimpan');
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
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final statusColor = task.status == TaskStatus.aktif
        ? const Color(0xFF2F80FF)
        : const Color(0xFF6B7280);
    final statusLabel = task.status == TaskStatus.aktif ? 'Aktif' : 'Selesai';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.description,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      _ActionIcon(icon: Icons.edit_outlined),
                      SizedBox(width: 8),
                      _ActionIcon(icon: Icons.delete_outline, color: Color(0xFFD9534F)),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.menu_book_outlined, size: 18, color: Color(0xFF6C737F)),
              const SizedBox(width: 6),
              Text(
                task.subject,
                style: const TextStyle(color: Color(0xFF6C737F), fontSize: 13),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.group_outlined, size: 18, color: Color(0xFF6C737F)),
              const SizedBox(width: 6),
              Text(
                task.kelas,
                style: const TextStyle(color: Color(0xFF6C737F), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF6C737F)),
              const SizedBox(width: 6),
              Text(
                'Deadline: ${task.deadline}',
                style: const TextStyle(color: Color(0xFF6C737F), fontSize: 13),
              ),
            ],
          ),
          if (task.attachment != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E7FF)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF2F80FF)),
                  const SizedBox(width: 8),
                  Text(
                    task.attachment!,
                    style: const TextStyle(
                      color: Color(0xFF2F80FF),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E5F1)),
      ),
      child: Icon(icon, size: 18, color: color ?? const Color(0xFF2F80FF)),
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
