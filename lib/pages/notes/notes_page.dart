import 'package:flutter/material.dart';
import '../../theme/brand.dart';
import '../../utils/local_notes_db.dart';

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
                    if (title.isEmpty || content.isEmpty) return;
                    if (isEdit) {
                      final noteId = note['id'] as int;
                      await _db.updateNote(id: noteId, title: title, content: content);
                    } else {
                      await _db.insertNote(title: title, content: content);
                    }
                    if (mounted) Navigator.pop(ctx);
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
    await _loadNotes();
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
          'Quick Notes (sqflite)',
          style: BrandTextStyles.appBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        backgroundColor: BrandColors.navy900,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: BrandColors.navy900,
              onRefresh: _loadNotes,
              child: _notes.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 120),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(BrandRadius.lg),
                            boxShadow: BrandShadows.card,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.note_alt_outlined, size: 32, color: BrandColors.gray700),
                              SizedBox(height: 12),
                              Text(
                                'Belum ada catatan lokal',
                                style: BrandTextStyles.subheading,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Tambahkan catatan singkat Anda melalui tombol plus di kanan bawah.',
                                textAlign: TextAlign.center,
                                style: BrandTextStyles.bodySecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(BrandRadius.lg),
                            boxShadow: BrandShadows.card,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note['title'] ?? '',
                                          style: BrandTextStyles.subheading,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          note['content'] ?? '',
                                          style: BrandTextStyles.bodySecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.edit, size: 18, color: BrandColors.navy900),
                                        onPressed: () => _showNoteDialog(note: note),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                                        onPressed: () => _deleteNote(note['id'] as int),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
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
