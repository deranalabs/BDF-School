// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../utils/api_client.dart';
import '../../state/auth_controller.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../jadwal/jadwal_page.dart';
import '../presensi/presensi_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';
import '../../theme/brand.dart';

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  final _searchController = TextEditingController();
  List<TaskItem> _tasks = [];
  bool _isLoading = false;
  String? _error;
  late ApiClient _api;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<AuthController>());
    _fetchTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.get('/api/tugas');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final tasks = (data['data'] as List)
              .map((task) => TaskItem(
                    id: task['id'].toString(),
                    title: task['judul'],
                    description: task['deskripsi'] ?? '',
                    subject: task['guru'] ?? '',
                    kelas: task['kelas'] ?? '',
                    deadline: task['deadline'] ?? '',
                    status: TaskStatus.aktif,
                    teacher: task['guru'] ?? '',
                  ))
              .toList();
          
          if (!mounted) return;
          setState(() {
            _tasks = tasks;
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to load tasks');
        }
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to load tasks');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat tugas: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
    }
    
    void logout() async {
      try {
        final authController = Provider.of<AuthController>(context, listen: false);
        await authController.logout();
        if (!mounted) return;
        _scaffoldKey.currentState?.closeDrawer();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
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
        title: const Text('Tugas', style: BrandTextStyles.appBarTitle),
      ),
      drawer: Sidebar(
        selectedIndex: 4,
        onTapDashboard: () => goTo(const DashboardScreen()),
        onTapTugas: () => Navigator.of(context).pop(),
        onTapJadwal: () => goTo(const JadwalPage()),
        onTapPresensi: () => goTo(const PresensiPage()),
        onTapNilai: () => goTo(const NilaiPage()),
        onTapPengumuman: () => goTo(const PengumumanPage()),
        onTapSiswa: () => goTo(const DaftarSiswaPage()),
        onTapSettings: () => goTo(const PengaturanPage()),
        onLogout: logout,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTasks,
        color: BrandColors.navy900,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
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
                      'Daftar Tugas',
                      style: BrandTextStyles.heading.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kelola semua tugas siswa',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: BrandButtons.accent().copyWith(
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                        onPressed: _showAddTaskDialog,
                        icon: const Icon(Icons.add, color: BrandColors.navy900, size: 20),
                        label: const Text(
                          'Tambah Tugas',
                          style: TextStyle(
                            color: BrandColors.navy900,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Area wrapped and list unified in one panel
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // Search and Add Button Container
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: BrandShadows.card,
                          ),
                          child: Column(
                            children: [
                              // Search Field
                              TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Cari tugas...',
                                  hintStyle: BrandTextStyles.bodySecondary.copyWith(
                                    color: BrandColors.gray500,
                                  ),
                                  prefixIcon: const Icon(Icons.search, color: BrandColors.gray500),
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
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                onChanged: (value) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Error Banner
                        if (_error != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: BrandColors.error.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BrandColors.error.withOpacity(0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: BrandColors.error, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gagal memuat data',
                                        style: BrandTextStyles.body.copyWith(
                                          color: BrandColors.error,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _error!,
                                        style: BrandTextStyles.caption.copyWith(color: BrandColors.error),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh, size: 20),
                                  color: BrandColors.error,
                                  onPressed: _fetchTasks,
                                  tooltip: 'Coba lagi',
                                ),
                              ],
                            ),
                          ),

                        // List / states unified
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A1F44)),
                              ),
                            ),
                          )
                        else if (_tasks.isEmpty && _error == null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.assignment_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Belum ada tugas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tambahkan tugas pertama Anda',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            itemCount: () {
                              final keyword = _searchController.text.toLowerCase().trim();
                              return keyword.isEmpty
                                  ? _tasks.length
                                  : _tasks.where((t) {
                                      return t.title.toLowerCase().contains(keyword) ||
                                          t.description.toLowerCase().contains(keyword) ||
                                          t.kelas.toLowerCase().contains(keyword) ||
                                          t.teacher.toLowerCase().contains(keyword);
                                    }).length;
                            }(),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final keyword = _searchController.text.toLowerCase().trim();
                              final filteredTasks = keyword.isEmpty
                                  ? _tasks
                                  : _tasks.where((t) {
                                      return t.title.toLowerCase().contains(keyword) ||
                                          t.description.toLowerCase().contains(keyword) ||
                                          t.kelas.toLowerCase().contains(keyword) ||
                                          t.teacher.toLowerCase().contains(keyword);
                                    }).toList();
                              final task = filteredTasks[index];
                              return TaskCard(
                                task: task,
                                onEdit: () => _showEditTaskDialog(task),
                                onDelete: () => _showDeleteTaskDialog(task),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final kelasController = TextEditingController();
    final guruController = TextEditingController();
    final deadlineController = TextEditingController();

    final baseDecoration = InputDecoration(
      filled: true,
      fillColor: BrandColors.gray100,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        title: Text(
          'Tambah Tugas Baru',
          style: BrandTextStyles.subheading.copyWith(
            color: BrandColors.navy900,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: baseDecoration.copyWith(labelText: 'Judul Tugas'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: baseDecoration.copyWith(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kelasController,
                decoration: baseDecoration.copyWith(labelText: 'Kelas'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: guruController,
                decoration: baseDecoration.copyWith(labelText: 'Guru'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deadlineController,
                decoration: baseDecoration.copyWith(
                  labelText: 'Deadline (YYYY-MM-DD)',
                  hintText: '2025-01-31',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: BrandColors.gray700)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty ||
                  kelasController.text.isEmpty ||
                  guruController.text.isEmpty ||
                  deadlineController.text.isEmpty) {
                showFeedback(context, 'Judul, Kelas, Guru, dan Deadline wajib diisi');
                return;
              }
              
              try {
                final response = await _api.post(
                  '/api/tugas',
                  body: {
                    'judul': titleController.text,
                    'deskripsi': descController.text,
                    'kelas': kelasController.text,
                    'guru': guruController.text,
                    'deadline': deadlineController.text,
                  },
                );

                if (response.statusCode == 201) {
                  Navigator.pop(context);
                  _fetchTasks();
                  showFeedback(context, 'Tugas berhasil ditambahkan');
                } else {
                  final body = jsonDecode(response.body);
                  showFeedback(context, body['message'] ?? 'Gagal menambahkan tugas');
                }
              } catch (e) {
                showFeedback(context, 'Error: $e');
              }
            },
            style: BrandButtons.primary(),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(TaskItem task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    final kelasController = TextEditingController(text: task.className);
    final guruController = TextEditingController(text: task.teacher);
    final deadlineController = TextEditingController(text: task.deadline);

    final baseDecoration = InputDecoration(
      filled: true,
      fillColor: BrandColors.gray100,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        title: Text(
          'Edit Tugas',
          style: BrandTextStyles.subheading.copyWith(
            color: BrandColors.navy900,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: baseDecoration.copyWith(labelText: 'Judul Tugas'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: baseDecoration.copyWith(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kelasController,
                decoration: baseDecoration.copyWith(labelText: 'Kelas'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: guruController,
                decoration: baseDecoration.copyWith(labelText: 'Guru'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deadlineController,
                decoration: baseDecoration.copyWith(
                  labelText: 'Deadline (YYYY-MM-DD)',
                  hintText: '2025-01-31',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: BrandColors.gray700)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty ||
                  kelasController.text.isEmpty ||
                  guruController.text.isEmpty ||
                  deadlineController.text.isEmpty) {
                showFeedback(context, 'Judul, Kelas, Guru, dan Deadline wajib diisi');
                return;
              }

              try {
                final response = await _api.put(
                  '/api/tugas/${task.id}',
                  body: {
                    'judul': titleController.text,
                    'deskripsi': descController.text,
                    'kelas': kelasController.text,
                    'guru': guruController.text,
                    'deadline': deadlineController.text,
                  },
                );

                if (response.statusCode == 200) {
                  Navigator.pop(context);
                  _fetchTasks();
                  showFeedback(context, 'Tugas berhasil diperbarui');
                } else {
                  final body = jsonDecode(response.body);
                  showFeedback(context, body['message'] ?? 'Gagal memperbarui tugas');
                }
              } catch (e) {
                showFeedback(context, 'Error: $e');
              }
            },
            style: BrandButtons.primary(),
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTaskDialog(TaskItem task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Apakah Anda yakin ingin menghapus tugas "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: BrandColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              try {
                final response = await _api.delete('/api/tugas/${task.id}');

                if (response.statusCode == 200) {
                  Navigator.pop(context);
                  _fetchTasks();
                  showFeedback(context, 'Tugas berhasil dihapus');
                } else {
                  final body = jsonDecode(response.body);
                  showFeedback(context, body['message'] ?? 'Gagal menghapus tugas');
                }
              } catch (e) {
                showFeedback(context, 'Error: $e');
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskItem task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BrandShadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: BrandTextStyles.subheading.copyWith(color: BrandColors.navy900),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: task.status == TaskStatus.aktif
                        ? BrandColors.sand200
                        : BrandColors.gray300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.status == TaskStatus.aktif ? 'Aktif' : 'Selesai',
                    style: TextStyle(
                      fontSize: 12,
                      color: task.status == TaskStatus.aktif
                          ? BrandColors.navy900
                          : BrandColors.gray700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: BrandColors.gray500, size: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 12),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description,
                style: BrandTextStyles.bodySecondary.copyWith(height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildInfoChip(Icons.person_outline, task.subject),
                _buildInfoChip(Icons.class_outlined, task.kelas),
                _buildInfoChip(Icons.calendar_today_outlined, task.deadline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: BrandColors.gray500),
        const SizedBox(width: 4),
        Text(
          label,
          style: BrandTextStyles.caption.copyWith(
            color: BrandColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

enum TaskStatus { aktif, selesai }

class TaskItem {
  const TaskItem({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.kelas,
    required this.deadline,
    required this.status,
    this.attachment,
    required this.teacher,
  });

  final String? id;
  final String title;
  final String description;
  final String subject;
  final String kelas;
  final String deadline;
  final TaskStatus status;
  final String? attachment;
  final String teacher;

  String get className => kelas;
}