import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/auth_controller.dart';
import '../shared/widgets/dashboard_header.dart';
import '../shared/widgets/app_sidebar.dart';
import '../shared/notifications_screen.dart';
import 'classes_screen.dart';
import 'grades_input_screen.dart';
import 'presence_validation_screen.dart';
import 'announcements_screen.dart';
import 'profile_screen.dart';
import 'tasks_monitoring_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<NotificationItem> _notifications = const [
    NotificationItem(
      id: 'grading',
      type: NotificationType.warning,
      title: 'Deadline Penilaian',
      message: 'Nilai tugas Matematika XII IPA 1 harus lengkap hari ini',
      timeAgo: '10 menit yang lalu',
      isRead: false,
    ),
    NotificationItem(
      id: 'presence',
      type: NotificationType.info,
      title: 'Presensi Menunggu',
      message: '12 siswa menanti validasi di kelas XI IPA 2',
      timeAgo: '1 jam yang lalu',
      isRead: false,
    ),
    NotificationItem(
      id: 'meeting',
      type: NotificationType.success,
      title: 'Rapat Disetujui',
      message: 'Agenda rapat guru Jumat 15.00 telah dikonfirmasi',
      timeAgo: '3 jam yang lalu',
      isRead: true,
    ),
    NotificationItem(
      id: 'announcement',
      type: NotificationType.message,
      title: 'Pesan Kepala Sekolah',
      message: 'Mohon siapkan materi pengayaan ujian akhir',
      timeAgo: 'Kemarin',
      isRead: true,
    ),
  ];

  int get _unreadNotifications =>
      _notifications.where((n) => !n.isRead).length;

  void _onMenuSelected(int index, String title) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        break;
      case 1:
        _pushPage(const TeacherClassesScreen());
        break;
      case 2:
        _pushPage(const GradesInputScreen());
        break;
      case 3:
        _pushPage(const PresenceValidationScreen());
        break;
      case 4:
        _pushPage(const TeacherAnnouncementsScreen());
        break;
      case 5:
        _pushPage(const TeacherTasksScreen());
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title akan tersedia setelah integrasi backend')),
        );
    }
  }

  void _pushPage(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

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
      MaterialPageRoute<void>(builder: (_) => const TeacherProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final name = user?.username ?? 'Guru';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'G';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF6F8FC),
      drawer: AppSidebar(
        roleLabel: 'Guru',
        roleSubtitle: 'Pengampu Matematika',
        profileInitial: initial,
        items: [
          SidebarMenuItem(
            icon: Icons.home_outlined,
            title: 'Dashboard',
            selected: _selectedIndex == 0,
            onTap: () => _onMenuSelected(0, 'Dashboard'),
          ),
          SidebarMenuItem(
            icon: Icons.groups_2_outlined,
            title: 'Kelas Diampu',
            selected: _selectedIndex == 1,
            onTap: () => _onMenuSelected(1, 'Kelas Diampu'),
          ),
          SidebarMenuItem(
            icon: Icons.assignment_add,
            title: 'Input Nilai',
            selected: _selectedIndex == 2,
            onTap: () => _onMenuSelected(2, 'Input Nilai'),
          ),
          SidebarMenuItem(
            icon: Icons.fact_check_outlined,
            title: 'Validasi Presensi',
            selected: _selectedIndex == 3,
            onTap: () => _onMenuSelected(3, 'Validasi Presensi'),
          ),
          SidebarMenuItem(
            icon: Icons.campaign_outlined,
            title: 'Pengumuman',
            selected: _selectedIndex == 4,
            onTap: () => _onMenuSelected(4, 'Pengumuman'),
          ),
          SidebarMenuItem(
            icon: Icons.track_changes_outlined,
            title: 'Monitoring Tugas',
            selected: _selectedIndex == 5,
            onTap: () => _onMenuSelected(5, 'Monitoring Tugas'),
          ),
        ],
        onLogout: () {
          Navigator.of(context).pop();
          context.read<AuthController>().logout();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: DashboardHeader(
                  title: 'Dashboard',
                  subtitle: 'Halo, $name',
                  profileInitial: initial,
                  onOpenMenu: () => _scaffoldKey.currentState?.openDrawer(),
                  onOpenNotifications: _openNotifications,
                  showNotificationDot: _unreadNotifications > 0,
                  onOpenProfile: _openProfile,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: _TeachingAgendaCard(
                  onStartClass: () => _pushPage(const TeacherClassesScreen()),
                  onValidatePresence: () => _pushPage(const PresenceValidationScreen()),
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
                        icon: Icons.groups_outlined,
                        iconBg: Color(0xFF2F80FF),
                        value: '6',
                        title: 'Kelas Aktif',
                        subtitle: 'Semester ini',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.assignment_turned_in_rounded,
                        iconBg: Color(0xFF16A34A),
                        value: '18',
                        title: 'Tugas Dinilai',
                        subtitle: 'Minggu ini',
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
                  title: 'Jadwal Mengajar Hari Ini',
                  actionText: 'Lihat Semua',
                  onAction: () => _pushPage(const TeacherClassesScreen()),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Column(
                  children: const [
                    _ScheduleCard(
                      pillText: 'Kelas XII IPA 1',
                      pillBg: Color(0xFFE7F0FF),
                      pillFg: Color(0xFF2F80FF),
                      subject: 'Matematika Lanjutan',
                      room: 'Ruang 3A',
                      time: '08:00 - 09:30',
                    ),
                    SizedBox(height: 12),
                    _ScheduleCard(
                      pillText: 'Kelas XI IPA 2',
                      pillBg: Color(0xFFE9FBEF),
                      pillFg: Color(0xFF16A34A),
                      subject: 'Statistika',
                      room: 'Ruang 2C',
                      time: '10:00 - 11:30',
                    ),
                    SizedBox(height: 12),
                    _ScheduleCard(
                      pillText: 'Kelas XII IPS 1',
                      pillBg: Color(0xFFF2E7FF),
                      pillFg: Color(0xFF7C3AED),
                      subject: 'Matematika Bisnis',
                      room: 'Ruang 4B',
                      time: '13:00 - 14:30',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: const _SectionHeader(title: 'Monitoring Tugas'),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Column(
                  children: const [
                    _TaskMonitorCard(
                      subject: 'Matematika Lanjutan',
                      pending: 5,
                      due: 'Besok, 14:00',
                    ),
                    SizedBox(height: 12),
                    _TaskMonitorCard(
                      subject: 'Statistika',
                      pending: 2,
                      due: '2 hari lagi',
                    ),
                    SizedBox(height: 12),
                    _TaskMonitorCard(
                      subject: 'Matematika Bisnis',
                      pending: 8,
                      due: 'Senin depan',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: const _SectionHeader(title: 'Pengumuman'),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: Column(
                  children: const [
                    _AnnouncementCard(
                      icon: Icons.event,
                      title: 'Rapat Guru',
                      subtitle: 'Jumat, 15.00 di Ruang Rapat',
                    ),
                    SizedBox(height: 12),
                    _AnnouncementCard(
                      icon: Icons.newspaper,
                      title: 'Input Nilai Semester',
                      subtitle: 'Batas akhir 20 Desember 2025',
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

  static void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature akan tersedia setelah integrasi backend')),
    );
  }
}

class _TeachingAgendaCard extends StatelessWidget {
  const _TeachingAgendaCard({
    required this.onStartClass,
    required this.onValidatePresence,
  });

  final VoidCallback onStartClass;
  final VoidCallback onValidatePresence;

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
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agenda Mengajar',
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
              _AgendaBadge(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.class_, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'Kelas selanjutnya: XII IPA 1 · 08:00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onStartClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E5BFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text(
                    'Mulai Kelas',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onValidatePresence,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text(
                    'Validasi Presensi',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AgendaBadge extends StatelessWidget {
  const _AgendaBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 28),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.value,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconBg;
  final String value;
  final String title;
  final String subtitle;

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
  const _SectionHeader({
    required this.title,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String? actionText;
  final VoidCallback? onAction;

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
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
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
  const _ScheduleCard({
    required this.pillText,
    required this.pillBg,
    required this.pillFg,
    required this.subject,
    required this.room,
    required this.time,
  });

  final String pillText;
  final Color pillBg;
  final Color pillFg;
  final String subject;
  final String room;
  final String time;

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
                  subject,
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
              const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF6B7280)),
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

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

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

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 150,
          height: 110,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const Spacer(),
              Text(
                label,
                style: TextStyle(
                  color: color.darken(),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskMonitorCard extends StatelessWidget {
  const _TaskMonitorCard({
    required this.subject,
    required this.pending,
    required this.due,
  });

  final String subject;
  final int pending;
  final String due;

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
          Text(
            subject,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.pending_actions_rounded, size: 18, color: Color(0xFFEF4444)),
              const SizedBox(width: 8),
              Text(
                '$pending tugas belum dinilai',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                due,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
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

extension on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
