import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../theme/brand.dart';

import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../presensi/presensi_page.dart';
import '../tugas/tugas_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../../utils/api_client.dart';
import '../../state/auth_controller.dart';

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _targetController = TextEditingController();
  final _senderController = TextEditingController();
  final _dateController = TextEditingController();
  final _messageController = TextEditingController();

  List<_Announcement> _announcements = [];
  bool _isLoading = false;
  String? _error;
  late ApiClient _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<AuthController>());
    _fetchPengumuman();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _targetController.dispose();
    _senderController.dispose();
    _dateController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final now = DateTime.now();
    DateTime? initial;
    final current = controller.text.trim();
    if (current.isNotEmpty) {
      try {
        initial = DateTime.parse(current);
      } catch (_) {}
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().substring(0, 10);
    }
  }

  static const _targetOptions = ['Semua Kelas', 'Kelas 10', 'Kelas 11', 'Kelas 12'];

  String _normalizeTarget(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value == 'semua' || value.isEmpty) return 'Semua Kelas';
    if (value == 'kelas 10') return 'Kelas 10';
    if (value == 'kelas 11') return 'Kelas 11';
    if (value == 'kelas 12') return 'Kelas 12';
    return 'Semua Kelas';
  }

  String _serializeTarget(String? value) {
    final normalized = _normalizeTarget(value);
    return normalized == 'Semua Kelas' ? 'Semua' : normalized;
  }

  String? _dropdownSafeValue(String? value) {
    final normalized = _normalizeTarget(value);
    return _targetOptions.contains(normalized) ? normalized : null;
  }

  Future<void> _fetchPengumuman() async {

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.get('/api/pengumuman');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final announcements = (data['data'] as List).map((item) {
            late _Announcement ann;
            ann = _Announcement(
              id: item['id']?.toString() ?? '',
              title: item['judul']?.toString() ?? 'Unknown',
              category: item['prioritas']?.toString() ?? 'medium',
              target: _normalizeTarget(item['target']?.toString()),
              sender: item['pengirim']?.toString() ?? '',
              date: item['tanggal']?.toString() ?? '',
              message: item['isi']?.toString() ?? '',
              isPinned: (item['prioritas']?.toString() ?? '').toLowerCase() == 'high',
              onDelete: () => _deleteAnnouncement(ann),
              onEdit: () => _openEditDialog(ann),
            );
            return ann;
          }).toList();
          
          setState(() {
            _announcements = announcements;
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to load pengumuman');
        }
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to load pengumuman');
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat pengumuman: $e';
        _isLoading = false;
      });
    }
  }

  void _openCreateDialog() {
    _titleController.clear();
    _categoryController.clear();
    _targetController.text = 'Semua Kelas';
    _senderController.clear();
    _dateController.clear();
    _messageController.clear();
    final baseDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: BrandColors.gray700, fontWeight: FontWeight.w600),
      hintStyle: const TextStyle(color: BrandColors.gray500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: BrandColors.navy900, width: 2),
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Buat Pengumuman Baru',
                        style: BrandTextStyles.subheading.copyWith(
                          color: BrandColors.navy900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: baseDecoration.copyWith(labelText: 'Judul Pengumuman'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _categoryController.text.isNotEmpty ? _categoryController.text : null,
                  decoration: baseDecoration.copyWith(labelText: 'Prioritas (low/medium/high)'),
                  items: const ['low', 'medium', 'high']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => _categoryController.text = v ?? '',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _senderController,
                  decoration: baseDecoration.copyWith(labelText: 'Pengirim'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _dropdownSafeValue(_targetController.text),
                  decoration: baseDecoration.copyWith(labelText: 'Target'),
                  items: _targetOptions
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => _targetController.text = v ?? '',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(_dateController),
                  decoration: baseDecoration.copyWith(
                    labelText: 'Tanggal',
                    hintText: 'YYYY-MM-DD',
                    suffixIcon: const Icon(Icons.calendar_today, size: 18, color: BrandColors.gray500),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _messageController,
                  maxLines: 3,
                  decoration: baseDecoration.copyWith(labelText: 'Pesan'),
                ),
                const SizedBox(height: 20),
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
                        onPressed: () => Navigator.pop(context),
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
                          final messenger = ScaffoldMessenger.of(context);
                          void show(String msg) => messenger.showSnackBar(SnackBar(content: Text(msg)));
                          try {
                            if (_titleController.text.trim().isEmpty ||
                                _messageController.text.trim().isEmpty ||
                                _senderController.text.trim().isEmpty ||
                                _categoryController.text.trim().isEmpty) {
                              show('Judul, isi, pengirim, dan prioritas wajib diisi');
                              return;
                            }

                            final res = await _api.post(
                              '/api/pengumuman',
                              body: jsonEncode({
                                'judul': _titleController.text,
                                'prioritas': _categoryController.text,
                                'pengirim': _senderController.text,
                                'isi': _messageController.text,
                                'target': _serializeTarget(_targetController.text),
                                'tanggal': _dateController.text,
                              }),
                            );
                            if (res.statusCode == 201) {
                              navigator.pop();
                              await _fetchPengumuman();
                              show('Pengumuman berhasil ditambahkan');
                            } else {
                              final body = jsonDecode(res.body);
                              show(body['message'] ?? 'Gagal menambah pengumuman');
                            }
                          } catch (e) {
                            show('Error: $e');
                          }
                        },
                        child: const Text(
                          'Simpan',
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
          ),
        );
      },
    );
  }

  Future<void> _deleteAnnouncement(_Announcement ann) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pengumuman'),
        content: Text('Hapus pengumuman "${ann.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final res = await _api.delete('/api/pengumuman/${ann.id}');
      if (res.statusCode == 200) {
        await _fetchPengumuman();
        messenger.showSnackBar(const SnackBar(content: Text('Pengumuman dihapus')));
      } else {
        final body = jsonDecode(res.body);
        messenger.showSnackBar(SnackBar(content: Text(body['message'] ?? 'Gagal menghapus pengumuman')));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _openEditDialog(_Announcement ann) {
    _titleController.text = ann.title;
    _categoryController.text = ann.category;
    _senderController.text = ann.sender;
    _dateController.text = ann.date;
    _messageController.text = ann.message;
    _targetController.text = _normalizeTarget(ann.target);

    final baseDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: BrandColors.gray700, fontWeight: FontWeight.w600),
      hintStyle: const TextStyle(color: BrandColors.gray500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: BrandColors.navy900, width: 2),
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Pengumuman',
                        style: BrandTextStyles.subheading.copyWith(
                          color: BrandColors.navy900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: baseDecoration.copyWith(labelText: 'Judul'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _categoryController.text.isNotEmpty ? _categoryController.text : null,
                  decoration: baseDecoration.copyWith(labelText: 'Prioritas'),
                  items: const ['low', 'medium', 'high']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => _categoryController.text = v ?? '',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _senderController,
                  decoration: baseDecoration.copyWith(labelText: 'Pengirim'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(_dateController),
                  decoration: baseDecoration.copyWith(
                    labelText: 'Tanggal',
                    hintText: 'YYYY-MM-DD',
                    suffixIcon: const Icon(Icons.calendar_today, size: 18, color: BrandColors.gray500),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _dropdownSafeValue(_targetController.text),
                  decoration: baseDecoration.copyWith(labelText: 'Target'),
                  items: _targetOptions
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => _targetController.text = v ?? '',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: baseDecoration.copyWith(labelText: 'Isi Pengumuman'),
                ),
                const SizedBox(height: 20),
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
                        onPressed: () => Navigator.pop(context),
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
                          final messenger = ScaffoldMessenger.of(context);
                          void show(String msg) => messenger.showSnackBar(SnackBar(content: Text(msg)));
                          try {
                            if (_titleController.text.trim().isEmpty ||
                                _messageController.text.trim().isEmpty ||
                                _senderController.text.trim().isEmpty ||
                                _categoryController.text.trim().isEmpty) {
                              show('Judul, isi, pengirim, dan prioritas wajib diisi');
                              return;
                            }

                            final res = await _api.put(
                              '/api/pengumuman/${ann.id}',
                              body: jsonEncode({
                                'judul': _titleController.text,
                                'prioritas': _categoryController.text,
                                'pengirim': _senderController.text,
                                'isi': _messageController.text,
                                'target': _serializeTarget(_targetController.text),
                                'tanggal': _dateController.text,
                              }),
                            );
                            if (res.statusCode == 200) {
                              navigator.pop();
                              await _fetchPengumuman();
                              show('Pengumuman diperbarui');
                            } else {
                              final body = jsonDecode(res.body);
                              show(body['message'] ?? 'Gagal memperbarui pengumuman');
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          SnackBar(content: Text('Logout gagal: $e'), backgroundColor: Colors.red),
        );
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: BrandColors.navy900,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Pengumuman', style: BrandTextStyles.appBarTitle),
      ),
      drawer: Sidebar(
        selectedIndex: 6,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => goTo(const TugasPage()),
        onTapJadwal: () => goTo(const JadwalPage()),
        onTapPresensi: () => goTo(const PresensiPage()),
        onTapNilai: () => goTo(const NilaiPage()),
        onTapPengumuman: () => Navigator.of(context).pop(),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onLogout: logout,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: BrandColors.navy900,
          backgroundColor: Colors.white,
          onRefresh: _fetchPengumuman,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                        'Pengumuman Sekolah',
                        style: BrandTextStyles.heading.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kelola dan bagikan informasi penting untuk siswa.',
                        style: BrandTextStyles.bodySecondary.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: BrandButtons.accent().copyWith(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        onPressed: _openCreateDialog,
                        icon: const Icon(Icons.add, color: BrandColors.navy900),
                        label: const Text('Buat Pengumuman'),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(BrandColors.amber400),
        ),
      );
    }

    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: BrandColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: BrandTextStyles.body.copyWith(color: BrandColors.gray700),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: BrandButtons.primary(),
            onPressed: _fetchPengumuman,
            child: const Text('Coba Lagi'),
          ),
        ],
      );
    }

    if (_announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 64,
              color: BrandColors.gray300,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada pengumuman',
              style: BrandTextStyles.bodySecondary.copyWith(color: BrandColors.gray700),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _announcements
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _AnnouncementCard(
                  announcement: item,
                  onDelete: item.onDelete,
                  onEdit: item.onEdit,
                ),
              ))
          .toList(),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.announcement,
    required this.onDelete,
    required this.onEdit,
  });

  final _Announcement announcement;
  final void Function() onDelete;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BrandShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  announcement.title,
                  style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: BrandColors.gray500),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: BrandColors.error),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            announcement.message,
            style: BrandTextStyles.bodySecondary.copyWith(color: BrandColors.gray700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: BrandColors.gray500),
              const SizedBox(width: 6),
              Text(
                announcement.date,
                style: BrandTextStyles.caption.copyWith(color: BrandColors.gray700),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.groups, size: 16, color: BrandColors.gray500),
              const SizedBox(width: 6),
              Text(
                announcement.target,
                style: BrandTextStyles.caption.copyWith(color: BrandColors.gray700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Announcement {
  final String id;
  final String title;
  final String message;
  final String date;
  final String target;
  final String sender;
  final String category;
  final bool isPinned;
  final void Function() onDelete;
  final void Function() onEdit;

  const _Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.target,
    required this.sender,
    required this.category,
    required this.isPinned,
    required this.onDelete,
    required this.onEdit,
  });
}