import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.profileInitial,
    required this.onOpenMenu,
    required this.onOpenNotifications,
    required this.onOpenProfile,
    this.showNotificationDot = false,
  });

  final String title;
  final String subtitle;
  final String profileInitial;
  final VoidCallback onOpenMenu;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenProfile;
  final bool showNotificationDot;

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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
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
            if (showNotificationDot)
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
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF2F80FF),
            child: Text(
              profileInitial,
              style: const TextStyle(
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
