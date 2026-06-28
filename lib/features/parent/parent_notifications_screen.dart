import 'package:flutter/material.dart';
import '../../design_system/molecules/list_tiles.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class _Notif {
  _Notif(this.icon, this.iconBg, this.iconColor, this.title, this.body, this.time, this.unread);
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  bool unread;
}

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() => _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  final _notifs = [
    _Notif(Icons.monitor_weight_outlined, AppColors.infoBg, AppColors.parentPrimary, 'New measurement added',
        'Nurse Joy recorded Lucas · 12.6 kg', '2h ago', true),
    _Notif(Icons.event_outlined, AppColors.riskModerateBg, AppColors.riskModerateDot, 'Upcoming check-up',
        'Lucas · clinic visit on May 15', '1d ago', true),
    _Notif(Icons.vaccines_outlined, AppColors.riskNormalBg, AppColors.riskNormalDot, 'Vaccination reminder',
        'Amina · measles booster due', '2d ago', true),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifs.where((n) => n.unread).length;
    return RoleScaffold(
      role: Role.parent,
      currentNavIndex: 3,
      onNavTap: (i) => _navigate(context, i),
      header: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notifications',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text('$unreadCount unread', style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                for (final n in _notifs) {
                  n.unread = false;
                }
              }),
              icon: const Icon(Icons.done_all, color: AppColors.parentPrimary),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifs.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 11),
        itemBuilder: (context, i) {
          if (i == _notifs.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Tap a notification to mark it read · swipe to dismiss',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, color: AppColors.textFaint)),
            );
          }
          final n = _notifs[i];
          return NotificationTile(
            icon: n.icon,
            iconBg: n.iconBg,
            iconColor: n.iconColor,
            title: n.title,
            body: n.body,
            time: n.time,
            unread: n.unread,
            onTap: () => setState(() => n.unread = false),
          );
        },
      ),
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = ['/parent/dashboard', '/parent/charts', '/parent/tips', '/parent/notifications', '/parent/profile'];
    if (i != 3) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
