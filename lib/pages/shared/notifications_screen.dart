import 'package:flutter/material.dart';

enum NotificationType { warning, info, success, message }

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String timeAgo;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isRead,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      message: message,
      timeAgo: timeAgo,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  final List<NotificationItem> initialItems;

  const NotificationsScreen({super.key, required this.initialItems});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List<NotificationItem>.from(widget.initialItems);
  }

  int get _unreadCount => _items.where((e) => !e.isRead).length;

  void _popWithResult() {
    Navigator.of(context).pop<List<NotificationItem>>(_items);
  }

  Color _accent(NotificationType t) {
    return switch (t) {
      NotificationType.warning => const Color(0xFFF97316),
      NotificationType.info => const Color(0xFF2F80FF),
      NotificationType.success => const Color(0xFF16A34A),
      NotificationType.message => const Color(0xFF9333EA),
    };
  }

  Color _bg(NotificationType t) {
    return switch (t) {
      NotificationType.warning => const Color(0xFFFFF7ED),
      NotificationType.info => const Color(0xFFEFF6FF),
      NotificationType.success => const Color(0xFFE9FBEF),
      NotificationType.message => const Color(0xFFF5F3FF),
    };
  }

  IconData _icon(NotificationType t) {
    return switch (t) {
      NotificationType.warning => Icons.error_outline,
      NotificationType.info => Icons.info_outline,
      NotificationType.success => Icons.check_circle_outline,
      NotificationType.message => Icons.chat_bubble_outline,
    };
  }

  void _markAllRead() {
    setState(() {
      _items = _items.map((e) => e.copyWith(isRead: true)).toList(growable: false);
    });
  }

  void _markRead(String id) {
    setState(() {
      _items = _items
          .map((e) => e.id == id ? e.copyWith(isRead: true) : e)
          .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _popWithResult();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2F80FF), Color(0xFF1E5BFF)],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.notifications_none_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notifikasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_unreadCount belum dibaca',
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
                      onPressed: _popWithResult,
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      splashRadius: 22,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return _NotificationCard(
                      item: item,
                      accent: _accent(item.type),
                      bg: _bg(item.type),
                      icon: _icon(item.type),
                      onTap: () => _markRead(item.id),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: InkWell(
                  onTap: _markAllRead,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: Text(
                        'Tandai Semua Sudah Dibaca',
                        style: TextStyle(
                          color: _unreadCount == 0
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF2F80FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final Color accent;
  final Color bg;
  final IconData icon;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.accent,
    required this.bg,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F80FF),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B5563),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
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
    );
  }
}
