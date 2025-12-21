import 'package:flutter/material.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 210,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2F80FF), Color(0xFF1E5BFF)],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 18, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        splashRadius: 22,
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Profil Guru',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                    child: Column(
                      children: [
                        _ProfileCard(),
                        const SizedBox(height: 18),
                        const _SectionTitle('Informasi Utama'),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.mail_outline,
                          iconColor: Color(0xFF2F80FF),
                          title: 'Email',
                          value: 'budi.santoso@sekolah.id',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.phone_outlined,
                          iconColor: Color(0xFF16A34A),
                          title: 'Telepon',
                          value: '+62 812-3456-7890',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.location_on_outlined,
                          iconColor: Color(0xFFEF4444),
                          title: 'Ruang Guru',
                          value: 'Gedung B · Lantai 2',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.calendar_month_outlined,
                          iconColor: Color(0xFF9333EA),
                          title: 'Jadwal Konsultasi',
                          value: 'Selasa & Kamis, 15:00 - 16:30',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Expanded(
                              child: _SmallInfoTile(
                                title: 'NIP',
                                value: '19781212 200501 1 002',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _SmallInfoTile(
                                title: 'Pengalaman',
                                value: '15 tahun',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(height: 1, color: const Color(0xFFF1F5F9)),
                        const SizedBox(height: 18),
                        const _SectionTitle('Penugasan & Jadwal'),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.class_outlined,
                          iconColor: Color(0xFF2F80FF),
                          title: 'Kelas Diampu',
                          value: 'XII IPA 1 · XI IPA 2 · XII IPS 1',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.assignment_turned_in_outlined,
                          iconColor: Color(0xFF16A34A),
                          title: 'Jam Mengajar',
                          value: '24 JP / minggu',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.workspace_premium_outlined,
                          iconColor: Color(0xFFEAB308),
                          title: 'Tugas Tambahan',
                          value: 'Koordinator Olimpiade Matematika',
                        ),
                        const SizedBox(height: 18),
                        Container(height: 1, color: const Color(0xFFF1F5F9)),
                        const SizedBox(height: 18),
                        const _SectionTitle('Pendidikan & Sertifikasi'),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.school_outlined,
                          iconColor: Color(0xFF7C3AED),
                          title: 'Pendidikan Terakhir',
                          value: 'S2 Pendidikan Matematika - UPI',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.verified_outlined,
                          iconColor: Color(0xFF2DD4BF),
                          title: 'Sertifikasi',
                          value: 'Guru Penggerak · Asesor PPG',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
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
              const SizedBox(height: 8),
              const Text(
                'Budi Santoso, S.Pd',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Guru Matematika · XII IPA 1',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Layanan Konseling Matematika',
                  style: TextStyle(
                    color: Color(0xFF2F80FF),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
        Positioned(
          top: -34,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
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
                border: Border.all(color: Colors.white, width: 4),
              ),
              alignment: Alignment.center,
              child: const Text(
                'BS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Color(0xFF111827),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
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

class _SmallInfoTile extends StatelessWidget {
  const _SmallInfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
