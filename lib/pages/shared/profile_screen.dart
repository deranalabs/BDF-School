import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                          'Profil Siswa',
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
                        _SectionTitle(title: 'Informasi Pribadi'),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.mail_outline,
                          iconColor: Color(0xFF2F80FF),
                          title: 'Email',
                          value: 'ahmad.fauzi@student.school.id',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.phone_outlined,
                          iconColor: Color(0xFF16A34A),
                          title: 'Nomor Telepon',
                          value: '+62 812-3456-7890',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.location_on_outlined,
                          iconColor: Color(0xFFEF4444),
                          title: 'Alamat',
                          value: 'Jl. Pendidikan No. 123, Jakarta Selatan',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.calendar_month_outlined,
                          iconColor: Color(0xFF9333EA),
                          title: 'Tanggal Lahir',
                          value: '15 Januari 2007',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Expanded(
                              child: _SmallInfoTile(
                                title: 'NISN',
                                value: '0045678910',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _SmallInfoTile(
                                title: 'Jenis Kelamin',
                                value: 'Laki-laki',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(height: 1, color: const Color(0xFFF1F5F9)),
                        const SizedBox(height: 18),
                        _SectionTitle(title: 'Informasi Orang Tua'),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.person_outline,
                          iconColor: Color(0xFF2F80FF),
                          title: 'Nama Orang Tua',
                          value: 'Bapak Suharto',
                        ),
                        const SizedBox(height: 12),
                        const _InfoTile(
                          icon: Icons.phone_outlined,
                          iconColor: Color(0xFF16A34A),
                          title: 'Nomor Telepon',
                          value: '+62 813-9876-5432',
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
                'Ahmad Fauzi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'NIS: 2023010145',
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
                  'XII IPA 1',
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
                'AF',
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
  final String title;

  const _SectionTitle({required this.title});

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
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

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
  final String title;
  final String value;

  const _SmallInfoTile({required this.title, required this.value});

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

class _AchievementTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;

  const _AchievementTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });

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
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
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
