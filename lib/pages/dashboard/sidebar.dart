// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_controller.dart';

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
  final VoidCallback? onTapSettings;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0A1F44),
            ),
            child: Consumer<AuthController>(
                builder: (context, auth, child) {
                  final username = auth.user?['username'] ?? 'Admin';
                  final firstLetter = username.isNotEmpty ? username[0].toUpperCase() : 'A';
                  
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: Text(
                          firstLetter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Admin Panel',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Halo, $username',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SidebarItem(
                  icon: Icons.home_outlined,
                  label: 'Dashboard',
                  selected: selectedIndex == 0,
                  onTap: onTapDashboard,
                ),
                _SidebarItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Jadwal',
                  selected: selectedIndex == 1,
                  onTap: onTapJadwal,
                ),
                _SidebarItem(
                  icon: Icons.person_pin_outlined,
                  label: 'Presensi',
                  selected: selectedIndex == 2,
                  onTap: onTapPresensi,
                ),
                _SidebarItem(
                  icon: Icons.assessment_outlined,
                  label: 'Nilai',
                  selected: selectedIndex == 3,
                  onTap: onTapNilai,
                ),
                _SidebarItem(
                  icon: Icons.menu_book_outlined,
                  label: 'Tugas',
                  selected: selectedIndex == 4,
                  onTap: onTapTugas,
                ),
                _SidebarItem(
                  icon: Icons.notifications_none_outlined,
                  label: 'Pengumuman',
                  selected: selectedIndex == 5,
                  onTap: onTapPengumuman,
                ),
                _SidebarItem(
                  icon: Icons.groups_outlined,
                  label: 'Daftar Siswa',
                  selected: selectedIndex == 6,
                  onTap: onTapSiswa,
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Pengaturan',
                  selected: selectedIndex == 8,
                  onTap: onTapSettings,
                ),
              ],
            ),
          ),
          
          // Logout Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Konfirmasi Logout'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onLogout?.call();
                            },
                            child: const Text(
                              'Keluar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red.shade600,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFF4E6) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? const Color(0xFF0A1F44) : Colors.black87,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? const Color(0xFF0A1F44) : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}