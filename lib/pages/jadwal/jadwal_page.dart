// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../presensi/presensi_page.dart';
import '../tugas/tugas_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';
import '../../utils/api_client.dart';
import '../../state/auth_controller.dart';
import '../../theme/brand.dart';

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
  List<_ScheduleItem> _items = [];
  bool _isLoading = false;
  String? _error;
  String? _filterKelas;
  String? _filterGuru;
  late ApiClient _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<AuthController>());
    _fetchSchedule();
  }

  void _openFilter() {
    final kelasController = TextEditingController(text: _filterKelas ?? '');
    final guruController = TextEditingController(text: _filterGuru ?? '');

    showDialog<Map<String, String?>>(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter Jadwal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.navy900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Kelas',
                child: TextField(
                  decoration: _fieldDecoration('Cari kelas (mis. Kelas 1)'),
                  controller: kelasController,
                ),
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Guru',
                child: TextField(
                  decoration: _fieldDecoration('Cari guru'),
                  controller: guruController,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BrandColors.navy900,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop({
                          'kelas': kelasController.text.trim().isEmpty ? null : kelasController.text.trim(),
                          'guru': guruController.text.trim().isEmpty ? null : guruController.text.trim(),
                        });
                      },
                      child: const Text(
                        'Terapkan',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop({'kelas': null, 'guru': null});
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((result) {
      if (result == null) return;
      setState(() {
        _filterKelas = result['kelas'];
        _filterGuru = result['guru'];
      });
    });
  }

  Future<void> _confirmDelete(_ScheduleItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Jadwal'),
        content: Text('Hapus jadwal ${item.mapel}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final res = await _api.delete('/api/jadwal/${item.id}');
      if (res.statusCode == 200) {
        await _fetchSchedule();
        if (!mounted) return;
        showFeedback(context, 'Jadwal dihapus');
      } else {
        if (!mounted) return;
        showFeedback(context, 'Gagal hapus jadwal');
      }
    } catch (e) {
      if (!mounted) return;
      showFeedback(context, 'Gagal hapus: $e');
    }
  }

  Future<void> _showEditScheduleDialog(_ScheduleItem item) async {
    String? subject = item.mapel;
    String? kelas = item.kelas;
    String? hari = item.hari;
    final teacherController = TextEditingController(text: item.guru);
    final startController = TextEditingController(text: item.jamMulai);
    final endController = TextEditingController(text: item.jamSelesai);

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(
            builder: (context, setState) {
              final mapelOptions = const [
                'Matematika',
                'Bahasa Indonesia',
                'Bahasa Inggris',
                'IPA',
                'IPS',
                'PPKn',
                'Seni Budaya',
                'PJOK',
                'Informatika',
                'Prakarya',
              ];
              final kelasOptions = const ['Kelas 10', 'Kelas 11', 'Kelas 12'];
              final hariOptions = _days;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ubah Jadwal',
                            style: BrandTextStyles.subheading.copyWith(
                              color: BrandColors.navy900,
                              fontWeight: FontWeight.w700,
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
                        items: mapelOptions
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
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
                              items: kelasOptions
                                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                                  .toList(),
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
                        items: hariOptions
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
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: BrandColors.navy900,
                              side: const BorderSide(color: BrandColors.navy900, width: 1.4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: BrandButtons.primary().copyWith(
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              void show(String msg) => showFeedback(context, msg);
                              if (subject == null ||
                                  kelas == null ||
                                  hari == null ||
                                  teacherController.text.isEmpty ||
                                  startController.text.isEmpty ||
                                  endController.text.isEmpty) {
                                show('Lengkapi semua field');
                                return;
                              }

                              try {
                                final res = await _api.put(
                                  '/api/jadwal/${item.id}',
                                  body: {
                                    'mapel': subject,
                                    'kelas': kelas,
                                    'guru': teacherController.text,
                                    'hari': hari,
                                    'jam_mulai': startController.text,
                                    'jam_selesai': endController.text,
                                  },
                                );

                                if (res.statusCode == 200) {
                                  navigator.pop();
                                  await _fetchSchedule();
                                  show('Jadwal berhasil diperbarui');
                                } else {
                                  show('Gagal memperbarui jadwal');
                                }
                              } catch (e) {
                                show('Error: $e');
                              }
                            },
                            child: const Text(
                              'Simpan Perubahan',
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
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE8D5B5)),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
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
        ),
      );
    }

    final day = _days[_selectedDay];
    var visible = _items.where((e) => e.hari.toLowerCase() == day.toLowerCase()).toList();

    if (_filterKelas != null && _filterKelas!.trim().isNotEmpty) {
      final kw = _filterKelas!.toLowerCase();
      visible = visible.where((e) => e.kelas.toLowerCase().contains(kw)).toList();
    }
    if (_filterGuru != null && _filterGuru!.trim().isNotEmpty) {
      final kw = _filterGuru!.toLowerCase();
      visible = visible.where((e) => e.guru.toLowerCase().contains(kw)).toList();
    }

    if (visible.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text('Tidak ada jadwal untuk hari ini'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: visible.length,
      itemBuilder: (ctx, i) {
        final item = visible[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ScheduleCard(
            item: item,
            onEdit: () => _showEditScheduleDialog(item),
            onDelete: () => _confirmDelete(item),
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
      final res = await _api.get('/api/jadwal');
      debugPrint(res.body);
      if (res.statusCode != 200) throw Exception('Failed to load jadwal (status ${res.statusCode})');

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
    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => page),
      );
    }

    void logout() async {
      final navigator = Navigator.of(context);
      void show(String msg) => showFeedback(context, msg);
      try {
        final auth = Provider.of<AuthController>(context, listen: false);
        await auth.logout();
      } catch (e) {
        if (!mounted) return;
        show('Logout gagal: $e');
        return;
      }

      if (!mounted) return;
      _scaffoldKey.currentState?.closeDrawer();
      show('Logout berhasil');
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.gray100,
      appBar: AppBar(
        backgroundColor: BrandColors.navy900,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Jadwal', style: BrandTextStyles.appBarTitle),
      ),
      drawer: Sidebar(
        selectedIndex: 4,
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
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
                  'Jadwal Pembelajaran',
                  style: BrandTextStyles.heading.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola jadwal semua kelas',
                  style: BrandTextStyles.bodySecondary.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: BrandButtons.accent(),
                        onPressed: _showAddScheduleDialog,
                        icon: const Icon(
                          Icons.add,
                          color: BrandColors.navy900,
                          size: 20,
                        ),
                        label: const Text(
                          'Tambah Jadwal Baru',
                          style: TextStyle(
                            color: BrandColors.navy900,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: _openFilter,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
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
                              color: isActive ? BrandColors.amber400 : BrandColors.gray100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive ? BrandColors.amber400 : BrandColors.gray300,
                              ),
                              boxShadow: isActive ? BrandShadows.card : null,
                            ),
                            child: Row(
                              children: [
                                if (isActive)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(Icons.event, size: 16, color: BrandColors.navy900),
                                  ),
                                Text(
                                  _days[index],
                                  style: TextStyle(
                                    color: isActive ? BrandColors.navy900 : Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
            child: RefreshIndicator(
              onRefresh: _fetchSchedule,
              child: Container(
                color: BrandColors.gray100,
                child: _buildContent(),
              ),
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(
            builder: (context, setState) {
              final mapelOptions = const [
                'Matematika',
                'Bahasa Indonesia',
                'Bahasa Inggris',
                'IPA',
                'IPS',
                'PPKn',
                'Seni Budaya',
                'PJOK',
                'Informatika',
                'Prakarya',
              ];
              final kelasOptions = const ['Kelas 10', 'Kelas 11', 'Kelas 12'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tambah Jadwal Baru',
                            style: BrandTextStyles.subheading.copyWith(
                              color: BrandColors.navy900,
                              fontWeight: FontWeight.w700,
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
                        items: mapelOptions
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
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
                              items: kelasOptions
                                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                                  .toList(),
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
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: BrandColors.navy900,
                              side: const BorderSide(color: BrandColors.navy900, width: 1.4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: BrandButtons.primary().copyWith(
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              void show(String msg) => showFeedback(context, msg);
                              if (subject == null ||
                                  kelas == null ||
                                  hari == null ||
                                  teacherController.text.isEmpty ||
                                  startController.text.isEmpty ||
                                  endController.text.isEmpty) {
                                show('Lengkapi semua field');
                                return;
                              }

                              try {
                                final res = await _api.post(
                                  '/api/jadwal',
                                  body: {
                                    'mapel': subject,
                                    'kelas': kelas,
                                    'guru': teacherController.text,
                                    'hari': hari,
                                    'jam_mulai': startController.text,
                                    'jam_selesai': endController.text,
                                  },
                                );

                                debugPrint(res.body);

                                if (res.statusCode == 201) {
                                  navigator.pop();
                                  await _fetchSchedule();
                                  show('Jadwal berhasil ditambahkan');
                                } else {
                                  show('Gagal menambahkan jadwal');
                                }
                              } catch (e) {
                                show('Error: $e');
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
    this.onEdit,
    this.onDelete,
  });

  final _ScheduleItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;


  @override
  Widget build(BuildContext context) {
    final time = '${item.jamMulai}-${item.jamSelesai}'.trim();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.sand200, width: 1.2),
        boxShadow: BrandShadows.card,
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
                      style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: BrandColors.sand200,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: BrandColors.amber400, width: 1),
                      ),
                      child: Text(
                        item.kelas,
                        style: const TextStyle(
                          color: BrandColors.navy900,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
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
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: Color(0xFF0A1F44),
                      ),
                      splashRadius: 20,
                      onPressed: onEdit,
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
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red,
                      ),
                      splashRadius: 20,
                      onPressed: onDelete,
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
                color: BrandColors.navy900,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: BrandTextStyles.body.copyWith(
                  color: BrandColors.navy900,
                  fontWeight: FontWeight.w600,
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
                color: BrandColors.navy900,
              ),
              const SizedBox(width: 8),
              Text(
                item.guru,
                style: BrandTextStyles.body.copyWith(
                  color: BrandColors.navy900,
                  fontWeight: FontWeight.w600,
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