// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../presensi/presensi_page.dart';
import '../tugas/tugas_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  int _selectedDay = 0;

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
          'Jadwal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 1,
        onTapDashboard: () => goTo(DashboardScreen()),
        onTapTugas: () => goTo(TugasPage()),
        onTapJadwal: () => Navigator.of(context).pop(),
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
                    Text('Jadwal Pelajaran', style: titleStyle),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola jadwal pelajaran untuk semua kelas',
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
                        onPressed: _showAddScheduleDialog,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Tambah Jadwal Baru',
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_days.length, (index) {
                    final isActive = index == _selectedDay;
                    return Padding(
                      padding: EdgeInsets.only(right: index == _days.length - 1 ? 0 : 10),
                      child: ChoiceChip(
                        selected: isActive,
                        onSelected: (_) => setState(() => _selectedDay = index),
                        label: Text(_days[index]),
                        labelStyle: TextStyle(
                          color: isActive ? Colors.white : const Color(0xFF2F80FF),
                          fontWeight: FontWeight.w600,
                        ),
                        selectedColor: const Color(0xFF2F80FF),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isActive ? Colors.transparent : const Color(0xFFE0E7FF),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  _ScheduleCard(
                    title: 'Matematika',
                    kelas: 'Kelas 12A',
                    time: '08:00 - 09:30',
                    room: 'R.201',
                    teacher: 'Bu Sarah',
                    color: const Color(0xFFE0EDFF),
                    borderColor: const Color(0xFF88B1FF),
                  ),
                  _ScheduleCard(
                    title: 'Bahasa Indonesia',
                    kelas: 'Kelas 12A',
                    time: '09:30 - 11:00',
                    room: 'R.201',
                    teacher: 'Pak Budi',
                    color: const Color(0xFFF1E4FF),
                    borderColor: const Color(0xFFD2B5FF),
                  ),
                  _ScheduleCard(
                    title: 'Fisika',
                    kelas: 'Kelas 12A',
                    time: '13:00 - 14:30',
                    room: 'Lab Fisika',
                    teacher: 'Bu Diana',
                    color: const Color(0xFFE3FAE9),
                    borderColor: const Color(0xFFB3E6C4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddScheduleDialog() async {
    String? subject;
    String? kelas;
    String? hari;
    final teacherController = TextEditingController();
    final roomController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

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
                          'Tambah Jadwal Baru',
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
                      label: 'Guru',
                      child: TextField(
                        controller: teacherController,
                        decoration: _fieldDecoration('Nama guru'),
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
                                DropdownMenuItem(value: 'Kelas 12A', child: Text('Kelas 12A')),
                                DropdownMenuItem(value: 'Kelas 12B', child: Text('Kelas 12B')),
                                DropdownMenuItem(value: 'Kelas 11B', child: Text('Kelas 11B')),
                              ],
                              onChanged: (v) => setState(() => kelas = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledField(
                            label: 'Ruangan',
                            child: TextField(
                              controller: roomController,
                              decoration: _fieldDecoration('Ruangan'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _LabeledField(
                      label: 'Hari',
                      child: DropdownButtonFormField<String>(
                        decoration: _fieldDecoration('Pilih hari'),
                        initialValue: hari,
                        items: _days
                            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (v) => setState(() => hari = v),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: 'Waktu Mulai',
                            child: _TimeField(controller: startController),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledField(
                            label: 'Waktu Selesai',
                            child: _TimeField(controller: endController),
                          ),
                        ),
                      ],
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
                          if (subject == null ||
                              kelas == null ||
                              hari == null ||
                              teacherController.text.isEmpty ||
                              roomController.text.isEmpty ||
                              startController.text.isEmpty ||
                              endController.text.isEmpty) {
                            showFeedback(context, 'Lengkapi mapel, guru, kelas, hari, ruangan, dan jam');
                            return;
                          }
                          Navigator.of(context).pop();
                          showFeedback(context, 'Jadwal disimpan');
                        },
                        child: const Text(
                          'Simpan Jadwal',
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

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.title,
    required this.kelas,
    required this.time,
    required this.room,
    required this.teacher,
    required this.color,
    required this.borderColor,
  });

  final String title;
  final String kelas;
  final String time;
  final String room;
  final String teacher;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
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
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD9DFE7)),
                      ),
                      child: Text(
                        kelas,
                        style: const TextStyle(
                          color: Color(0xFF4A5568),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: const [
                  _ActionIcon(icon: Icons.edit_outlined),
                  SizedBox(width: 8),
                  _ActionIcon(icon: Icons.delete_outline, color: Color(0xFFD9534F)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Color(0xFF6C737F)),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(color: Color(0xFF6C737F), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF6C737F)),
              const SizedBox(width: 6),
              Text(
                room,
                style: const TextStyle(color: Color(0xFF6C737F), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: const TextSpan(
              text: 'Guru: ',
              style: TextStyle(
                color: Color(0xFF4A4A4A),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text: 'Bu Diana',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F80FF),
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

class _TimeField extends StatelessWidget {
  const _TimeField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          final hour = picked.hourOfPeriod.toString().padLeft(2, '0');
          final minute = picked.minute.toString().padLeft(2, '0');
          final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
          controller.text = '$hour:$minute $period';
        }
      },
      decoration: InputDecoration(
        hintText: '--:-- --',
        suffixIcon: const Icon(Icons.access_time, color: Color(0xFF95A2B7)),
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
