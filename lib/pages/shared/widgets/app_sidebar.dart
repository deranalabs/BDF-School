import 'package:flutter/material.dart';

class SidebarMenuItem {
  const SidebarMenuItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.roleLabel,
    required this.roleSubtitle,
    required this.profileInitial,
    required this.items,
    required this.onLogout,
    this.onClose,
    this.headerGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2F80FF), Color(0xFF1E5BFF)],
    ),
  });

  final String roleLabel;
  final String roleSubtitle;
  final String profileInitial;
  final List<SidebarMenuItem> items;
  final VoidCallback onLogout;
  final VoidCallback? onClose;
  final Gradient headerGradient;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              decoration: BoxDecoration(gradient: headerGradient),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    child: Text(
                      profileInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roleLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          roleSubtitle,
                          style: const TextStyle(
                            color: Color(0xFFEAF2FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            Container(height: 1, color: const Color(0xFFF1F5F9)),
            const SizedBox(height: 6),
            ...items.map((item) => _SidebarItem(item: item)),
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
  const _SidebarItem({required this.item});

  final SidebarMenuItem item;

  @override
  Widget build(BuildContext context) {
    final bg = item.selected ? const Color(0xFFEFF6FF) : Colors.transparent;
    final fg = item.selected ? const Color(0xFF2F80FF) : const Color(0xFF374151);
    final iconColor =
        item.selected ? const Color(0xFF2F80FF) : const Color(0xFF6B7280);

    return Material(
      color: bg,
      child: InkWell(
        onTap: item.onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              Container(
                width: 4,
                color: item.selected ? const Color(0xFF2F80FF) : Colors.transparent,
              ),
              const SizedBox(width: 14),
              Icon(item.icon, color: iconColor),
              const SizedBox(width: 16),
              Text(
                item.title,
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
