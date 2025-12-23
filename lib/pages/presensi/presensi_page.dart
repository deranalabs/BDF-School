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
  bool _hasChanges = false;
  final List<_PresenceRecord> _records = [
    const _PresenceRecord(
      name: 'Ahmad Rizki',
      kelas: '12A',
      time: '07:45',
      status: PresenceStatus.hadir,
    ),
    const _PresenceRecord(
      name: 'Siti Nurhaliza',
      kelas: '12A',
      time: '07:50',
      status: PresenceStatus.hadir,
    ),
    const _PresenceRecord(
      name: 'Budi Santoso',
      kelas: '12A',
      time: '-',
      status: PresenceStatus.izin,
    ),
  ];

  void _changeStatus(_PresenceRecord record, PresenceStatus status) {
    setState(() {
      final idx = _records.indexOf(record);
      if (idx != -1) {
        _records[idx] = _records[idx].copyWith(status: status);
        _hasChanges = true;
      }
    });
    showFeedback(context, 'Status ${record.name} diubah ke ${_labelStatus(status)}');
  }

  String _labelStatus(PresenceStatus status) {
    switch (status) {
      case PresenceStatus.hadir:
        return 'Hadir';
      case PresenceStatus.izin:
        return 'Izin';
      case PresenceStatus.sakit:
        return 'Sakit';
      case PresenceStatus.alpa:
        return 'Alpa';
    }
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
      showFeedback(context, 'Tanggal: ${_dateController.text}');
    }
  }

  void _saveRecap() {
    if (!_hasChanges) {
      showFeedback(context, 'Tidak ada perubahan untuk disimpan');
      return;
    }
    setState(() => _hasChanges = false);
    showFeedback(context, 'Rekap presensi disimpan');
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
          'Presensi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
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
                    Text('Presensi Kehadiran', style: titleStyle),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola dan pantau kehadiran siswa secara real-time',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    title: 'Hadir',
                    value: count(PresenceStatus.hadir).toString(),
                    color: const Color(0xFF1ABC9C),
                    background: const Color(0xFFE8FFF5),
                    icon: Icons.check_circle_outline,
                  ),
                  _StatCard(
                    title: 'Izin',
                    value: count(PresenceStatus.izin).toString(),
                    color: const Color(0xFF1C7ED6),
                    background: const Color(0xFFE9F3FF),
                    icon: Icons.article_outlined,
                  ),
                  _StatCard(
                    title: 'Sakit',
                    value: count(PresenceStatus.sakit).toString(),
                    color: const Color(0xFFF39C12),
                    background: const Color(0xFFFFF5E6),
                    icon: Icons.access_time,
                  ),
                  _StatCard(
                    title: 'Alpa',
                    value: count(PresenceStatus.alpa).toString(),
                    color: const Color(0xFFE74C3C),
                    background: const Color(0xFFFFEDEE),
                    icon: Icons.close,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
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
                        onChanged: (v) {
                          setState(() => _selectedClass = v ?? 'Semua Kelas');
                          showFeedback(context, 'Filter kelas: ${v ?? 'Semua Kelas'}');
                        },
                        initialValue: _selectedClass,
                      ),
                    ),
                    _LabeledField(
                      label: 'Tanggal',
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: _fieldDecoration('12/22/2025').copyWith(
                          prefixIcon: const Icon(Icons.calendar_month_outlined, color: Color(0xFF9AA5B5)),
                        ),
                      ),
                    ),
                    _LabeledField(
                      label: 'Cari Siswa',
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
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
              ),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                      child: Row(
                        children: [
                          const Text(
                            'Data Kehadiran',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F80FF),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _saveRecap,
                            icon: const Icon(Icons.save_outlined, size: 18, color: Colors.white),
                            label: const Text(
                              'Simpan Rekap',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text('Nama Siswa', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('Kelas', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('Waktu', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('Status', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          SizedBox(width: 44),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE6E6E6)),
                    ...visibleRecords.map(
                      (r) => _PresenceRow(
                        record: r,
                        onAddNote: _showNoteDialog,
                        onChangeStatus: (status) => _changeStatus(r, status),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNoteDialog(_PresenceRecord record) async {
    final noteController = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
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
                      'Tambah Keterangan',
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
                const SizedBox(height: 8),
                const Text(
                  'Nama Siswa',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  readOnly: true,
                  decoration: _fieldDecoration(record.name),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3FAE9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Hadir',
                    style: TextStyle(color: Color(0xFF1ABC9C), fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Keterangan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: noteController,
                  minLines: 3,
                  maxLines: 4,
                  decoration: _fieldDecoration(
                    'Masukkan keterangan (contoh: Sakit demam, Izin keperluan keluarga, dll.)',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (noteController.text.isEmpty) {
                            showFeedback(context, 'Tambahkan keterangan terlebih dahulu');
                            return;
                          }
                          Navigator.of(context).pop();
                          showFeedback(context, 'Catatan disimpan');
                        },
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Color(0xFFE0E5F1)),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

class _PresenceRow extends StatelessWidget {
  const _PresenceRow({
    required this.record,
    required this.onAddNote,
    required this.onChangeStatus,
  });

  final _PresenceRecord record;
  final void Function(_PresenceRecord) onAddNote;
  final void Function(PresenceStatus) onChangeStatus;

  @override
  Widget build(BuildContext context) {
    final statusChip = _statusChip(record.status);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _statusDot(record.status),
                const SizedBox(width: 10),
                Text(
                  record.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: _kelasChip(record.kelas),
          ),
          Expanded(
            flex: 2,
            child: Text(
              record.time,
              style: const TextStyle(color: Color(0xFF4A5568)),
            ),
          ),
          Expanded(
            flex: 2,
            child: statusChip,
          ),
          SizedBox(
            width: 44,
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onAddNote(record),
            ),
          ),
          PopupMenuButton<PresenceStatus>(
            icon: const Icon(Icons.swap_horiz),
            onSelected: onChangeStatus,
            itemBuilder: (context) => const [
              PopupMenuItem(value: PresenceStatus.hadir, child: Text('Tandai Hadir')),
              PopupMenuItem(value: PresenceStatus.izin, child: Text('Tandai Izin')),
              PopupMenuItem(value: PresenceStatus.sakit, child: Text('Tandai Sakit')),
              PopupMenuItem(value: PresenceStatus.alpa, child: Text('Tandai Alpa')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kelasChip(String kelas) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD9DFE7)),
      ),
      child: Text(
        kelas,
        style: const TextStyle(
          color: Color(0xFF2F80FF),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _statusChip(PresenceStatus status) {
    Color color;
    String label;
    switch (status) {
      case PresenceStatus.hadir:
        color = const Color(0xFF1ABC9C);
        label = 'Hadir';
        break;
      case PresenceStatus.izin:
        color = const Color(0xFF1C7ED6);
        label = 'Izin';
        break;
      case PresenceStatus.sakit:
        color = const Color(0xFFF39C12);
        label = 'Sakit';
        break;
      case PresenceStatus.alpa:
        color = const Color(0xFFE74C3C);
        label = 'Alpa';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD9DFE7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statusDot(status, size: 7),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusDot(PresenceStatus status, {double size = 6}) {
    Color color;
    switch (status) {
      case PresenceStatus.hadir:
        color = const Color(0xFF1ABC9C);
        break;
      case PresenceStatus.izin:
        color = const Color(0xFF1C7ED6);
        break;
      case PresenceStatus.sakit:
        color = const Color(0xFFF39C12);
        break;
      case PresenceStatus.alpa:
        color = const Color(0xFFE74C3C);
        break;
    }
    return CircleAvatar(radius: size / 2, backgroundColor: color);
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.background,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
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
