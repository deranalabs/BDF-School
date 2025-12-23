// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    this.onLogout,
    this.onTapDashboard,
    this.onTapTugas,
    this.onTapJadwal,
    this.onTapPresensi,
    this.onTapNilai,
    this.onTapPengumuman,
    this.onTapSiswa,
    this.onTapProfile,
    this.onTapSettings,
    this.selectedIndex = 0,
  });

  final VoidCallback? onLogout;
  final VoidCallback? onTapDashboard;
  final VoidCallback? onTapTugas;
  final VoidCallback? onTapJadwal;
  final VoidCallback? onTapPresensi;
  final VoidCallback? onTapNilai;
  final VoidCallback? onTapPengumuman;
  final VoidCallback? onTapSiswa;
  final VoidCallback? onTapProfile;
  final VoidCallback? onTapSettings;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 44, 16, 18),
            decoration: const BoxDecoration(
              color: Color(0xFF2F80FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: Text(
                    'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Panel',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Halo, Admin!',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 4),
                _SidebarItem(
                  icon: Icons.home_outlined,
                  label: 'Dashboard',
                  selected: selectedIndex == 0,
                  textStyle: textStyle,
                  onTap: onTapDashboard,
                ),
                _SidebarItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Jadwal',
                  selected: selectedIndex == 1,
                  textStyle: textStyle,
                  onTap: onTapJadwal,
                ),
                _SidebarItem(
                  icon: Icons.fact_check_outlined,
                  label: 'Presensi',
                  selected: selectedIndex == 2,
                  textStyle: textStyle,
                  onTap: onTapPresensi,
                ),
                _SidebarItem(
                  icon: Icons.school_outlined,
                  label: 'Nilai',
                  selected: selectedIndex == 3,
                  textStyle: textStyle,
                  onTap: onTapNilai,
                ),
                _SidebarItem(
                  icon: Icons.assignment_outlined,
                  label: 'Tugas',
                  selected: selectedIndex == 4,
                  textStyle: textStyle,
                  onTap: onTapTugas,
                ),
                _SidebarItem(
                  icon: Icons.notifications_none_outlined,
                  label: 'Pengumuman',
                  selected: selectedIndex == 5,
                  textStyle: textStyle,
                  onTap: onTapPengumuman,
                ),
                _SidebarItem(
                  icon: Icons.group_outlined,
                  label: 'Daftar Siswa',
                  selected: selectedIndex == 6,
                  textStyle: textStyle,
                  onTap: onTapSiswa,
                ),
                _SidebarItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  selected: selectedIndex == 7,
                  textStyle: textStyle,
                  onTap: onTapProfile,
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Pengaturan',
                  selected: selectedIndex == 8,
                  textStyle: textStyle,
                  onTap: onTapSettings,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Berhasil keluar')),
                );
                onLogout?.call();
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Color(0xFFD32F2F)),
                    const SizedBox(width: 12),
                    Text(
                      'Keluar',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.textStyle,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final TextStyle textStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF2F80FF) : Colors.black87;
    return Material(
      color: selected ? const Color(0xFFF0F5FF) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 14),
              Text(
                label,
                style: textStyle.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
