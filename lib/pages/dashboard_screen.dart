import 'package:flutter/material.dart';

import 'announcements_screen.dart';
import 'grades_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'presence_screen.dart';
import 'schedule_screen.dart';
import 'tasks_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  List<NotificationItem> _notifications = const [
    NotificationItem(
      id: 'deadline',
      type: NotificationType.warning,
      title: 'Deadline Tugas',
      message: 'Tugas Matematika Bab 5 akan berakhir besok\njam 14:00',
      timeAgo: '5 menit yang lalu',
      isRead: false,
    ),
    NotificationItem(
      id: 'schedule',
      type: NotificationType.info,
      title: 'Jadwal Baru',
      message: 'Jadwal pelajaran minggu depan telah diperbarui',
      timeAgo: '1 jam yang lalu',
      isRead: false,
    ),
    NotificationItem(
      id: 'grades',
      type: NotificationType.success,
      title: 'Nilai Tersedia',
      message: 'Nilai ujian Fisika sudah dapat dilihat',
      timeAgo: '2 jam yang lalu',
      isRead: false,
    ),
    NotificationItem(
      id: 'message',
      type: NotificationType.message,
      title: 'Pesan dari Guru',
      message: 'Pak Budi: Jangan lupa bawa alat praktikum\nbesok',
      timeAgo: '3 jam yang lalu',
      isRead: true,
    ),
    NotificationItem(
      id: 'announcement',
      type: NotificationType.info,
      title: 'Pengumuman Sekolah',
      message: 'Libur semester akan dimulai tanggal 20\nDesember 2024',
      timeAgo: '1 hari yang lalu',
      isRead: true,
    ),
    NotificationItem(
      id: 'presence',
      type: NotificationType.warning,
      title: 'Presensi',
      message: 'Anda belum melakukan presensi hari ini',
      timeAgo: '2 hari yang lalu',
      isRead: true,
    ),
  ];

  int get _unreadNotifications =>
      _notifications.where((n) => !n.isRead).length;

  Future<void> _openNotifications() async {
    final result = await Navigator.of(context).push<List<NotificationItem>>(
      MaterialPageRoute<List<NotificationItem>>(
        builder: (_) => NotificationsScreen(initialItems: _notifications),
      ),
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _notifications = result;
      });
    }
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
  }

  void _onMenuSelected(int index, String title) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const TasksScreen()),
      );
      return;
    }

    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ScheduleScreen()),
      );
      return;
    }

    if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const PresenceScreen()),
      );
      return;
    }

    if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const GradesScreen()),
      );
      return;
    }

    if (index == 5) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const AnnouncementsScreen()),
      );
      return;
    }

    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title belum dibuat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF6F8FC),
      drawer: AppSidebar(
        selectedIndex: _selectedIndex,
        onSelected: _onMenuSelected,
        onLogout: () {
          Navigator.of(context).pop();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: _Header(
                  onOpenMenu: () => _scaffoldKey.currentState?.openDrawer(),
                  showNotifDot: _unreadNotifications > 0,
                  onOpenNotifications: _openNotifications,
                  onOpenProfile: _openProfile,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: _AttendanceCard(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Presensi Sekarang ditekan')),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Row(
                  children: const [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.menu_book_rounded,
                        iconBg: Color(0xFF2F80FF),
                        value: '12',
                        title: 'Pelajaran',
                        subtitle: 'Aktif',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_month_rounded,
                        iconBg: Color(0xFF16A34A),
                        value: '95%',
                        title: 'Kehadiran',
                        subtitle: 'Bulan ini',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: _SectionHeader(
                  title: 'Jadwal Hari Ini',
                  actionText: 'Lihat Semua',
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lihat Semua Jadwal')),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Column(
                  children: const [
                    _ScheduleCard(
                      pillText: 'Matematika',
                      pillBg: Color(0xFFE7F0FF),
                      pillFg: Color(0xFF2F80FF),
                      teacher: 'Bu Sarah',
                      room: 'Kelas 12A',
                      time: '08:00 - 09:30',
                    ),
                    SizedBox(height: 12),
                    _ScheduleCard(
                      pillText: 'Bahasa Indonesia',
                      pillBg: Color(0xFFF2E7FF),
                      pillFg: Color(0xFF7C3AED),
                      teacher: 'Pak Budi',
                      room: 'Kelas 12A',
                      time: '09:30 - 11:00',
                    ),
                    SizedBox(height: 12),
                    _ScheduleCard(
                      pillText: 'Fisika',
                      pillBg: Color(0xFFE9FBEF),
                      pillFg: Color(0xFF16A34A),
                      teacher: 'Bu Diana',
                      room: 'Lab Fisika',
                      time: '13:00 - 14:30',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: _SectionHeader(
                  title: 'Tugas',
                  actionText: 'Lihat Semua',
                  onAction: null,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Column(
                  children: const [
                    _TaskTile(
                      title: 'Tugas Matematika Bab 5',
                      subtitle: 'Besok, 14:00',
                      subtitleColor: Color(0xFFEF4444),
                      checked: false,
                      showAlert: true,
                    ),
                    SizedBox(height: 10),
                    _TaskTile(
                      title: 'Essay Bahasa Indonesia',
                      subtitle: '3 hari lagi',
                      subtitleColor: Color(0xFF6B7280),
                      checked: false,
                      showAlert: false,
                    ),
                    SizedBox(height: 10),
                    _TaskTile(
                      title: 'Laporan Praktikum Fisika',
                      subtitle: 'Selesai',
                      subtitleColor: Color(0xFF9CA3AF),
                      checked: true,
                      showAlert: false,
                      strikeTitle: true,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: _SectionHeader(
                  title: 'Pengumuman',
                  actionText: 'Lihat Semua',
                  onAction: null,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: Column(
                  children: const [
                    _AnnouncementCard(
                      icon: Icons.event,
                      title: 'Libur Nasional',
                      subtitle: '15 Desember 2025 - Sekolah libur',
                    ),
                    SizedBox(height: 12),
                    _AnnouncementCard(
                      icon: Icons.edit_note,
                      title: 'Ujian Tengah Semester',
                      subtitle: 'Dimulai 20 Desember 2025',
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

class _Header extends StatelessWidget {
  final VoidCallback onOpenMenu;
  final VoidCallback onOpenNotifications;
  final bool showNotifDot;
  final VoidCallback onOpenProfile;

  const _Header({
    required this.onOpenMenu,
    required this.onOpenNotifications,
    required this.showNotifDot,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onOpenMenu,
          icon: const Icon(Icons.menu_rounded),
          color: const Color(0xFF111827),
          splashRadius: 22,
        ),
        const SizedBox(width: 6),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  height: 1.05,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Halo, Siswa!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onOpenNotifications,
              icon: const Icon(Icons.notifications_none_rounded),
              color: const Color(0xFF111827),
              splashRadius: 22,
            ),
            if (showNotifDot)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F80FF),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: onOpenProfile,
          borderRadius: BorderRadius.circular(999),
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF2F80FF),
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AttendanceCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F80FF), Color(0xFF1E5BFF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Presensi Kehadiran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Rabu, 17 Desember 2025',
                        style: TextStyle(
                          color: Color(0xFFEAF2FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.how_to_reg_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Icon(Icons.access_time_rounded,
                    color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  '21.50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 18),
                Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'SMA Negeri 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.how_to_reg_rounded,
                        color: Color(0xFF1E5BFF)),
                    SizedBox(width: 10),
                    Text(
                      'Presensi Sekarang',
                      style: TextStyle(
                        color: Color(0xFF1E5BFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String value;
  final String title;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.value,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2F80FF),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String pillText;
  final Color pillBg;
  final Color pillFg;
  final String teacher;
  final String room;
  final String time;

  const _ScheduleCard({
    required this.pillText,
    required this.pillBg,
    required this.pillFg,
    required this.teacher,
    required this.room,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: pillBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    pillText,
                    style: TextStyle(
                      color: pillFg,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  teacher,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  room,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final bool checked;
  final bool showAlert;
  final bool strikeTitle;

  const _TaskTile({
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.checked,
    required this.showAlert,
    this.strikeTitle = false,
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
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: checked ? const Color(0xFF22C55E) : const Color(0xFFD1D5DB),
                width: 2,
              ),
              color: checked ? const Color(0xFF22C55E) : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: checked
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: strikeTitle
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF111827),
                    decoration:
                        strikeTitle ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: subtitleColor,
                      ),
                    ),
                    if (showAlert) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.error_outline,
                          size: 16, color: Color(0xFFEF4444)),
                    ],
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

class _AnnouncementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AnnouncementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD9E8FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: const Color(0xFF2F80FF)),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
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

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index, String title) onSelected;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2F80FF), Color(0xFF1E5BFF)],
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Siswa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelas XII IPA 1',
                          style: TextStyle(
                            color: Color(0xFFEAF2FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            Container(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 6),
            _SidebarItem(
              selected: selectedIndex == 0,
              icon: Icons.home_outlined,
              title: 'Dashboard',
              onTap: () => onSelected(0, 'Dashboard'),
            ),
            _SidebarItem(
              selected: selectedIndex == 1,
              icon: Icons.description_outlined,
              title: 'Tugas',
              onTap: () => onSelected(1, 'Tugas'),
            ),
            _SidebarItem(
              selected: selectedIndex == 2,
              icon: Icons.calendar_today_outlined,
              title: 'Jadwal',
              onTap: () => onSelected(2, 'Jadwal'),
            ),
            _SidebarItem(
              selected: selectedIndex == 3,
              icon: Icons.fact_check_outlined,
              title: 'Presensi',
              onTap: () => onSelected(3, 'Presensi'),
            ),
            _SidebarItem(
              selected: selectedIndex == 4,
              icon: Icons.menu_book_outlined,
              title: 'Nilai',
              onTap: () => onSelected(4, 'Nilai'),
            ),
            _SidebarItem(
              selected: selectedIndex == 5,
              icon: Icons.campaign_outlined,
              title: 'Pengumuman',
              onTap: () => onSelected(5, 'Pengumuman'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: InkWell(
                onTap: onLogout,
                child: SizedBox(
                  height: 52,
                  child: Row(
                    children: const [
                      Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                      SizedBox(width: 14),
                      Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFEF4444),
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
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.selected,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFEFF6FF) : Colors.transparent;
    final fg = selected ? const Color(0xFF2F80FF) : const Color(0xFF374151);
    final iconColor = selected ? const Color(0xFF2F80FF) : const Color(0xFF6B7280);

    return Material(
      color: bg,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              Container(
                width: 4,
                color: selected ? const Color(0xFF2F80FF) : Colors.transparent,
              ),
              const SizedBox(width: 14),
              Icon(icon, color: iconColor),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
