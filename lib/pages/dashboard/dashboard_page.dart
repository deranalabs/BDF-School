// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/api_client.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../presensi/presensi_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../tugas/tugas_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../notes/notes_page.dart';
import '../../state/auth_controller.dart';
import '../../theme/brand.dart';
import 'sidebar.dart';
import '../../utils/feedback.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalSiswa = 0;
  int _totalTugas = 0;
  int _totalPengumuman = 0;
  int _deadlineMingguIni = 0;
  int _kehadiranHariIni = 0;
  List<ActivityItem> _activities = [];
  bool _isLoading = true;
  String? _error;
  late ApiClient _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<AuthController>());
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final responses = await Future.wait<http.Response>([
        _api.get('/api/siswa'),
        _api.get('/api/tugas'),
        _api.get('/api/pengumuman'),
        _api.get('/api/presensi'),
      ]);

      final siswaResponse = responses[0];
      final tugasResponse = responses[1];
      final pengumumanResponse = responses[2];
      final presensiResponse = responses[3];

      if (responses.any((r) => r.statusCode != 200)) {
        final statusSummary = responses.map((r) => r.statusCode).join(', ');
        throw Exception('Gagal memuat data dashboard (status: $statusSummary)');
      }

      int totalSiswa = 0;
      int totalTugas = 0;
      int totalPengumuman = 0;
      int kehadiranHariIni = 0;
      int deadlineMingguIni = 0;
      final List<ActivityItem> activities = [];

      if (siswaResponse.statusCode == 200) {
        final data = jsonDecode(siswaResponse.body);
        totalSiswa = data['success'] == true ? (data['data'] as List).length : 0;
      }
      if (tugasResponse.statusCode == 200) {
        final data = jsonDecode(tugasResponse.body);
        final tugasList = data['success'] == true ? (data['data'] as List) : [];
        // Hanya hitung tugas aktif
        final tugasAktif = tugasList.where((t) => (t['status'] ?? '').toString().toLowerCase() == 'aktif').toList();
        totalTugas = tugasAktif.length;

        // Hitung deadline 7 hari ke depan (termasuk hari ini)
        final today = DateTime.now();
        final start = DateTime(today.year, today.month, today.day);
        final end = start.add(const Duration(days: 7));
        deadlineMingguIni = tugasAktif.where((t) {
          final raw = t['deadline']?.toString();
          if (raw == null || raw.isEmpty) return false;
          final parsed = DateTime.tryParse(raw);
          if (parsed == null) return false;
          final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
          return (dateOnly.isAtSameMomentAs(start) || dateOnly.isAfter(start)) &&
              (dateOnly.isAtSameMomentAs(end) || dateOnly.isBefore(end));
        }).length;

        // Activity: tugas terbaru
        final tugasSorted = [...tugasAktif]
          ..sort((a, b) {
            final da = _parseDate(a['deadline']?.toString());
            final db = _parseDate(b['deadline']?.toString());
            return (db ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(da ?? DateTime.fromMillisecondsSinceEpoch(0));
          });
        for (final t in tugasSorted.take(5)) {
          final dt = _parseDate(t['deadline']?.toString());
          activities.add(ActivityItem(
            title: 'Tugas ${t['judul'] ?? ''}',
            subtitle: t['kelas'] ?? '',
            timeText: _formatRelativeTime(dt),
            dotColor: BrandColors.amber400,
            sortKey: dt,
          ));
        }
      }
      if (pengumumanResponse.statusCode == 200) {
        final data = jsonDecode(pengumumanResponse.body);
        final pengumumanList = data['success'] == true ? (data['data'] as List) : [];
        totalPengumuman = pengumumanList.length;

        final pengumumanSorted = [...pengumumanList]
          ..sort((a, b) {
            final da = _parseDate(a['tanggal']?.toString());
            final db = _parseDate(b['tanggal']?.toString());
            return (db ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(da ?? DateTime.fromMillisecondsSinceEpoch(0));
          });
        for (final p in pengumumanSorted.take(5)) {
          final dt = _parseDate(p['tanggal']?.toString());
          activities.add(ActivityItem(
            title: p['judul'] ?? 'Pengumuman',
            subtitle: p['pengirim'] ?? '',
            timeText: _formatRelativeTime(dt),
            dotColor: Colors.redAccent,
            sortKey: dt,
          ));
        }
      }
      if (presensiResponse.statusCode == 200) {
        final data = jsonDecode(presensiResponse.body);
        final today = DateTime.now().toIso8601String().split('T')[0];
        final presensiList = data['success'] == true ? data['data'] as List : [];
        final now = DateTime.now();
        final todayDate = DateTime(now.year, now.month, now.day);
        kehadiranHariIni = presensiList.where((p) {
          final status = (p['status'] ?? '').toString().trim().toLowerCase();
          final rawTanggal = p['tanggal']?.toString();
          if (rawTanggal == null || rawTanggal.isEmpty || status != 'hadir') return false;
          final dt = _parseDate(rawTanggal);
          if (dt != null) {
            final onlyDate = DateTime(dt.year, dt.month, dt.day);
            return onlyDate == todayDate;
          }
          return rawTanggal.startsWith(today);
        }).length;

        final presensiSorted = [...presensiList]
          ..sort((a, b) {
            final da = _parseDate(a['tanggal']?.toString());
            final db = _parseDate(b['tanggal']?.toString());
            return (db ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(da ?? DateTime.fromMillisecondsSinceEpoch(0));
          });
        for (final p in presensiSorted.take(5)) {
          final dt = _parseDate(p['tanggal']?.toString());
          activities.add(ActivityItem(
            title: 'Presensi ${p['status'] ?? ''}',
            subtitle: p['keterangan'] ?? '',
            timeText: _formatRelativeTime(dt),
            dotColor: Colors.blueAccent,
            sortKey: dt,
          ));
        }
      }

      // Urutkan aktivitas terbaru (jika ada DateTime valid)
      activities.sort((a, b) => (b.sortKey ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.sortKey ?? DateTime.fromMillisecondsSinceEpoch(0)));
      final trimmed = activities.take(6).toList();

      setState(() {
        _totalSiswa = totalSiswa;
        _totalTugas = totalTugas;
        _totalPengumuman = totalPengumuman;
        _kehadiranHariIni = kehadiranHariIni;
        _deadlineMingguIni = deadlineMingguIni;
        _activities = trimmed;
        _isLoading = false;
      });
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => page),
      );
    }
    
    void logout() async {
      final navigator = Navigator.of(context);
      void show(String msg) => showFeedback(context, msg);
      try {
        final authController = Provider.of<AuthController>(context, listen: false);
        await authController.logout();
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
        title: const Text(
          'Dashboard',
          style: BrandTextStyles.appBarTitle,
        ),
        actions: [
          IconButton(
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            icon: const Icon(Icons.note_alt_outlined, color: Colors.white),
            tooltip: 'Catatan Lokal',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotesPage()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
              child: Consumer<AuthController>(
                builder: (context, auth, _) {
                  final avatar = auth.avatar;
                  final username = (auth.user?['username'] ?? 'A').toString();
                  final initials = username.isNotEmpty
                      ? username.substring(0, 1).toUpperCase()
                      : 'A';
                  Widget child;
                  if (avatar != null && avatar.isNotEmpty) {
                    child = ClipOval(
                      child: avatar.startsWith('http')
                          ? Image.network(avatar, fit: BoxFit.cover)
                          : Image.asset(avatar, fit: BoxFit.cover),
                    );
                  } else {
                    child = Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: child,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Sidebar(
        selectedIndex: 0,
        onTapDashboard: () => Navigator.of(context).pop(),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapPresensi: () => goTo(const PresensiPage()),
        onTapNilai: () => goTo(const NilaiPage()),
        onTapJadwal: () => goTo(JadwalPage()),
        onTapTugas: () => goTo(TugasPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onLogout: logout,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchDashboardData,
          color: BrandColors.navy900,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 56),
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
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Halo, ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.92),
                              ),
                            ),
                            TextSpan(
                              text: 'Admin',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: BrandColors.amber400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Text(
                          'Selamat datang kembali, berikut ringkasan aktivitas hari ini',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.84),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Content Panel (konsisten dengan halaman lain)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: BrandColors.gray100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade600),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _error ?? '',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  color: Colors.red.shade600,
                                  tooltip: 'Coba lagi',
                                  onPressed: _fetchDashboardData,
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Cards Section
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Total Siswa Card (Large)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [BrandColors.amber400, Color(0xFFFDD79B)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: BrandColors.amber400.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Siswa',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: BrandColors.navy700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _isLoading 
                                            ? const CircularProgressIndicator(color: BrandColors.navy900)
                                            : Text(
                                                _totalSiswa.toString(),
                                                style: const TextStyle(
                                                  fontSize: 52,
                                                  fontWeight: FontWeight.bold,
                                                  color: BrandColors.navy900,
                                                  height: 1,
                                                ),
                                              ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            '↑ + 12',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: BrandColors.navy900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: BrandColors.navy900.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.groups,
                                        size: 50,
                                        color: BrandColors.navy900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Grid of 3 Cards
                              Row(
                                children: [
                                  // Kehadiran Card
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF12336F), Color(0xFF0A1F44)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.18),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.08),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Kehadiran hari ini',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white.withOpacity(0.9),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.12),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.calendar_today,
                                                        size: 14,
                                                        color: Colors.white.withOpacity(0.9),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        'Hari ini',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white.withOpacity(0.9),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _isLoading 
                                              ? const CircularProgressIndicator(color: Colors.white)
                                              : Text(
                                                  _totalSiswa > 0 
                                                      ? '${((_kehadiranHariIni / _totalSiswa) * 100).toStringAsFixed(0)}%'
                                                      : '0%',
                                                  style: const TextStyle(
                                                    fontSize: 48,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    height: 1,
                                                  ),
                                                ),
                                          const SizedBox(height: 16),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.15),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.withOpacity(0.2),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        size: 16,
                                                        color: Colors.green[300],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Flexible(
                                                      child: _isLoading
                                                          ? const SizedBox(
                                                              height: 16,
                                                              width: 16,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Colors.white,
                                                              ),
                                                            )
                                                          : Text(
                                                              _totalSiswa > 0
                                                                  ? '$_kehadiranHariIni/$_totalSiswa Hadir'
                                                                  : 'Belum ada data siswa',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.white.withOpacity(0.95),
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.trending_up,
                                                    size: 16,
                                                    color: Colors.green[300],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 16),
                                  
                                  // Right Column (Tugas & Pengumuman)
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        // Tugas Aktif Card
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _isLoading 
                                                  ? const CircularProgressIndicator(color: Color(0xFF0A1F44))
                                                  : Text(
                                                      _totalTugas.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFF0A1F44),
                                                        height: 1,
                                                      ),
                                                    ),
                                              const SizedBox(height: 6),
                                              const Text(
                                                'Tugas Aktif',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              _isLoading
                                                  ? const SizedBox(
                                                      height: 14,
                                                      width: 14,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Color(0xFF0A1F44),
                                                      ),
                                                    )
                                                  : Text(
                                                      '$_deadlineMingguIni deadline minggu ini',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: _deadlineMingguIni > 0
                                                            ? Colors.red[400]
                                                            : Colors.green[600],
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Pengumuman Card
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _isLoading 
                                                  ? const CircularProgressIndicator(color: Color(0xFF0A1F44))
                                                  : Text(
                                                      _totalPengumuman.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFF0A1F44),
                                                        height: 1,
                                                      ),
                                                    ),
                                              const SizedBox(height: 6),
                                              const Text(
                                                'Pengumuman baru',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              const Text(
                                                'Diperbarui otomatis',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Aktivitas Terbaru Section
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Aktivitas Terbaru',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: BrandColors.navy900,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (_isLoading)
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: BrandColors.navy900,
                                          ),
                                        ),
                                      )
                                    else if (_activities.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.inbox, color: Colors.black38),
                                            SizedBox(width: 8),
                                            Text(
                                              'Belum ada aktivitas terbaru',
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Column(
                                        children: _activities
                                            .map((a) => _buildActivityItem(
                                                  a.title,
                                                  a.subtitle,
                                                  a.timeText,
                                                  a.dotColor,
                                                  isLast: _activities.last == a,
                                                ))
                                            .toList(),
                                      )
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
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

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final normalized = raw.contains(' ') ? raw.replaceFirst(' ', 'T') : raw;
    return DateTime.tryParse(normalized);
  }

  String _formatRelativeTime(DateTime? dt) {
    if (dt == null) return '-';
    final now = DateTime.now();
    final diff = now.difference(dt);

    // Jika tanggal di masa depan, tampilkan “dalam X …”
    if (diff.isNegative) {
      final ahead = dt.difference(now);
      if (ahead.inSeconds < 60) return 'dalam ${ahead.inSeconds}s';
      if (ahead.inMinutes < 60) return 'dalam ${ahead.inMinutes}m';
      if (ahead.inHours < 24) return 'dalam ${ahead.inHours} jam';
      if (ahead.inDays == 1) return 'Besok';
      if (ahead.inDays < 7) return 'dalam ${ahead.inDays} hari';
      return 'dalam ${(ahead.inDays / 7).ceil()} minggu';
    }

    // Masa lalu
    if (diff.inSeconds < 60) return '${diff.inSeconds}s lalu';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${(diff.inDays / 7).floor()} minggu lalu';
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    Color dotColor, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0A1F44),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) const SizedBox(height: 14),
        if (!isLast)
          Container(
            height: 1,
            color: const Color(0xFFEAEAEA),
          ),
      ],
    );
  }
}

class ActivityItem {
  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.dotColor,
    this.sortKey,
  });

  final String title;
  final String subtitle;
  final String timeText;
  final Color dotColor;
  final DateTime? sortKey;
}