// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
  String _selectedClass = 'Semua Kelas';
  
  final List<_PresenceRecord> _records = [
    const _PresenceRecord(
      name: 'Bayu Mulyana',
      kelas: 'Kelas 2',
      time: '07:45',
      status: PresenceStatus.hadir,
    ),
    const _PresenceRecord(
      name: 'Daya Pratama',
      kelas: 'Kelas 3',
      time: '07:50',
      status: PresenceStatus.izin,
    ),
    const _PresenceRecord(
      name: 'Fira Riyanti',
      kelas: 'Kelas 4',
      time: '07:55',
      status: PresenceStatus.sakit,
    ),
    const _PresenceRecord(
      name: 'Ahmad Fauzi',
      kelas: 'Kelas 1',
      time: '07:58',
      status: PresenceStatus.alpa,
    ),
  ];

  void _changeStatus(_PresenceRecord record, PresenceStatus status) {
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
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int count(PresenceStatus status) => _records.where((r) => r.status == status).length;
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
                        value: count(PresenceStatus.hadir).toString(),
                        color: const Color(0xFF4CAF50),
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Izin',
                        value: count(PresenceStatus.izin).toString(),
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
                        value: count(PresenceStatus.sakit).toString(),
                        color: const Color(0xFFFF9800),
                        icon: Icons.medical_services,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Alpha',
                        value: count(PresenceStatus.alpa).toString(),
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
            child: Container(
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
                    ...visibleRecords.map(
                      (r) => _PresenceCard(
                        record: r,
                        onChangeStatus: (status) => _changeStatus(r, status),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
  final void Function(PresenceStatus) onChangeStatus;

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

  void _showStatusMenu(BuildContext context, void Function(PresenceStatus) onChangeStatus) {
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
                  onChangeStatus(PresenceStatus.hadir);
                },
              ),
              _StatusMenuItem(
                label: 'Izin',
                color: const Color(0xFF2196F3),
                icon: Icons.description,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(PresenceStatus.izin);
                },
              ),
              _StatusMenuItem(
                label: 'Sakit',
                color: const Color(0xFFFF9800),
                icon: Icons.medical_services,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(PresenceStatus.sakit);
                },
              ),
              _StatusMenuItem(
                label: 'Alpha',
                color: const Color(0xFFF44336),
                icon: Icons.cancel,
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus(PresenceStatus.alpa);
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

  final PresenceStatus status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;
    
    switch (status) {
      case PresenceStatus.hadir:
        color = const Color(0xFF4CAF50);
        label = 'Hadir';
        icon = Icons.check_circle;
        break;
      case PresenceStatus.izin:
        color = const Color(0xFF2196F3);
        label = 'Izin';
        icon = Icons.description;
        break;
      case PresenceStatus.sakit:
        color = const Color(0xFFFF9800);
        label = 'Sakit';
        icon = Icons.medical_services;
        break;
      case PresenceStatus.alpa:
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

enum PresenceStatus { hadir, izin, sakit, alpa }

class _PresenceRecord {
  final String name;
  final String kelas;
  final String time;
  final PresenceStatus status;
  
  const _PresenceRecord({
    required this.name,
    required this.kelas,
    required this.time,
    required this.status,
  });

  _PresenceRecord copyWith({
    String? name,
    String? kelas,
    String? time,
    PresenceStatus? status,
  }) {
    return _PresenceRecord(
      name: name ?? this.name,
      kelas: kelas ?? this.kelas,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}