import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

enum _TasksFilter { all, active, done }

class _TasksScreenState extends State<TasksScreen> {
  _TasksFilter _filter = _TasksFilter.all;

  final List<_TaskItem> _items = const [
    _TaskItem(
      subject: 'Matematika',
      subjectBg: Color(0xFFE7F0FF),
      subjectFg: Color(0xFF2F80FF),
      title: 'Tugas Matematika Bab 5',
      teacher: 'Pengajar: Pak Budi Santoso',
      statusText: 'Besok, 14:00',
      statusType: _TaskStatusType.urgent,
      done: false,
    ),
    _TaskItem(
      subject: 'Bahasa Indonesia',
      subjectBg: Color(0xFFE9FBEF),
      subjectFg: Color(0xFF16A34A),
      title: 'Essay Bahasa Indonesia',
      teacher: 'Pengajar: Bu Siti Rahayu',
      statusText: '3 hari lagi',
      statusType: _TaskStatusType.soon,
      done: false,
    ),
    _TaskItem(
      subject: 'Fisika',
      subjectBg: Color(0xFFF2E7FF),
      subjectFg: Color(0xFF7C3AED),
      title: 'Laporan Praktikum Fisika',
      teacher: 'Pengajar: Pak Ahmad Hidayat',
      statusText: 'Selesai',
      statusType: _TaskStatusType.done,
      done: true,
      strikeTitle: true,
    ),
    _TaskItem(
      subject: 'Sejarah',
      subjectBg: Color(0xFFFFF3D6),
      subjectFg: Color(0xFFB45309),
      title: 'Presentasi Kelompok Sejarah',
      teacher: 'Pengajar: Bu Dewi Kartika',
      statusText: '4 hari lagi',
      statusType: _TaskStatusType.soon,
      done: false,
    ),
    _TaskItem(
      subject: 'Bahasa Inggris',
      subjectBg: Color(0xFFFFE7E7),
      subjectFg: Color(0xFFDC2626),
      title: 'Praktek Bahasa Inggris',
      teacher: 'Pengajar: Miss Sarah',
      statusText: '2 hari lagi',
      statusType: _TaskStatusType.soon,
      done: false,
    ),
    _TaskItem(
      subject: 'Kimia',
      subjectBg: Color(0xFFFFE7F3),
      subjectFg: Color(0xFFDB2777),
      title: 'Tugas Kimia - Tabel Periodik',
      teacher: 'Pengajar: Pak Hendra',
      statusText: 'Hari ini, 23:59',
      statusType: _TaskStatusType.urgent,
      done: false,
    ),
  ];

  List<_TaskItem> get _filteredItems {
    switch (_filter) {
      case _TasksFilter.active:
        return _items.where((e) => !e.done).toList(growable: false);
      case _TasksFilter.done:
        return _items.where((e) => e.done).toList(growable: false);
      case _TasksFilter.all:
        return _items;
    }
  }

  int get _doneCount => _items.where((e) => e.done).length;

  int get _activeCount => _items.where((e) => !e.done).length;

  @override
  Widget build(BuildContext context) {
    final allCount = _items.length;
    final activeCount = _activeCount;
    final doneCount = _doneCount;

    final unfinishedText = _filter == _TasksFilter.done
        ? '0 tugas belum selesai'
        : '${activeCount} tugas belum selesai';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 18, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    splashRadius: 22,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tugas',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          unfinishedText,
                          style: const TextStyle(
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
                allCount: allCount,
                activeCount: activeCount,
                doneCount: doneCount,
                onChanged: (v) => setState(() => _filter = v),
              ),
            ),
            Container(height: 1, color: const Color(0xFFF1F5F9)),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
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
  final _TasksFilter value;
  final int allCount;
  final int activeCount;
  final int doneCount;
  final ValueChanged<_TasksFilter> onChanged;

  const _SegmentedTabs({
    required this.value,
    required this.allCount,
    required this.activeCount,
    required this.doneCount,
    required this.onChanged,
  });

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
              text: 'Semua ($allCount)',
              onTap: () => onChanged(_TasksFilter.all),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SegButton(
              selected: value == _TasksFilter.active,
              text: 'Aktif ($activeCount)',
              onTap: () => onChanged(_TasksFilter.active),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SegButton(
              selected: value == _TasksFilter.done,
              text: 'Selesai ($doneCount)',
              onTap: () => onChanged(_TasksFilter.done),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  final bool selected;
  final String text;
  final VoidCallback onTap;

  const _SegButton({
    required this.selected,
    required this.text,
    required this.onTap,
  });

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

enum _TaskStatusType { urgent, soon, done }

class _TaskItem {
  final String subject;
  final Color subjectBg;
  final Color subjectFg;
  final String title;
  final String teacher;
  final String statusText;
  final _TaskStatusType statusType;
  final bool done;
  final bool strikeTitle;

  const _TaskItem({
    required this.subject,
    required this.subjectBg,
    required this.subjectFg,
    required this.title,
    required this.teacher,
    required this.statusText,
    required this.statusType,
    required this.done,
    this.strikeTitle = false,
  });
}

class _TaskCard extends StatelessWidget {
  final _TaskItem item;

  const _TaskCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (item.statusType) {
      _TaskStatusType.urgent => const Color(0xFFEF4444),
      _TaskStatusType.soon => const Color(0xFF6B7280),
      _TaskStatusType.done => const Color(0xFF16A34A),
    };

    final statusIcon = switch (item.statusType) {
      _TaskStatusType.urgent => Icons.access_time_rounded,
      _TaskStatusType.soon => Icons.access_time_rounded,
      _TaskStatusType.done => Icons.check_circle_rounded,
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckDot(done: item.done),
          const SizedBox(width: 12),
          Expanded(
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
                    item.subject,
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: item.strikeTitle
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF111827),
                    decoration:
                        item.strikeTitle ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(statusIcon, size: 18, color: statusColor),
                    const SizedBox(width: 8),
                    Text(
                      item.statusText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: statusColor,
                      ),
                    ),
                    if (item.statusType == _TaskStatusType.urgent) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.error_outline,
                          size: 16, color: Color(0xFFEF4444)),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.teacher,
                  style: const TextStyle(
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
    );
  }
}

class _CheckDot extends StatelessWidget {
  final bool done;

  const _CheckDot({required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: done ? const Color(0xFF22C55E) : const Color(0xFFD1D5DB),
          width: 2,
        ),
        color: done ? const Color(0xFF22C55E) : Colors.transparent,
      ),
      alignment: Alignment.center,
      child: done
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}
