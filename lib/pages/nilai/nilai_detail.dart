// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../utils/api_client.dart';
import '../../state/auth_controller.dart';
import '../../theme/brand.dart';
import '../../utils/feedback.dart';
import 'package:provider/provider.dart';

class NilaiDetailPage extends StatefulWidget {
  final String? studentId;
  final String studentName;
  final String kelas;

  const NilaiDetailPage({
    super.key,
    this.studentId,
    required this.studentName,
    required this.kelas,
  });

  @override
  State<NilaiDetailPage> createState() => _NilaiDetailPageState();
}

class _NilaiDetailPageState extends State<NilaiDetailPage> {
  List<_SubjectGrades> _subjects = [];
  bool _isLoading = false;
  String? _error;
  String _semester = 'Ganjil';
  String _tahunAjaran = '2024/2025';
  bool _hasChanges = false;
  String? _nis;
  String? _kelas;

  @override
  void initState() {
    super.initState();
    _fetchNilai();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasChanges);
        return false;
      },
      child: Scaffold(
        backgroundColor: BrandColors.gray100,
        appBar: AppBar(
          backgroundColor: BrandColors.navy900,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Navigator.pop(context, _hasChanges),
          ),
          title: const Text('Nilai', style: BrandTextStyles.appBarTitle),
        ),
        body: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: BrandColors.navy900,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manajemen Nilai',
                    style: BrandTextStyles.heading.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola nilai siswa untuk semua mata pelajaran',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: BrandButtons.accent(),
                      onPressed: _showAddSubjectDialog,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: BrandColors.navy900),
                          SizedBox(width: 8),
                          Text(
                            'Tambah Mata Pelajaran',
                            style: TextStyle(
                              color: BrandColors.navy900,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Back button and student info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, _hasChanges),
                    child: Row(
                      children: const [
                        Icon(Icons.chevron_left, color: BrandColors.gray900),
                        SizedBox(width: 4),
                        Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: BrandColors.gray900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Student Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: BrandShadows.card,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: BrandColors.sand200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.school_rounded,
                        size: 22,
                        color: BrandColors.navy900,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: BrandColors.navy900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _kelas ?? widget.kelas,
                            style: const TextStyle(
                              fontSize: 13,
                              color: BrandColors.gray700,
                            ),
                          ),
                          if ((_nis ?? '').isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'NIS: ${_nis!}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.gray500,
                              ),
                            ),
                          ] else if (widget.studentId != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${widget.studentId}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.gray500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        _MetaPill(label: 'Semester', value: 'Ganjil'),
                        SizedBox(height: 6),
                        _MetaPill(label: 'Tahun', value: '2024/2025'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterPill(
                      label: 'Semester',
                      value: _semester,
                      onTap: () => _chooseSemester(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FilterPill(
                      label: 'Tahun Ajaran',
                      value: _tahunAjaran,
                      onTap: () => _chooseTahun(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Subjects List
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddSubjectDialog() async {
    if (widget.studentId == null) {
      showFeedback(context, 'ID siswa tidak tersedia');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final mapelCtrl = TextEditingController();
    final tugasCtrl = TextEditingController();
    final utsCtrl = TextEditingController();
    final uasCtrl = TextEditingController();
    String selectedSemester = _semester;
    String selectedTahun = _tahunAjaran;
    String selectedMapel = 'Matematika';
    bool isCustomMapel = false;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(builder: (context, setStateDialog) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tambah Nilai',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.studentName} • ${widget.kelas}',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedMapel,
                      decoration: const InputDecoration(
                        labelText: 'Mata Pelajaran',
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Matematika', child: Text('Matematika')),
                        DropdownMenuItem(value: 'Bahasa Indonesia', child: Text('Bahasa Indonesia')),
                        DropdownMenuItem(value: 'Bahasa Inggris', child: Text('Bahasa Inggris')),
                        DropdownMenuItem(value: 'IPA', child: Text('IPA')),
                        DropdownMenuItem(value: 'IPS', child: Text('IPS')),
                        DropdownMenuItem(value: 'PPKn', child: Text('PPKn')),
                        DropdownMenuItem(value: 'Seni Budaya', child: Text('Seni Budaya')),
                        DropdownMenuItem(value: 'PJOK', child: Text('PJOK')),
                        DropdownMenuItem(value: 'Informatika', child: Text('Informatika')),
                        DropdownMenuItem(value: 'Prakarya', child: Text('Prakarya')),
                        DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya (ketik manual)')),
                      ],
                      onChanged: (v) {
                        setStateDialog(() {
                          selectedMapel = v ?? 'Matematika';
                          isCustomMapel = selectedMapel == 'Lainnya';
                          if (!isCustomMapel) {
                            mapelCtrl.text = selectedMapel;
                          } else {
                            mapelCtrl.clear();
                          }
                        });
                      },
                    ),
                    if (isCustomMapel) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: mapelCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Mata Pelajaran (Lainnya)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tugasCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nilai Tugas (0-100)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Wajib diisi';
                              final n = int.tryParse(v);
                              if (n == null || n < 0 || n > 100) return '0-100';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: utsCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nilai UTS (0-100)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Wajib diisi';
                              final n = int.tryParse(v);
                              if (n == null || n < 0 || n > 100) return '0-100';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: uasCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nilai UAS (0-100)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Wajib diisi';
                        final n = int.tryParse(v);
                        if (n == null || n < 0 || n > 100) return '0-100';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSemester,
                            decoration: const InputDecoration(
                              labelText: 'Semester',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Ganjil', child: Text('Ganjil')),
                              DropdownMenuItem(value: 'Genap', child: Text('Genap')),
                            ],
                            onChanged: (v) => setStateDialog(() => selectedSemester = v ?? 'Ganjil'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedTahun,
                            decoration: const InputDecoration(
                              labelText: 'Tahun Ajaran',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: '2024/2025', child: Text('2024/2025')),
                              DropdownMenuItem(value: '2023/2024', child: Text('2023/2024')),
                              DropdownMenuItem(value: '2022/2023', child: Text('2022/2023')),
                            ],
                            onChanged: (v) => setStateDialog(() => selectedTahun = v ?? '2024/2025'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: BrandColors.navy900,
                              side: const BorderSide(color: BrandColors.navy900),
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Batal',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A1F44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              void show(String msg, {Color? color}) => showFeedback(context, msg);
                              if (formKey.currentState!.validate()) {
                                try {
                                  final response = await ApiClient(context.read<AuthController>()).post(
                                    '/api/nilai',
                                    body: {
                                      'siswa_id': widget.studentId,
                                      'mata_pelajaran': (isCustomMapel ? mapelCtrl.text : selectedMapel).trim(),
                                      'tugas': int.tryParse(tugasCtrl.text) ?? 0,
                                      'uts': int.tryParse(utsCtrl.text) ?? 0,
                                      'uas': int.tryParse(uasCtrl.text) ?? 0,
                                      'semester': selectedSemester,
                                      'tahun_ajaran': selectedTahun,
                                    },
                                  );

                                  if (response.statusCode == 201) {
                                    navigator.pop();
                                    setState(() {
                                      _semester = selectedSemester;
                                      _tahunAjaran = selectedTahun;
                                      _hasChanges = true;
                                    });
                                    await _fetchNilai();
                                    show('Nilai berhasil ditambahkan', color: Colors.green);
                                  } else {
                                    final body = jsonDecode(response.body);
                                    throw Exception(body['message'] ?? 'Gagal menambah nilai');
                                  }
                                } catch (e) {
                                  show('Error: ${e.toString()}', color: Colors.red);
                                }
                              }
                            },
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
          }),
        );
      },
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchNilai,
              child: const Text('Muat ulang'),
            ),
          ],
        ),
      );
    }
    if (_subjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Belum ada nilai untuk filter ini'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showAddSubjectDialog,
              child: const Text('Tambah Nilai'),
            ),
          ],
        ),
      );
    }
    final rata2 = _subjects.map((e) => e.average).fold<double>(0, (a, b) => a + b) / _subjects.length;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _SummaryCard(
          semester: _semester,
          tahun: _tahunAjaran,
          rataRata: rata2,
          count: _subjects.length,
        ),
        const SizedBox(height: 12),
        ..._subjects.map((s) => _SubjectCard(subject: s)),
      ],
    );
  }

  Future<void> _fetchNilai() async {
    if (widget.studentId == null) {
      setState(() {
        _subjects = [];
        _error = 'ID siswa tidak tersedia';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await ApiClient(context.read<AuthController>()).get(
        '/api/nilai?siswa_id=${widget.studentId}&semester=$_semester&tahun_ajaran=$_tahunAjaran',
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final rawList = (data['data'] as List);
          final list = rawList.map((e) => _SubjectGrades.fromApi(e)).toList();
          setState(() {
            _subjects = list;
            _isLoading = false;
            if (rawList.isNotEmpty) {
              final first = rawList.first as Map<String, dynamic>;
              _nis = (first['nis'] ?? '').toString();
              _kelas = (first['kelas'] ?? widget.kelas).toString();
            }
          });
        } else {
          throw Exception(data['message'] ?? 'Gagal memuat nilai');
        }
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Server error ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _chooseSemester() async {
    final options = ['Ganjil', 'Genap'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (o) => ListTile(
                    title: Text(o),
                    trailing: o == _semester ? const Icon(Icons.check, color: Colors.blue) : null,
                    onTap: () => Navigator.of(ctx).pop(o),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    if (selected != null && selected != _semester) {
      setState(() => _semester = selected);
      await _fetchNilai();
    }
  }

  Future<void> _chooseTahun() async {
    final options = ['2024/2025', '2023/2024', '2022/2023'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (o) => ListTile(
                    title: Text(o),
                    trailing: o == _tahunAjaran ? const Icon(Icons.check, color: Colors.blue) : null,
                    onTap: () => Navigator.of(ctx).pop(o),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    if (selected != null && selected != _tahunAjaran) {
      setState(() => _tahunAjaran = selected);
      await _fetchNilai();
    }
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0A1F44),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0A1F44),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject});

  final _SubjectGrades subject;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GradeBox(
                  label: 'Tugas',
                  score: subject.tugas,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GradeBox(
                  label: 'UTS',
                  score: subject.uts,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GradeBox(
                  label: 'UAS',
                  score: subject.uas,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rata-rata:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subject.average.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
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

class _GradeBox extends StatelessWidget {
  const _GradeBox({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          alignment: Alignment.center,
          child: Text(
            '$score',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectGrades {
  final String name;
  final int tugas;
  final int uts;
  final int uas;
  final double average;

  const _SubjectGrades({
    required this.name,
    required this.tugas,
    required this.uts,
    required this.uas,
    required this.average,
  });

  factory _SubjectGrades.fromApi(Map<String, dynamic> json) {
    final tugas = json['tugas'] as num? ?? 0;
    final uts = json['uts'] as num? ?? 0;
    final uas = json['uas'] as num? ?? 0;
    // hitung rata-rata lokal jika backend tidak kirim "total"
    final total = json['total'] as num? ?? (tugas * 0.3 + uts * 0.3 + uas * 0.4);
    return _SubjectGrades(
      name: json['mata_pelajaran'] as String? ?? '-',
      tugas: tugas.toInt(),
      uts: uts.toInt(),
      uas: uas.toInt(),
      average: total.toDouble(),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
            const Icon(Icons.expand_more, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.semester,
    required this.tahun,
    required this.rataRata,
    required this.count,
  });

  final String semester;
  final String tahun;
  final double rataRata;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F44),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ringkasan Nilai', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  '$semester • $tahun',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count mata pelajaran',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDB45B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Rata-rata',
                  style: TextStyle(color: Color(0xFF0A1F44), fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  rataRata.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Color(0xFF0A1F44),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
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