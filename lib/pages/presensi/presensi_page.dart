// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../tugas/tugas_page.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../../utils/feedback.dart';
import '../auth/login_screen.dart';
import '../../utils/api_client.dart';
import '../../state/auth_controller.dart';
import '../../theme/brand.dart';

class PresensiPage extends StatefulWidget {
  const PresensiPage({super.key});

  @override
  State<PresensiPage> createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  final _searchController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedClass = 'Semua Kelas';
  _PresenceStatus? _selectedStatus;
  String? _selectedDate;
  
  List<_PresenceRecord> _records = [];
  List<_StudentOption> _students = [];
  bool _isLoading = false;
  bool _isLoadingStudents = false;
  String? _error;
  late ApiClient _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _sanitizeDate(String raw) {
    final trimmed = raw.trim();
    // match YYYY-MM-DD with optional time HH:mm or HH:mm:ss
    final dtMatch = RegExp(r'^(\d{4})[-/](\d{2})[-/](\d{2})(?:[ T](\d{2}:\d{2}(?::\d{2})?))?$').firstMatch(trimmed);
    if (dtMatch != null) {
      final datePart = '${dtMatch.group(1)}-${dtMatch.group(2)}-${dtMatch.group(3)}';
      final timePart = dtMatch.group(4);
      return timePart != null ? '$datePart $timePart' : datePart;
    }
    // fallback: take first token before space/T for date-only
    final token = trimmed.split(RegExp(r'[ T]')).firstWhere((e) => e.isNotEmpty, orElse: () => '');
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(token)) return token;
    return null;
  }

  String _extractTime(String raw) {
    final trimmed = raw.trim();
    // handle "YYYY-MM-DD HH:mm" or "YYYY-MM-DDTHH:mm:ss"
    final match = RegExp(r'[T ](\d{2}:\d{2}(?::\d{2})?)').firstMatch(trimmed);
    if (match != null) return match.group(1)!;
    // fallback: if only HH:mm provided
    final onlyTime = RegExp(r'^(\d{2}:\d{2}(?::\d{2})?)$').firstMatch(trimmed);
    if (onlyTime != null) return onlyTime.group(1)!;
    return '';
  }

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<AuthController>());
    _fetchStudents();
    _fetchPresensi();
  }

  Future<void> _fetchStudents() async {
    setState(() => _isLoadingStudents = true);
    try {
      final res = await _api.get('/api/siswa');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = (data['data'] as List?) ?? [];
        setState(() {
          _students = list
              .map<_StudentOption>((s) => _StudentOption(
                    id: s['id'],
                    name: s['nama'] ?? '',
                    nis: (s['nis'] ?? '').toString(),
                    kelas: s['kelas'] ?? '',
                    jurusan: s['jurusan'] ?? '',
                  ))
              .toList();
        });
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoadingStudents = false);
    }
  }

  Future<void> _showAddPresensiDialog() async {
    _StudentOption? selectedSiswa;
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final today = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $hh:$mm';
    final dateController = TextEditingController(text: today);
    _PresenceStatus status = _PresenceStatus.hadir;
    final ketController = TextEditingController();

    InputDecoration inputDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: BrandColors.gray100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
    }

    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tambah Presensi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                const SizedBox(height: 16),
                _isLoadingStudents
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : DropdownButtonFormField<_StudentOption>(
                        isExpanded: true,
                        value: selectedSiswa,
                        decoration: inputDecoration('Pilih Siswa'),
                        items: _students
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    '${s.name} • ${s.nis} • ${s.kelas}/${s.jurusan}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        selectedItemBuilder: (_) => _students
                            .map((s) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${s.name} • ${s.nis} • ${s.kelas}/${s.jurusan}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) => selectedSiswa = v,
                      ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: inputDecoration('Tanggal (YYYY-MM-DD HH:mm)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<_PresenceStatus>(
                  value: status,
                  decoration: inputDecoration('Status'),
                  items: const [
                    DropdownMenuItem(value: _PresenceStatus.hadir, child: Text('Hadir')),
                    DropdownMenuItem(value: _PresenceStatus.izin, child: Text('Izin')),
                    DropdownMenuItem(value: _PresenceStatus.sakit, child: Text('Sakit')),
                    DropdownMenuItem(value: _PresenceStatus.alfa, child: Text('Alpha')),
                  ],
                  onChanged: (v) => status = v ?? _PresenceStatus.hadir,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ketController,
                  decoration: inputDecoration('Keterangan'),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: BrandButtons.primary().copyWith(
                      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                    ),
                    onPressed: _isLoadingStudents
                        ? null
                        : () async {
                            if (selectedSiswa == null || dateController.text.isEmpty) {
                              showFeedback(context, 'Siswa dan tanggal wajib diisi');
                              return;
                            }
                            final messenger = ScaffoldMessenger.of(context);
                            void show(String msg) => messenger.showSnackBar(SnackBar(content: Text(msg)));
                            final navigator = Navigator.of(ctx);
                            try {
                              final sanitizedDate = _sanitizeDate(dateController.text);
                              if (sanitizedDate == null) {
                                show('Format tanggal tidak valid, gunakan YYYY-MM-DD');
                                return;
                              }
                              final finalDate = sanitizedDate.length == 10
                                  ? '$sanitizedDate ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}'
                                  : sanitizedDate;
                              final res = await _api.post(
                                '/api/presensi',
                                body: {
                                  'siswa_id': selectedSiswa!.id,
                                  'tanggal': finalDate,
                                  'status': _statusToString(status),
                                  'keterangan': ketController.text,
                                },
                              );
                              if (res.statusCode == 201) {
                                navigator.pop();
                                await _fetchPresensi();
                                show('Presensi ditambahkan');
                              } else {
                                show('Gagal menambah presensi');
                              }
                            } catch (e) {
                              show('Error: $e');
                            }
                          },
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: BrandColors.navy900,
                      side: const BorderSide(color: BrandColors.navy900),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w700),
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

  Future<void> _confirmDelete(_PresenceRecord record) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Presensi'),
        content: Text('Hapus presensi ${record.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final res = await _api.delete('/api/presensi/${record.id}');
      if (res.statusCode == 200) {
        await _fetchPresensi();
        if (!mounted) return;
        showFeedback(context, 'Presensi dihapus');
      } else {
        if (!mounted) return;
        showFeedback(context, 'Gagal hapus presensi');
      }
    } catch (e) {
      if (!mounted) return;
      showFeedback(context, 'Error: $e');
    }
  }

  void _openFilter() {
    String kelasTemp = _selectedClass;
    _PresenceStatus? statusTemp = _selectedStatus;
    String? dateTemp = _selectedDate;
    dateTemp = _sanitizeDate(dateTemp ?? '') ?? dateTemp;
    final dateCtrl = TextEditingController(text: dateTemp ?? '');

    showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          Future<void> pickDate() async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: DateTime(now.year - 1),
              lastDate: DateTime(now.year + 1),
            );
            if (picked != null) {
              dateTemp = '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
              setStateDialog(() {
                dateCtrl.text = dateTemp!;
              });
            }
          }

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Filter Presensi',
                          style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Kelas', style: BrandTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: BrandColors.gray700)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: BrandColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BrandColors.gray300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: kelasTemp,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'Semua Kelas', child: Text('Semua Kelas')),
                          DropdownMenuItem(value: '10', child: Text('Kelas 10')),
                          DropdownMenuItem(value: '11', child: Text('Kelas 11')),
                          DropdownMenuItem(value: '12', child: Text('Kelas 12')),
                        ],
                        onChanged: (v) => setStateDialog(() => kelasTemp = v ?? 'Semua Kelas'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Tanggal', style: BrandTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: BrandColors.gray700)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: dateCtrl,
                    readOnly: true,
                    onTap: pickDate,
                    decoration: InputDecoration(
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_month, color: BrandColors.gray500),
                      filled: true,
                      fillColor: BrandColors.gray100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Status', style: BrandTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: BrandColors.gray700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusChip(label: 'Semua', color: BrandColors.navy700, selected: statusTemp == null, onTap: () => setStateDialog(() => statusTemp = null)),
                      _StatusChip(label: 'Hadir', color: const Color(0xFF2E7D32), selected: statusTemp == _PresenceStatus.hadir, onTap: () => setStateDialog(() => statusTemp = _PresenceStatus.hadir)),
                      _StatusChip(label: 'Izin', color: BrandColors.navy700, selected: statusTemp == _PresenceStatus.izin, onTap: () => setStateDialog(() => statusTemp = _PresenceStatus.izin)),
                      _StatusChip(label: 'Sakit', color: BrandColors.amber400, selected: statusTemp == _PresenceStatus.sakit, onTap: () => setStateDialog(() => statusTemp = _PresenceStatus.sakit)),
                      _StatusChip(label: 'Alpha', color: const Color(0xFFD32F2F), selected: statusTemp == _PresenceStatus.alfa, onTap: () => setStateDialog(() => statusTemp = _PresenceStatus.alfa)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BrandColors.navy900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop({
                              'kelas': kelasTemp,
                              'tanggal': dateTemp,
                              'status': statusTemp,
                            });
                          },
                          child: const Text('Terapkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop({'kelas': 'Semua Kelas', 'tanggal': null, 'status': null}),
                        child: const Text('Reset', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).then((value) async {
      if (value == null) return;
      setState(() {
        _selectedClass = value['kelas'] as String? ?? 'Semua Kelas';
        final dateFromDialog = value['tanggal'] as String?;
        _selectedDate = _sanitizeDate(dateFromDialog ?? '') ?? dateFromDialog;
        _selectedStatus = value['status'] as _PresenceStatus?;
        _dateController.text = _selectedDate ?? '';
      });
      await _fetchPresensi();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchPresensi() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final hasDate = _selectedDate != null && _selectedDate!.trim().isNotEmpty;
      final query = hasDate ? '?tanggal=${Uri.encodeQueryComponent(_selectedDate!.trim())}' : '';
      final response = await _api.get('/api/presensi$query');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final records = (data['data'] as List).map((record) {
            final rawTanggal = (record['tanggal'] ?? '').toString();
            final sanitizedDate = _sanitizeDate(rawTanggal) ?? rawTanggal;
            final timeFromRaw = _extractTime(rawTanggal);
            final time = timeFromRaw.isNotEmpty ? timeFromRaw : _extractTime(sanitizedDate);
            final rawKelas = (record['kelas'] ?? '').toString().trim();
            final kelasClean = rawKelas.toLowerCase().startsWith('kelas')
                ? rawKelas.replaceFirst(RegExp('^kelas\\s*', caseSensitive: false), '')
                : rawKelas;
            return _PresenceRecord(
              id: record['id']?.toString(),
              siswaId: record['siswa_id']?.toString(),
              name: record['nama_siswa'] ?? 'Unknown',
              nis: (record['nis'] ?? '').toString(),
              kelas: kelasClean.isEmpty ? '-' : kelasClean,
              status: _parseStatus(record['status']),
              tanggal: sanitizedDate,
              keterangan: (record['keterangan'] ?? '').toString(),
              time: time,
            );
          }).toList();
          
          setState(() {
            _records = records;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load presensi');
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat presensi: $e';
        _isLoading = false;
      });
    }
  }

  _PresenceStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'hadir':
        return _PresenceStatus.hadir;
      case 'izin':
        return _PresenceStatus.izin;
      case 'sakit':
        return _PresenceStatus.sakit;
      case 'alfa':
        return _PresenceStatus.alfa;
      case 'alpha':
        return _PresenceStatus.alfa;
      default:
        return _PresenceStatus.hadir;
    }
  }

  String _statusToString(_PresenceStatus status) {
    switch (status) {
      case _PresenceStatus.hadir:
        return 'Hadir';
      case _PresenceStatus.izin:
        return 'Izin';
      case _PresenceStatus.sakit:
        return 'Sakit';
      case _PresenceStatus.alfa:
        return 'Alpha';
    }
  }

  Future<void> _changeStatus(_PresenceRecord record, _PresenceStatus status) async {
    final idx = _records.indexWhere((r) => r.id == record.id);
    if (idx == -1) return;

    final previous = _records[idx];
    setState(() {
      _records[idx] = _records[idx].copyWith(status: status);
    });

    try {
      final sanitizedDate = _sanitizeDate(record.tanggal) ?? record.tanggal;
      final res = await _api.put(
        '/api/presensi/${record.id}',
        body: {
          'siswa_id': record.siswaId,
          'tanggal': sanitizedDate,
          'status': _statusToString(status),
          'keterangan': record.keterangan,
        },
      );
      if (res.statusCode == 200) {
        if (!mounted) return;
        showFeedback(context, 'Status ${record.name} diubah');
      } else {
        setState(() {
          _records[idx] = previous;
        });
        if (!mounted) return;
        showFeedback(context, 'Gagal mengubah status');
      }
    } catch (e) {
      setState(() {
        _records[idx] = previous;
      });
      if (!mounted) return;
      showFeedback(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final visibleRecords = _records.where((r) {
      final matchClass = _selectedClass == 'Semua Kelas' || r.kelas == _selectedClass;
      final matchSearch = query.isEmpty || r.name.toLowerCase().contains(query);
      final matchStatus = _selectedStatus == null || r.status == _selectedStatus;
      final matchDate = _selectedDate == null || (r.tanggal.startsWith(_selectedDate!) || r.time.startsWith(_selectedDate!));
      return matchClass && matchSearch && matchStatus && matchDate;
    }).toList();
    int countFiltered(_PresenceStatus status) => visibleRecords.where((r) => r.status == status).length;

    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
    }
    void logout() async {
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);
      try {
        final authController = Provider.of<AuthController>(context, listen: false);
        await authController.logout();
        _scaffoldKey.currentState?.closeDrawer();
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        messenger.showSnackBar(
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
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Presensi', style: BrandTextStyles.appBarTitle),
      ),
      drawer: Sidebar(
        selectedIndex: 2,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(const TugasPage()),
        onTapJadwal: () => goTo(const JadwalPage()),
        onTapPresensi: () => Navigator.of(context).pop(),
        onTapNilai: () => goTo(const NilaiPage()),
        onTapPengumuman: () => goTo(PengumumanPage()),
        onTapSiswa: () => goTo(DaftarSiswaPage()),
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
                  'Manajemen Presensi',
                  style: BrandTextStyles.heading.copyWith(color: Colors.white, fontSize: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola dan pantau presensi semua siswa',
                  style: BrandTextStyles.bodySecondary.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Hadir',
                        value: countFiltered(_PresenceStatus.hadir).toString(),
                        color: BrandColors.success,
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Izin',
                        value: countFiltered(_PresenceStatus.izin).toString(),
                        color: BrandColors.navy700,
                        icon: Icons.description,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Sakit',
                        value: countFiltered(_PresenceStatus.sakit).toString(),
                        color: BrandColors.amber400,
                        icon: Icons.medical_services,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Alpha',
                        value: countFiltered(_PresenceStatus.alfa).toString(),
                        color: BrandColors.error,
                        icon: Icons.cancel,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content Section
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchPresensi,
              color: BrandColors.navy900,
              backgroundColor: Colors.white,
              child: _buildContent(visibleRecords),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<_PresenceRecord> visibleRecords) {
    final hasFilter = _selectedClass != 'Semua Kelas' ||
        _selectedStatus != null ||
        (_selectedDate?.isNotEmpty ?? false) ||
        _searchController.text.trim().isNotEmpty;

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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPresensi,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (visibleRecords.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          // Search + CTA row (tetap tampil meski kosong)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari nama siswa',
                    hintStyle: const TextStyle(color: BrandColors.gray500),
                    prefixIcon: const Icon(Icons.search, color: BrandColors.gray500),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: BrandColors.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: BrandColors.gray300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: BrandColors.navy900, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 130),
                child: ElevatedButton.icon(
                  style: BrandButtons.accent().copyWith(
                    minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
                    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: _showAddPresensiDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Tambah',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
          const SizedBox(height: 32),
          Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Belum ada data presensi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              hasFilter ? 'Coba reset filter untuk menampilkan semua data' : 'Tambahkan atau muat ulang data presensi',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 20),
          if (hasFilter)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrandColors.navy900,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  setState(() {
                    _selectedClass = 'Semua Kelas';
                    _selectedStatus = null;
                    _selectedDate = null;
                    _dateController.clear();
                    _searchController.clear();
                  });
                  _fetchPresensi();
                },
                child: const Text('Reset filter'),
              ),
            ),
        ],
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: BrandColors.gray100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          // Search + CTA row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari nama siswa',
                    hintStyle: const TextStyle(color: BrandColors.gray500),
                    prefixIcon: const Icon(Icons.search, color: BrandColors.gray500),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: BrandColors.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: BrandColors.gray300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: BrandColors.navy900, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 130),
                child: ElevatedButton.icon(
                  style: BrandButtons.accent().copyWith(
                    minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
                    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: _showAddPresensiDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Tambah',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
          // Records List with separators
          ...List.generate(visibleRecords.length, (i) => i).expand((idx) sync* {
            yield _PresenceCard(
              record: visibleRecords[idx],
              onChangeStatus: (status) => _changeStatus(visibleRecords[idx], status),
              onDelete: () => _confirmDelete(visibleRecords[idx]),
            );
            if (idx != visibleRecords.length - 1) {
              yield const SizedBox(height: 10);
            }
          }),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BrandShadows.card,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: BrandTextStyles.heading.copyWith(color: Colors.white, fontSize: 26),
              ),
              Text(
                title,
                style: BrandTextStyles.body.copyWith(
                  color: Colors.white,
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

class _PresenceCard extends StatelessWidget {
  const _PresenceCard({
    required this.record,
    required this.onChangeStatus,
    this.onDelete,
  });

  final _PresenceRecord record;
  final void Function(_PresenceStatus) onChangeStatus;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BrandShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: BrandTextStyles.subheading.copyWith(fontSize: 16, color: BrandColors.navy900),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      label: 'NIS: ${record.nis}',
                      bg: const Color(0xFFF1F5F9),
                      fg: BrandColors.navy900,
                    ),
                    _InfoChip(
                      label: 'Kelas: ${record.kelas}',
                      bg: const Color(0xFFE8F4FD),
                      fg: BrandColors.navy900,
                    ),
                    if (record.tanggal.isNotEmpty)
                      _InfoChip(
                        label: 'Tanggal: ${record.tanggal}',
                        bg: const Color(0xFFF1F5F9),
                        fg: BrandColors.gray700,
                      ),
                  ],
                ),
              ],
            ),
          ),
          _StatusBadge(status: record.status),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _showStatusMenu(context, onChangeStatus),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.edit, size: 20, color: Color(0xFF4A5568)),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, size: 20, color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusMenu(BuildContext context, void Function(_PresenceStatus) onChangeStatus) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Ubah Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: BrandColors.navy900,
                ),
              ),
              const SizedBox(height: 18),
              _StatusMenuItem(
                label: 'Hadir',
                color: const Color(0xFF2E7D32),
                background: const Color(0xFFE7F3EA),
                icon: Icons.check_circle,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(_PresenceStatus.hadir);
                },
              ),
              _StatusMenuItem(
                label: 'Izin',
                color: BrandColors.navy700,
                background: const Color(0xFFE8EEF7),
                icon: Icons.description,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(_PresenceStatus.izin);
                },
              ),
              _StatusMenuItem(
                label: 'Sakit',
                color: BrandColors.amber400,
                background: const Color(0xFFFFF4E5),
                icon: Icons.medical_services,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(_PresenceStatus.sakit);
                },
              ),
              _StatusMenuItem(
                label: 'Alpha',
                color: const Color(0xFFD32F2F),
                background: const Color(0xFFFFEEEE),
                icon: Icons.cancel,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(_PresenceStatus.alfa);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusMenuItem extends StatelessWidget {
  const _StatusMenuItem({
    required this.label,
    required this.color,
    required this.background,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _PresenceStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case _PresenceStatus.hadir:
        bg = const Color(0xFFE7F3EA);
        fg = BrandColors.success;
        label = 'Hadir';
        break;
      case _PresenceStatus.izin:
        bg = const Color(0xFFE8EEF7);
        fg = BrandColors.navy700;
        label = 'Izin';
        break;
      case _PresenceStatus.sakit:
        bg = const Color(0xFFFFF4E5);
        fg = BrandColors.amber400;
        label = 'Sakit';
        break;
      case _PresenceStatus.alfa:
        bg = const Color(0xFFFFEEEE);
        fg = BrandColors.error;
        label = 'Alpha';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: BrandTextStyles.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? color.withOpacity(0.12) : Colors.white;
    final border = selected ? color.withOpacity(0.3) : const Color(0xFFE5E7EB);
    final txtColor = selected ? color : const Color(0xFF4A5568);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(Icons.check, color: color, size: 16),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: txtColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: BrandTextStyles.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StudentOption {
  final int? id;
  final String name;
  final String nis;
  final String kelas;
  final String jurusan;

  const _StudentOption({
    required this.id,
    required this.name,
    required this.nis,
    required this.kelas,
    required this.jurusan,
  });
}

enum _PresenceStatus { hadir, izin, sakit, alfa }

class _PresenceRecord {
  final String? id;
  final String? siswaId;
  final String name;
  final String nis;
  final String kelas;
  final String time;
  final String tanggal;
  final String? keterangan;
  final _PresenceStatus status;

  const _PresenceRecord({
    this.id,
    this.siswaId,
    required this.name,
    this.nis = '',
    required this.kelas,
    this.time = '',
    this.tanggal = '',
    this.keterangan = '',
    required this.status,
  });

  _PresenceRecord copyWith({
    String? id,
    String? siswaId,
    String? name,
    String? nis,
    String? kelas,
    String? time,
    String? tanggal,
    String? keterangan,
    _PresenceStatus? status,
  }) {
    return _PresenceRecord(
      id: id ?? this.id,
      siswaId: siswaId ?? this.siswaId,
      name: name ?? this.name,
      nis: nis ?? this.nis,
      kelas: kelas ?? this.kelas,
      time: time ?? this.time,
      tanggal: tanggal ?? this.tanggal,
      keterangan: keterangan ?? this.keterangan,
      status: status ?? this.status,
    );
  }
}