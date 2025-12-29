// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

class _ScheduleItem {
  final String? id;
  final String mapel;
  final String kelas;
  final String guru;
  final String hari;
  final String jamMulai;
  final String jamSelesai;

  const _ScheduleItem({
    this.id,
    required this.mapel,
    required this.kelas,
    required this.guru,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
  });
}

class _JadwalPageState extends State<JadwalPage> {
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  int _selectedDay = 0;
  final _baseUrl = 'http://192.168.110.83:3000';
  List<_ScheduleItem> _items = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE8D5B5)),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _fetchSchedule, child: const Text('Coba Lagi')),
          ],
        ),
      );
    }

    final day = _days[_selectedDay];
    final visible = _items.where((e) => e.hari.toLowerCase() == day.toLowerCase()).toList();

    if (visible.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text('Tidak ada jadwal untuk hari ini'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: visible.length,
      itemBuilder: (ctx, i) {
        final item = visible[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ScheduleCard(
            item: item,
            color: const Color(0xFFE3F2FD),
            borderColor: const Color(0xFF64B5F6),
          ),
        );
      },
    );
  }


  Future<void> _fetchSchedule() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await http.get(Uri.parse('$_baseUrl/api/jadwal'));
      debugPrint(res.body);
      if (res.statusCode != 200) throw Exception('Failed to load jadwal');

        final data = jsonDecode(res.body);
        debugPrint("data fetch: ${data.toString()}");
        if (data['success'] == true) {
          final list = (data['data'] as List)
            .map((e) {
              final jamRaw = (e['jam'] ?? '') as String;
              final parts = jamRaw.split('-');
              final jamMulai = parts.isNotEmpty ? parts.first : '';
              final jamSelesai = parts.length > 1 ? parts[1] : '';
              return _ScheduleItem(
                id: e['id']?.toString(),
                mapel: (e['mata_pelajaran'] ?? e['mapel'] ?? '').toString(),
                kelas: (e['kelas'] ?? '').toString(),
                guru: (e['guru'] ?? '').toString(),
                hari: (e['hari'] ?? '').toString(),
                jamMulai: jamMulai,
                jamSelesai: jamSelesai,
              );
            })
              .toList();
          setState(() {
            _items = list;
            _isLoading = false;
          });
      } else {
        throw Exception(data['message'] ?? 'Failed to load jadwal');
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat jadwal: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => page),
      );
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
          'Jadwal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Sidebar(
        selectedIndex: 1,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(const TugasPage()),
        onTapJadwal: () => Navigator.of(context).pop(),
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF0A1F44),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jadwal Pelajaran',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola jadwal semua kelas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB45B),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _showAddScheduleDialog,
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFF0A1F44),
                          size: 22,
                        ),
                        label: const Text(
                          'Tambah Jadwal Baru',
                          style: TextStyle(
                            color: Color(0xFF0A1F44),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF0A1F44),
                          size: 24,
                        ),
                        onPressed: () {
                          showFeedback(context, 'Fitur pencarian kelas');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: List.generate(_days.length, (index) {
                        final isActive = index == _selectedDay;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFFE8D5B5) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive ? const Color(0xFFE8D5B5) : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              _days[index],
                              style: TextStyle(
                                color: isActive ? const Color(0xFF0A1F44) : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddScheduleDialog() async {
    String? subject;
    String? kelas;
    String? hari;
    final teacherController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

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
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Tambah Jadwal Baru',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A1F44),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _LabeledField(
                      label: 'Mata Pelajaran',
                      child: DropdownButtonFormField<String>(
                        decoration: _fieldDecoration('Pilih mata pelajaran'),
                        value: subject,
                        items: const [
                          DropdownMenuItem(
                            value: 'Matematika',
                            child: Text('Matematika'),
                          ),
                          DropdownMenuItem(
                            value: 'Bahasa Indonesia',
                            child: Text('Bahasa Indonesia'),
                          ),
                          DropdownMenuItem(
                            value: 'Bahasa Inggris',
                            child: Text('Bahasa Inggris'),
                          ),
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
                              value: kelas,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Kelas 1',
                                  child: Text('Kelas 1'),
                                ),
                                DropdownMenuItem(
                                  value: 'Kelas 2',
                                  child: Text('Kelas 2'),
                                ),
                                DropdownMenuItem(
                                  value: 'Kelas 3',
                                  child: Text('Kelas 3'),
                                ),
                              ],
                              onChanged: (v) => setState(() => kelas = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _LabeledField(
                      label: 'Hari',
                      child: DropdownButtonFormField<String>(
                        decoration: _fieldDecoration('Pilih hari'),
                        value: hari,
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A1F44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (subject == null ||
                              kelas == null ||
                              hari == null ||
                              teacherController.text.isEmpty ||
                              startController.text.isEmpty ||
                              endController.text.isEmpty) {
                            showFeedback(context, 'Lengkapi semua field');
                            return;
                          }

                          try {
                            final res = await http.post(
                              Uri.parse('$_baseUrl/api/jadwal'),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'mapel': subject,
                                'kelas': kelas,
                                'guru': teacherController.text,
                                'hari': hari,
                                'jam_mulai': startController.text,
                                'jam_selesai': endController.text,
                              }),
                            );

                            debugPrint(res.body);

                            if (res.statusCode == 201) {
                              Navigator.of(context).pop();
                              await _fetchSchedule();
                              showFeedback(context, 'Jadwal berhasil ditambahkan');
                            } else {
                              showFeedback(context, 'Gagal menambahkan jadwal');
                            }
                          } catch (e) {
                            showFeedback(context, 'Error: $e');
                          }
                        },
                        child: const Text(
                          'Simpan Jadwal',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0A1F44), width: 2),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.item,
    required this.color,
    required this.borderColor,
  });

  final _ScheduleItem item;
  final Color color;
  final Color borderColor;


  @override
  Widget build(BuildContext context) {
    final time = '${item.jamMulai}-${item.jamSelesai}'.trim();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.mapel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A1F44),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.kelas,
                        style: const TextStyle(
                          color: Color(0xFF0A1F44),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Color(0xFF0A1F44),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
                color: Color(0xFF0A1F44),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF0A1F44),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
                color: Color(0xFF0A1F44),
              ),
              const SizedBox(width: 8),
              Text(
                item.guru,
                style: const TextStyle(
                  color: Color(0xFF0A1F44),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0A1F44),
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
          final hour = picked.hour.toString().padLeft(2, '0');
          final minute = picked.minute.toString().padLeft(2, '0');
          controller.text = '$hour:$minute';
        }
      },
      decoration: InputDecoration(
        hintText: '--:--',
        suffixIcon: Icon(Icons.access_time, color: Colors.grey[400]),
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0A1F44), width: 2),
        ),
      ),
    );
  }
}