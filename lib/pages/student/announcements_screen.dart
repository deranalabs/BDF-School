import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_AnnouncementItem>[
      const _AnnouncementItem(
        accent: Color(0xFFEF4444),
        iconBg: Color(0xFFFEE2E2),
        title: 'Libur Semester Ganjil\n2024/2025',
        date: '20 Desember 2025',
        time: '08:00',
        author: 'Kepala Sekolah',
        tags: [
          _Tag(text: 'Disematkan', bg: Color(0xFFEFF6FF), fg: Color(0xFF2F80FF), icon: Icons.push_pin_outlined),
          _Tag(text: 'Penting', bg: Color(0xFFFEE2E2), fg: Color(0xFFEF4444), icon: Icons.error_outline),
          _Tag(text: 'Informasi Penting', bg: Color(0xFFFEE2E2), fg: Color(0xFFEF4444)),
        ],
      ),
      const _AnnouncementItem(
        accent: Color(0xFF2F80FF),
        iconBg: Color(0xFFEFF6FF),
        title: 'Pengumuman Ujian Akhir\nSemester',
        date: '18 Desember 2025',
        time: '10:30',
        author: 'Wakil Kepala Sekolah Kurikulum',
        tags: [
          _Tag(text: 'Disematkan', bg: Color(0xFFEFF6FF), fg: Color(0xFF2F80FF), icon: Icons.push_pin_outlined),
          _Tag(text: 'Akademik', bg: Color(0xFFEFF6FF), fg: Color(0xFF2F80FF)),
        ],
      ),
      const _AnnouncementItem(
        accent: Color(0xFF16A34A),
        iconBg: Color(0xFFE9FBEF),
        title: 'Pendaftaran Ekstrakurikuler\nSemester Genap',
        date: '17 Desember 2025',
        time: '14:00',
        author: 'Pembina OSIS',
        tags: [
          _Tag(text: 'Ekstrakurikuler', bg: Color(0xFFE9FBEF), fg: Color(0xFF16A34A)),
        ],
      ),
      const _AnnouncementItem(
        accent: Color(0xFFEAB308),
        iconBg: Color(0xFFFFF3D6),
        title: 'Pengumuman Pemenang Lomba\nKarya Ilmiah',
        date: '16 Desember 2025',
        time: '11:00',
        author: 'Tim Juri Lomba',
        tags: [
          _Tag(text: 'Prestasi', bg: Color(0xFFFFF3D6), fg: Color(0xFFB45309)),
        ],
      ),
      const _AnnouncementItem(
        accent: Color(0xFF9333EA),
        iconBg: Color(0xFFF2E7FF),
        title: 'Jadwal Konseling Psikologi',
        date: '15 Desember 2025',
        time: '09:00',
        author: 'Guru BK',
        tags: [
          _Tag(text: 'Layanan Siswa', bg: Color(0xFFF2E7FF), fg: Color(0xFF9333EA)),
        ],
      ),
      const _AnnouncementItem(
        accent: Color(0xFF6366F1),
        iconBg: Color(0xFFEFF6FF),
        title: 'Pemeliharaan Sistem E-Learning',
        date: '14 Desember 2025',
        time: '16:00',
        author: 'Tim IT Sekolah',
        tags: [
          _Tag(text: 'Penting', bg: Color(0xFFFEE2E2), fg: Color(0xFFEF4444), icon: Icons.error_outline),
          _Tag(text: 'Teknologi', bg: Color(0xFFEFF6FF), fg: Color(0xFF2F80FF)),
        ],
      ),
      const _AnnouncementItem(
        accent: Color(0xFFEC4899),
        iconBg: Color(0xFFFFE7F3),
        title: 'Donor Darah PMR',
        date: '13 Desember 2025',
        time: '12:00',
        author: 'PMR Sekolah',
        tags: [
          _Tag(text: 'Kegiatan', bg: Color(0xFFFFE7F3), fg: Color(0xFFEC4899)),
        ],
      ),
      const _AnnouncementItem(
        accent: Color(0xFFF97316),
        iconBg: Color(0xFFFFEDD5),
        title: 'Pentas Seni Akhir Tahun',
        date: '12 Desember 2025',
        time: '13:30',
        author: 'OSIS',
        tags: [
          _Tag(text: 'Kegiatan', bg: Color(0xFFFFE7F3), fg: Color(0xFFEC4899)),
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
                          'Pengumuman',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '8 pengumuman',
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
                children: [
                  _InfoBanner(
                    title: 'Informasi Terbaru',
                    subtitle:
                        'Pastikan Anda selalu membaca pengumuman untuk\nmendapatkan informasi terkini dari sekolah',
                  ),
                  const SizedBox(height: 16),
                  for (final item in items) ...[
                    _AnnouncementCard(item: item),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F80FF), Color(0xFF1E5BFF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.campaign_outlined,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFEAF2FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
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

class _AnnouncementCard extends StatelessWidget {
  final _AnnouncementItem item;

  const _AnnouncementCard({required this.item});

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.campaign_outlined, color: item.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in item.tags) _ChipTag(tag: t),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(
                      item.date,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.access_time_rounded,
                        size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(
                      item.author,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipTag extends StatelessWidget {
  final _Tag tag;

  const _ChipTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tag.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag.icon != null) ...[
            Icon(tag.icon, size: 14, color: tag.fg),
            const SizedBox(width: 6),
          ],
          Text(
            tag.text,
            style: TextStyle(
              color: tag.fg,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementItem {
  final Color accent;
  final Color iconBg;
  final String title;
  final String date;
  final String time;
  final String author;
  final List<_Tag> tags;

  const _AnnouncementItem({
    required this.accent,
    required this.iconBg,
    required this.title,
    required this.date,
    required this.time,
    required this.author,
    required this.tags,
  });
}

class _Tag {
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;

  const _Tag({
    required this.text,
    required this.bg,
    required this.fg,
    this.icon,
  });
}
