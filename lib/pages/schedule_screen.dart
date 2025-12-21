import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const days = <_DaySchedule>[
      _DaySchedule(
        day: 'Senin',
        countText: '5 jadwal',
        items: [
          _ScheduleItem.lesson(
            color: Color(0xFF2F80FF),
            subject: 'Matematika',
            teacher: 'Pak Budi Santoso',
            time: '07:00 - 08:30',
            room: 'Ruang 201',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF16A34A),
            subject: 'Bahasa Indonesia',
            teacher: 'Bu Siti Rahayu',
            time: '08:30 - 10:00',
            room: 'Ruang 201',
          ),
          _ScheduleItem.breakTime(
            time: '10:00 - 10:30',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF7C3AED),
            subject: 'Fisika',
            teacher: 'Pak Ahmad Hidayat',
            time: '10:30 - 12:00',
            room: 'Lab Fisika',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFFDB2777),
            subject: 'Kimia',
            teacher: 'Pak Hendra',
            time: '12:30 - 14:00',
            room: 'Lab Kimia',
          ),
        ],
      ),
      _DaySchedule(
        day: 'Selasa',
        countText: '5 jadwal',
        items: [
          _ScheduleItem.lesson(
            color: Color(0xFFEF4444),
            subject: 'Bahasa Inggris',
            teacher: 'Miss Sarah',
            time: '07:00 - 08:30',
            room: 'Ruang 203',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFFB45309),
            subject: 'Sejarah',
            teacher: 'Bu Dewi Kartika',
            time: '08:30 - 10:00',
            room: 'Ruang 201',
          ),
          _ScheduleItem.breakTime(
            time: '10:00 - 10:30',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF2F80FF),
            subject: 'Matematika',
            teacher: 'Pak Budi Santoso',
            time: '10:30 - 12:00',
            room: 'Ruang 201',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF0EA5A4),
            subject: 'Biologi',
            teacher: 'Bu Linda',
            time: '12:30 - 14:00',
            room: 'Lab Biologi',
          ),
        ],
      ),
      _DaySchedule(
        day: 'Rabu',
        countText: '5 jadwal',
        items: [
          _ScheduleItem.lesson(
            color: Color(0xFFF97316),
            subject: 'Ekonomi',
            teacher: 'Pak Rudi',
            time: '07:00 - 08:30',
            room: 'Ruang 202',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF6366F1),
            subject: 'Sosiologi',
            teacher: 'Bu Ani',
            time: '08:30 - 10:00',
            room: 'Ruang 201',
          ),
          _ScheduleItem.breakTime(
            time: '10:00 - 10:30',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF84CC16),
            subject: 'Pendidikan Jasmani',
            teacher: 'Pak Agus',
            time: '10:30 - 12:00',
            room: 'Lapangan',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF7C3AED),
            subject: 'Fisika',
            teacher: 'Pak Ahmad Hidayat',
            time: '12:30 - 14:00',
            room: 'Ruang 201',
          ),
        ],
      ),
      _DaySchedule(
        day: 'Kamis',
        countText: '5 jadwal',
        items: [
          _ScheduleItem.lesson(
            color: Color(0xFFDB2777),
            subject: 'Kimia',
            teacher: 'Pak Hendra',
            time: '07:00 - 08:30',
            room: 'Lab Kimia',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF2F80FF),
            subject: 'Matematika',
            teacher: 'Pak Budi Santoso',
            time: '08:30 - 10:00',
            room: 'Ruang 201',
          ),
          _ScheduleItem.breakTime(
            time: '10:00 - 10:30',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF16A34A),
            subject: 'Bahasa Indonesia',
            teacher: 'Bu Siti Rahayu',
            time: '10:30 - 12:00',
            room: 'Ruang 201',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFFEF4444),
            subject: 'Bahasa Inggris',
            teacher: 'Miss Sarah',
            time: '12:30 - 14:00',
            room: 'Ruang 203',
          ),
        ],
      ),
      _DaySchedule(
        day: 'Jumat',
        countText: '4 jadwal',
        items: [
          _ScheduleItem.lesson(
            color: Color(0xFF06B6D4),
            subject: 'Pendidikan Agama',
            teacher: 'Ustadz Abdullah',
            time: '07:00 - 08:30',
            room: 'Ruang 204',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFFDB2777),
            subject: 'Seni Budaya',
            teacher: 'Bu Rina',
            time: '08:30 - 10:00',
            room: 'Ruang Seni',
          ),
          _ScheduleItem.breakTime(
            time: '10:00 - 10:30',
          ),
          _ScheduleItem.lesson(
            color: Color(0xFF0EA5A4),
            subject: 'Biologi',
            teacher: 'Bu Linda',
            time: '10:30 - 11:30',
            room: 'Lab Biologi',
          ),
        ],
      ),
    ];

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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jadwal Pelajaran',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelas XII IPA 1',
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final day = days[index];
                  return _DayCard(day: day);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DaySchedule {
  final String day;
  final String countText;
  final List<_ScheduleItem> items;

  const _DaySchedule({
    required this.day,
    required this.countText,
    required this.items,
  });
}

class _ScheduleItem {
  final bool isBreak;
  final Color color;
  final String subject;
  final String teacher;
  final String time;
  final String room;

  const _ScheduleItem._({
    required this.isBreak,
    required this.color,
    required this.subject,
    required this.teacher,
    required this.time,
    required this.room,
  });

  const _ScheduleItem.lesson({
    required Color color,
    required String subject,
    required String teacher,
    required String time,
    required String room,
  }) : this._(
          isBreak: false,
          color: color,
          subject: subject,
          teacher: teacher,
          time: time,
          room: room,
        );

  const _ScheduleItem.breakTime({required String time})
      : this._(
          isBreak: true,
          color: const Color(0xFF9CA3AF),
          subject: 'Istirahat',
          teacher: '',
          time: time,
          room: '',
        );
}

class _DayCard extends StatelessWidget {
  final _DaySchedule day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2F80FF), Color(0xFF1E5BFF)],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.day,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        day.countText,
                        style: const TextStyle(
                          color: Color(0xFFEAF2FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.menu_book_outlined, color: Colors.white),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                for (int i = 0; i < day.items.length; i++) ...[
                  _ScheduleRow(item: day.items[i]),
                  if (i != day.items.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final _ScheduleItem item;

  const _ScheduleRow({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.isBreak) {
      return Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Istirahat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.time,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 56,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.teacher,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    item.time,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  if (item.room.isNotEmpty) ...[
                    const Text(
                      '  •  ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                    Text(
                      item.room,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
