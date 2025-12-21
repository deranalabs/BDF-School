import 'package:flutter/material.dart';

class TeacherTasksScreen extends StatefulWidget {
  const TeacherTasksScreen({super.key});

  @override
  State<TeacherTasksScreen> createState() => _TeacherTasksScreenState();
}

enum _TasksFilter { all, pending, completed }

class _TeacherTasksScreenState extends State<TeacherTasksScreen> {
  _TasksFilter _filter = _TasksFilter.all;

  List<_TeacherTaskItem> get _items => const [
        _TeacherTaskItem(
          subject: 'Matematika',
          subjectBg: Color(0xFFE7F0FF),
          subjectFg: Color(0xFF2F80FF),
          title: 'Tugas Bab 5 - Integral',
          className: 'XII IPA 1',
          dueText: 'Besok, 14:00',
          pending: 5,
          submitted: 27,
          status: _TaskStatus.pending,
        ),
        _TeacherTaskItem(
          subject: 'Statistika',
          subjectBg: Color(0xFFF2E7FF),
          subjectFg: Color(0xFF7C3AED),
          title: 'Proyek Data Siswa',
          className: 'XI IPA 2',
          dueText: '3 hari lagi',
          pending: 2,
          submitted: 28,
          status: _TaskStatus.pending,
        ),
        _TeacherTaskItem(
          subject: 'Matematika Bisnis',
          subjectBg: Color(0xFFE9FBEF),
          subjectFg: Color(0xFF16A34A),
          title: 'Laporan Keuangan',
          className: 'XII IPS 1',
          dueText: 'Selesai',
          pending: 0,
          submitted: 30,
          status: _TaskStatus.completed,
        ),
      ];

  List<_TeacherTaskItem> get _filteredItems {
    switch (_filter) {
      case _TasksFilter.pending:
        return _items.where((e) => e.status == _TaskStatus.pending).toList();
      case _TasksFilter.completed:
        return _items.where((e) => e.status == _TaskStatus.completed).toList();
      case _TasksFilter.all:
        return _items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 18, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    splashRadius: 22,
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monitoring Tugas',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pantau progres pengumpulan tugas siswa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: _SegmentedTabs(
                value: _filter,
                onChanged: (v) => setState(() => _filter = v),
              ),
            ),
            Container(height: 1, color: const Color(0xFFF1F5F9)),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                itemCount: _filteredItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return _TaskCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.value, required this.onChanged});

  final _TasksFilter value;
  final ValueChanged<_TasksFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegButton(
              selected: value == _TasksFilter.all,
              text: 'Semua',
              onTap: () => onChanged(_TasksFilter.all),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SegButton(
              selected: value == _TasksFilter.pending,
              text: 'Menunggu',
              onTap: () => onChanged(_TasksFilter.pending),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SegButton(
              selected: value == _TasksFilter.completed,
              text: 'Selesai',
              onTap: () => onChanged(_TasksFilter.completed),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  const _SegButton({
    required this.selected,
    required this.text,
    required this.onTap,
  });

  final bool selected;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF2F80FF) : const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF6B7280),
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _TaskStatus { pending, completed }

class _TeacherTaskItem {
  final String subject;
  final Color subjectBg;
  final Color subjectFg;
  final String title;
  final String className;
  final String dueText;
  final int pending;
  final int submitted;
  final _TaskStatus status;

  const _TeacherTaskItem({
    required this.subject,
    required this.subjectBg,
    required this.subjectFg,
    required this.title,
    required this.className,
    required this.dueText,
    required this.pending,
    required this.submitted,
    required this.status,
  });
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.item});

  final _TeacherTaskItem item;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        item.status == _TaskStatus.completed ? const Color(0xFF16A34A) : const Color(0xFFEF4444);
    final statusIcon =
        item.status == _TaskStatus.completed ? Icons.check_circle : Icons.access_time_rounded;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.subjectBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${item.subject} • ${item.className}',
              style: TextStyle(
                color: item.subjectFg,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(statusIcon, size: 18, color: statusColor),
              const SizedBox(width: 8),
              Text(
                item.dueText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Belum dinilai',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.pending} siswa',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: const Color(0xFFE5E7EB)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sudah submit',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.submitted} siswa',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
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
    );
  }
}
