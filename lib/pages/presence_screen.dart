import 'package:flutter/material.dart';

class PresenceScreen extends StatefulWidget {
  const PresenceScreen({super.key});

  @override
  State<PresenceScreen> createState() => _PresenceScreenState();
}

enum _PresenceStatus { hadir, sakit, izin, alfa }

class _PresenceScreenState extends State<PresenceScreen> {
  DateTime _month = DateTime(2025, 12, 1);
  int _selectedDay = 17;

  final Map<int, _PresenceStatus> _decemberStatus = const {
    1: _PresenceStatus.hadir,
    2: _PresenceStatus.hadir,
    3: _PresenceStatus.hadir,
    4: _PresenceStatus.hadir,
    5: _PresenceStatus.hadir,
    8: _PresenceStatus.hadir,
    9: _PresenceStatus.hadir,
    10: _PresenceStatus.hadir,
    11: _PresenceStatus.hadir,
    12: _PresenceStatus.hadir,
    15: _PresenceStatus.hadir,
    16: _PresenceStatus.hadir,
    17: _PresenceStatus.hadir,
    18: _PresenceStatus.hadir,
    19: _PresenceStatus.hadir,
    22: _PresenceStatus.sakit,
    23: _PresenceStatus.sakit,
    24: _PresenceStatus.izin,
    25: _PresenceStatus.alfa,
  };

  Map<int, _PresenceStatus> get _statusByDay {
    if (_month.year == 2025 && _month.month == 12) return _decemberStatus;
    return const {};
  }

  void _changeMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta, 1);
      _selectedDay = 1;
    });
  }

  String _monthTitle(DateTime m) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${names[m.month - 1]} ${m.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
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
                            'Presensi',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                              height: 1.05,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Riwayat kehadiran siswa',
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
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _changeMonth(-1),
                      icon: const Icon(Icons.chevron_left_rounded),
                      splashRadius: 22,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _monthTitle(_month),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(Icons.chevron_right_rounded),
                      splashRadius: 22,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Row(
                  children: const [
                    Expanded(
                      child: _SummaryCard(
                        bg: Color(0xFF16A34A),
                        icon: Icons.check_circle_outline,
                        title: 'Hadir',
                        value: '15',
                        subtitle: '79% kehadiran',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: _SummaryCard(
                        bg: Color(0xFFEAB308),
                        icon: Icons.error_outline,
                        title: 'Sakit',
                        value: '2',
                        subtitle: 'hari sakit',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Row(
                  children: const [
                    Expanded(
                      child: _SummaryCard(
                        bg: Color(0xFF2F80FF),
                        icon: Icons.description_outlined,
                        title: 'Izin',
                        value: '1',
                        subtitle: 'hari izin',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: _SummaryCard(
                        bg: Color(0xFFEF4444),
                        icon: Icons.close_rounded,
                        title: 'Alfa',
                        value: '1',
                        subtitle: 'tanpa keterangan',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: _WhiteCard(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Keterangan Warna',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: const [
                            Expanded(
                              child: _LegendItem(
                                color: Color(0xFF16A34A),
                                text: 'Hadir',
                              ),
                            ),
                            Expanded(
                              child: _LegendItem(
                                color: Color(0xFFEAB308),
                                text: 'Sakit',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Expanded(
                              child: _LegendItem(
                                color: Color(0xFF2F80FF),
                                text: 'Izin',
                              ),
                            ),
                            Expanded(
                              child: _LegendItem(
                                color: Color(0xFFEF4444),
                                text: 'Alfa',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: _CalendarCard(
                  month: _month,
                  selectedDay: _selectedDay,
                  statusByDay: _statusByDay,
                  onSelectDay: (d) => setState(() => _selectedDay = d),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                child: _WhiteCard(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan Bulan Ini',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Total Hari Tercatat',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              Text(
                                '19 hari',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9FBEF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Persentase Kehadiran',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                              ),
                              Text(
                                '79%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Total Ketidakhadiran',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF2F80FF),
                                  ),
                                ),
                              ),
                              Text(
                                '4 hari',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2F80FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _SummaryCard({
    required this.bg,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFEAF2FF),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

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
      child: child,
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final DateTime month;
  final int selectedDay;
  final Map<int, _PresenceStatus> statusByDay;
  final ValueChanged<int> onSelectDay;

  const _CalendarCard({
    required this.month,
    required this.selectedDay,
    required this.statusByDay,
    required this.onSelectDay,
  });

  int _daysInMonth(DateTime m) {
    return DateTime(m.year, m.month + 1, 0).day;
  }

  Color _dotColor(_PresenceStatus s) {
    return switch (s) {
      _PresenceStatus.hadir => const Color(0xFF16A34A),
      _PresenceStatus.sakit => const Color(0xFFEAB308),
      _PresenceStatus.izin => const Color(0xFF2F80FF),
      _PresenceStatus.alfa => const Color(0xFFEF4444),
    };
  }

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = _daysInMonth(month);
    final startIndex = first.weekday % 7;

    const headers = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

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
            height: 52,
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
                for (final h in headers)
                  Expanded(
                    child: Center(
                      child: Text(
                        h,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final day = index - startIndex + 1;
              final inMonth = day >= 1 && day <= daysInMonth;
              final isSelected = inMonth && day == selectedDay;
              final status = inMonth ? statusByDay[day] : null;
              final textColor = isSelected
                  ? const Color(0xFF2F80FF)
                  : const Color(0xFF374151);

              return InkWell(
                onTap: inMonth ? () => onSelectDay(day) : null,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade100, width: 1),
                      bottom: BorderSide(color: Colors.grey.shade100, width: 1),
                    ),
                  ),
                  child: Center(
                    child: inMonth
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      isSelected ? FontWeight.w900 : FontWeight.w800,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: status != null
                                      ? _dotColor(status)
                                      : isSelected
                                          ? const Color(0xFF2F80FF)
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
