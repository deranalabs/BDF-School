import 'package:flutter/material.dart';
import '../../theme/brand.dart';
import '../../utils/local_notes_db.dart';
import '../../utils/feedback.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _db = LocalNotesDb.instance;
  bool _loading = true;
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _loading = true);
    final data = await _db.fetchNotes();
    if (!mounted) return;
    setState(() {
      _notes = data;
      _loading = false;
    });
  }

  Future<void> _showNoteDialog({Map<String, dynamic>? note}) async {
    final titleController = TextEditingController(text: note?['title'] ?? '');
    final contentController = TextEditingController(text: note?['content'] ?? '');
    final isEdit = note != null;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BrandRadius.lg)),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        backgroundColor: const Color(0xFFF1F3F7),
        title: Text(
          isEdit ? 'Edit Catatan' : 'Tambah Catatan',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: BrandColors.navy900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NotesInput(
              controller: titleController,
              hint: 'Judul',
            ),
            const SizedBox(height: 12),
            _NotesInput(
              controller: contentController,
              hint: 'Isi',
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BrandColors.navy900,
                    side: const BorderSide(color: BrandColors.navy900),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(height: 12, width: 12),
              Expanded(
                child: ElevatedButton(
                  style: BrandButtons.primary(),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();
                    if (title.isEmpty || content.isEmpty) {
                      showFeedback(ctx, 'Judul dan isi harus diisi');
                      return;
                    }
                    if (isEdit) {
                      final noteId = note['id'] as int;
                      await _db.updateNote(id: noteId, title: title, content: content);
                      if (!mounted) return;
                      showFeedback(context, 'Catatan diperbarui');
                    } else {
                      await _db.insertNote(title: title, content: content);
                      if (!mounted) return;
                      showFeedback(context, 'Catatan ditambahkan');
                    }
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    await _loadNotes();
                  },
                  child: Text(isEdit ? 'Simpan' : 'Tambah'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(int id) async {
    await _db.deleteNote(id);
    if (mounted) showFeedback(context, 'Catatan dihapus');
    await _loadNotes();
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: BrandColors.navy900,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Notes',
              style: BrandTextStyles.heading.copyWith(color: Colors.white, fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Simpan catatan lokal yang hanya tersimpan di perangkat Anda.',
              style: BrandTextStyles.body.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showNoteDialog,
                style: BrandButtons.accent().copyWith(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                ),
                icon: const Icon(Icons.add, color: BrandColors.navy900),
                label: const Text(
                  'Tambah Catatan',
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
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BrandShadows.card,
      ),
      child: Column(
        children: const [
          Icon(Icons.note_alt_outlined, size: 40, color: BrandColors.gray700),
          SizedBox(height: 12),
          Text(
            'Belum ada catatan lokal',
            style: BrandTextStyles.subheading,
          ),
          SizedBox(height: 6),
          Text(
            'Catatan yang Anda buat tidak tersimpan di server. Gunakan tombol di atas untuk menambah catatan baru.',
            textAlign: TextAlign.center,
            style: BrandTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(BrandColors.navy900),
          ),
        ),
      );
    }

    if (_notes.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        children: _notes
            .map((note) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: BrandShadows.card,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note['title'] ?? '',
                              style: BrandTextStyles.subheading.copyWith(
                                color: BrandColors.navy900,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              note['content'] ?? '',
                              style: BrandTextStyles.bodySecondary.copyWith(
                                color: BrandColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18, color: BrandColors.navy900),
                            onPressed: () => _showNoteDialog(note: note),
                            tooltip: 'Edit catatan',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18, color: BrandColors.error),
                            onPressed: () => _deleteNote(note['id'] as int),
                            tooltip: 'Hapus catatan',
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.gray100,
      appBar: AppBar(
        backgroundColor: BrandColors.navy900,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Catatan',
          style: BrandTextStyles.appBarTitle,
        ),
      ),
      body: RefreshIndicator(
        color: BrandColors.navy900,
        onRefresh: _loadNotes,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeroSection()),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: _buildNotesSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesInput extends StatelessWidget {
  const _NotesInput({
    required this.controller,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: BrandColors.navy900,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: BrandColors.gray500,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.navy900, width: 1.2),
        ),
      ),
    );
  }
}
