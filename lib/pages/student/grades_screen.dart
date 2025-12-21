import 'dart:math' as math;

import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final List<_SubjectGrade> _subjects = const [
    _SubjectGrade(
      color: Color(0xFF2F80FF),
      subject: 'Matematika',
      teacher: 'Pak Budi Santoso',
      score: 88,
      trendUp: true,
    ),
    _SubjectGrade(
      color: Color(0xFF16A34A),
      subject: 'Bahasa Indonesia',
      teacher: 'Bu Siti Rahayu',
      score: 91,
      trendUp: false,
    ),
    _SubjectGrade(
      color: Color(0xFF7C3AED),
      subject: 'Fisika',
      teacher: 'Pak Ahmad Hidayat',
      score: 86,
      trendUp: true,
    ),
    _SubjectGrade(
      color: Color(0xFFDB2777),
      subject: 'Kimia',
      teacher: 'Pak Hendra',
      score: 88,
      trendUp: false,
    ),
    _SubjectGrade(
      color: Color(0xFFEF4444),
      subject: 'Bahasa Inggris',
      teacher: 'Miss Sarah',
      score: 94,
      trendUp: true,
    ),
    _SubjectGrade(
      color: Color(0xFFB45309),
      subject: 'Sejarah',
      teacher: 'Bu Dewi Kartika',
      score: 85,
      trendUp: false,
    ),
    _SubjectGrade(
      color: Color(0xFF0EA5A4),
      subject: 'Biologi',
      teacher: 'Bu Linda',
      score: 89,
      trendUp: true,
    ),
    _SubjectGrade(
      color: Color(0xFFF97316),
      subject: 'Ekonomi',
      teacher: 'Pak Rudi',
      score: 86,
      trendUp: true,
    ),
  ];

  int get _avg => 88;
  int get _max => 94;
  int get _rank => 3;

  @override
  Widget build(BuildContext context) {
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
                          'Nilai',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Semester 1 - 2025/2026',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            bg: const Color(0xFF2F80FF),
                            icon: Icons.gps_fixed_rounded,
                            value: '$_avg',
                            label: 'Rata-rata',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            bg: const Color(0xFF16A34A),
                            icon: Icons.emoji_events_outlined,
                            value: '$_max',
                            label: 'Tertinggi',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            bg: const Color(0xFF9333EA),
                            icon: Icons.trending_up_rounded,
                            value: '$_rank',
                            label: 'Peringkat',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                            child: Text(
                              'Daftar Nilai',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          for (final s in _subjects) _DetailGradeCard(item: s),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final String value;
  final String label;

  const _MetricCard({
    required this.bg,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
          Icon(icon, color: Colors.white, size: 24),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
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

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

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

class _AvgLineChart extends StatelessWidget {
  const _AvgLineChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AvgLineChartPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _AvgLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const bottomPad = 26.0;
    final rect = Rect.fromLTWH(leftPad, 10, size.width - leftPad - 10, size.height - bottomPad - 10);

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dashed = _DashedPathPainter();

    final yTicks = [75, 82, 89, 100];
    for (final y in yTicks) {
      final t = (y - 75) / (100 - 75);
      final yy = rect.bottom - rect.height * t;
      dashed.drawHorizontal(canvas, Offset(rect.left, yy), Offset(rect.right, yy), gridPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: '$y',
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(4, yy - tp.height / 2));
    }

    dashed.drawVertical(canvas, Offset(rect.left, rect.top), Offset(rect.left, rect.bottom), gridPaint);

    final points = const [83.0, 85.0, 88.0, 88.0];
    final xs = List<double>.generate(4, (i) => rect.left + rect.width * (i / 3));
    final ys = points
        .map((v) => rect.bottom - rect.height * ((v - 75) / (100 - 75)))
        .toList(growable: false);

    final linePaint = Paint()
      ..color = const Color(0xFF2F80FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(xs.first, ys.first);
    for (var i = 1; i < xs.length; i++) {
      path.lineTo(xs[i], ys[i]);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFF2F80FF);
    for (var i = 0; i < xs.length; i++) {
      canvas.drawCircle(Offset(xs[i], ys[i]), 5.5, dotPaint);
    }

    const labels = ['Sep', 'Oct', 'Nov', 'Dec'];
    for (var i = 0; i < labels.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(xs[i] - tp.width / 2, rect.bottom + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RadarChart extends StatelessWidget {
  const _RadarChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadarPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 8);
    final radius = math.min(size.width, size.height) * 0.34;

    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const rings = 4;
    for (var r = 1; r <= rings; r++) {
      final rr = radius * (r / rings);
      final path = Path();
      for (var i = 0; i < 6; i++) {
        final angle = -math.pi / 2 + i * (math.pi * 2 / 6);
        final p = center + Offset(math.cos(angle), math.sin(angle)) * rr;
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    for (var i = 0; i < 6; i++) {
      final angle = -math.pi / 2 + i * (math.pi * 2 / 6);
      final p = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawLine(center, p, paint);
    }

    const labels = ['Matema.', 'Bahasa.', 'Fisika', 'Kimia', 'Bahasa.', 'Sejarah'];
    for (var i = 0; i < labels.length; i++) {
      final angle = -math.pi / 2 + i * (math.pi * 2 / 6);
      final p = center + Offset(math.cos(angle), math.sin(angle)) * (radius + 32);
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy - tp.height / 2));
    }

    const ticks = ['0', '25', '50', '75', '100'];
    for (var i = 0; i < ticks.length; i++) {
      final t = i / (ticks.length - 1);
      final yy = center.dy - radius * t;
      final tp = TextPainter(
        text: TextSpan(
          text: ticks[i],
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(center.dx - tp.width / 2, yy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChart extends StatelessWidget {
  final List<_SubjectGrade> subjects;

  const _BarChart({required this.subjects});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _BarChartPainter(subjects),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<_SubjectGrade> subjects;

  _BarChartPainter(this.subjects);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 32.0;
    const bottomPad = 42.0;
    final rect = Rect.fromLTWH(leftPad, 10, size.width - leftPad - 10, size.height - bottomPad - 10);

    final axisPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dashed = _DashedPathPainter();

    final ticks = [0, 25, 50, 75, 100];
    for (final y in ticks) {
      final t = y / 100;
      final yy = rect.bottom - rect.height * t;
      dashed.drawHorizontal(canvas, Offset(rect.left, yy), Offset(rect.right, yy), axisPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: '$y',
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, yy - tp.height / 2));
    }

    dashed.drawVertical(canvas, Offset(rect.left, rect.top), Offset(rect.left, rect.bottom), axisPaint);

    final barCount = subjects.length;
    final gap = rect.width / (barCount + 0.5);
    final barW = gap * 0.62;

    final barPaint = Paint()..color = const Color(0xFF2F80FF);

    for (var i = 0; i < barCount; i++) {
      final v = subjects[i].score.toDouble();
      final h = rect.height * (v / 100);
      final x = rect.left + gap * i + gap * 0.2;
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, rect.bottom - h, barW, h),
        const Radius.circular(8),
      );
      canvas.drawRRect(r, barPaint);

      final label = subjects[i].subject;
      final short = label.length > 9 ? '${label.substring(0, 8)}…' : label;
      final tp = TextPainter(
        text: TextSpan(
          text: short,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 70);

      canvas.save();
      canvas.translate(x + barW / 2, rect.bottom + 14);
      canvas.rotate(-math.pi / 4);
      tp.paint(canvas, Offset(-tp.width / 2, 0));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashedPathPainter {
  void drawHorizontal(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 4.0;
    const gap = 4.0;
    var x = start.dx;
    while (x < end.dx) {
      final x2 = math.min(x + dash, end.dx);
      canvas.drawLine(Offset(x, start.dy), Offset(x2, start.dy), paint);
      x = x2 + gap;
    }
  }

  void drawVertical(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 4.0;
    const gap = 4.0;
    var y = start.dy;
    while (y < end.dy) {
      final y2 = math.min(y + dash, end.dy);
      canvas.drawLine(Offset(start.dx, y), Offset(start.dx, y2), paint);
      y = y2 + gap;
    }
  }
}

class _SubjectGrade {
  final Color color;
  final String subject;
  final String teacher;
  final int score;
  final bool trendUp;

  const _SubjectGrade({
    required this.color,
    required this.subject,
    required this.teacher,
    required this.score,
    required this.trendUp,
  });

  String get grade => 'A';
}

class _GradeRow extends StatelessWidget {
  final _SubjectGrade item;

  const _GradeRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Container(width: 4, color: item.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          if (item.trendUp)
            const Icon(Icons.trending_up_rounded, color: Color(0xFF16A34A))
          else
            const Text(
              '–',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF9CA3AF),
              ),
            ),
          const SizedBox(width: 12),
          Text(
            '${item.score}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Text(
              item.grade,
              style: const TextStyle(
                color: Color(0xFF16A34A),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _DetailGradeCard extends StatelessWidget {
  final _SubjectGrade item;

  const _DetailGradeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 4, height: 88, color: item.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.subject,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.teacher,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            const Text(
                              'Nilai Akhir:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF374151),
                              ),
                            ),
                            Text(
                              '${item.score}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF111827),
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                item.grade,
                                style: const TextStyle(
                                  color: Color(0xFF16A34A),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (item.trendUp)
                    const Icon(Icons.trending_up_rounded, color: Color(0xFF16A34A))
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '–',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  const SizedBox(width: 14),
                ],
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Komponen Nilai',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 10),
                _DetailRow(label: 'Tugas', value: '90'),
                SizedBox(height: 8),
                _DetailRow(label: 'Ulangan', value: '88'),
                SizedBox(height: 8),
                _DetailRow(label: 'UAS', value: '86'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
