// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../tugas/tugas_page.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../profile/profile_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../../utils/feedback.dart';
import '../auth/login_screen.dart';

class PresensiPage extends StatefulWidget {
  const PresensiPage({super.key});

  @override
  State<PresensiPage> createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  final _searchController = TextEditingController();
  final _dateController = TextEditingController(text: '12/22/2025');
  final _baseUrl = 'http://192.168.110.83:3000';
  String _selectedClass = 'Semua Kelas';
  
  List<_PresenceRecord> _records = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPresensi();
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
      final response = await http.get(Uri.parse('$_baseUrl/api/presensi'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final records = (data['data'] as List)
              .map((record) => _PresenceRecord(
                    name: record['nama_siswa'] ?? 'Unknown',
                    nis: record['nis'] ?? '',
                    kelas: 'Kelas 1', // Hardcoded for now
                    status: _parseStatus(record['status']),
                    time: '07:30', // Hardcoded for now
                  ))
              .toList();
          
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
      default:
        return _PresenceStatus.hadir;
    }
  }

  void _changeStatus(_PresenceRecord record, _PresenceStatus status) {
    setState(() {
      final idx = _records.indexOf(record);
      if (idx != -1) {
        _records[idx] = _records[idx].copyWith(status: status);
      }
    });
    showFeedback(context, 'Status ${record.name} diubah');
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && mounted) {
      _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    int count(_PresenceStatus status) => _records.where((r) => r.status == status).length;
    final query = _searchController.text.trim().toLowerCase();
    final visibleRecords = _records.where((r) {
      final matchClass = _selectedClass == 'Semua Kelas' || r.kelas == _selectedClass;
      final matchSearch = query.isEmpty || r.name.toLowerCase().contains(query);
      return matchClass && matchSearch;
    }).toList();

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
          'Presensi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0A1F44),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manajemen Presensi',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Kelola dan pantau presensi semua siswa',
                  style: TextStyle(
                    color: Color(0xFFB0C4DE),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Hadir',
                        value: count(_PresenceStatus.hadir).toString(),
                        color: const Color(0xFF4CAF50),
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Izin',
                        value: count(_PresenceStatus.izin).toString(),
                        color: const Color(0xFF2196F3),
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
                        value: count(_PresenceStatus.sakit).toString(),
                        color: const Color(0xFFFF9800),
                        icon: Icons.medical_services,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Alpha',
                        value: count(_PresenceStatus.alfa).toString(),
                        color: const Color(0xFFF44336),
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
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDB45B)),
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

    if (_records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.how_to_reg_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data presensi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Filter Section
            Row(
              children: [
                Expanded(
                  child: _FilterDropdown(
                    value: _selectedClass,
                    items: const ['Semua Kelas', 'Kelas 1', 'Kelas 2', 'Kelas 3', 'Kelas 4'],
                    onChanged: (v) => setState(() => _selectedClass = v ?? 'Semua Kelas'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    controller: _dateController,
                    onTap: _pickDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Search Field
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Nama Siswa',
                hintStyle: const TextStyle(color: Color(0xFF9AA5B5)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA5B5)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Records List
            ..._records.map(
              (r) => _PresenceCard(
                record: r,
                onChangeStatus: (status) => _changeStatus(r, status),
              ),
            ),
          ],
        ),
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
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
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
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9AA5B5)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.onTap,
  });

  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xFF9AA5B5), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                controller.text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresenceCard extends StatelessWidget {
  const _PresenceCard({
    required this.record,
    required this.onChangeStatus,
  });

  final _PresenceRecord record;
  final void Function(_PresenceStatus) onChangeStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        record.kelas,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      record.time,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ubah Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 20),
              _StatusMenuItem(
                label: 'Hadir',
                color: const Color(0xFF4CAF50),
                icon: Icons.check_circle,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(_PresenceStatus.hadir);
                },
              ),
              _StatusMenuItem(
                label: 'Izin',
                color: const Color(0xFF2196F3),
                icon: Icons.description,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(_PresenceStatus.izin);
                },
              ),
              _StatusMenuItem(
                label: 'Sakit',
                color: const Color(0xFFFF9800),
                icon: Icons.medical_services,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(_PresenceStatus.sakit);
                },
              ),
              _StatusMenuItem(
                label: 'Alpha',
                color: const Color(0xFFF44336),
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
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
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
          color: color.withOpacity(0.1),
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
    Color color;
    String label;
    IconData icon;
    
    switch (status) {
      case _PresenceStatus.hadir:
        color = const Color(0xFF4CAF50);
        label = 'Hadir';
        icon = Icons.check_circle;
        break;
      case _PresenceStatus.izin:
        color = const Color(0xFF2196F3);
        label = 'Izin';
        icon = Icons.description;
        break;
      case _PresenceStatus.sakit:
        color = const Color(0xFFFF9800);
        label = 'Sakit';
        icon = Icons.medical_services;
        break;
      case _PresenceStatus.alfa:
        color = const Color(0xFFF44336);
        label = 'Alpha';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

enum _PresenceStatus { hadir, izin, sakit, alfa }

class _PresenceRecord {
  final String name;
  final String nis;
  final String kelas;
  final String time;
  final _PresenceStatus status;
  
  const _PresenceRecord({
    required this.name,
    this.nis = '',
    required this.kelas,
    required this.time,
    required this.status,
  });

  _PresenceRecord copyWith({
    String? name,
    String? nis,
    String? kelas,
    String? time,
    _PresenceStatus? status,
  }) {
    return _PresenceRecord(
      name: name ?? this.name,
      nis: nis ?? this.nis,
      kelas: kelas ?? this.kelas,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}