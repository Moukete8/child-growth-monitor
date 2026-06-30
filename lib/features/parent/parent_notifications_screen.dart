import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/relative_time.dart';
import '../../data/local/app_database.dart';
import '../../data/local/notification_read_store.dart';
import '../../data/remote/supabase_client.dart';
import '../../data/repositories/alert_repository.dart';
import '../../data/repositories/child_repository.dart';
import '../../design_system/molecules/list_tiles.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class _AlertWithChild {
  const _AlertWithChild({
    required this.alert,
    required this.childName,
    required this.unread,
  });
  final AlertRow alert;
  final String childName;
  final bool unread;
}

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() =>
      _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  final _alertRepository = AlertRepository();
  final _childRepository = ChildRepository();
  final _readStore = NotificationReadStore();
  late Future<List<_AlertWithChild>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_AlertWithChild>> _load() async {
    final userId = AppSupabase.client.auth.currentUser?.id;
    final readIds = userId == null
        ? const <String>{}
        : await _readStore.readIds(userId);
    final alerts = await _alertRepository.alertsForCurrentParent();
    final out = <_AlertWithChild>[];
    for (final a in alerts) {
      final child = await _childRepository.childById(a.childId);
      out.add(
        _AlertWithChild(
          alert: a,
          childName: child?.name ?? 'Unknown child',
          unread: !readIds.contains(a.id),
        ),
      );
    }
    return out;
  }

  Future<void> _openAlert(_AlertWithChild item) async {
    final userId = AppSupabase.client.auth.currentUser?.id;
    if (userId != null) await _readStore.markRead(userId, item.alert.id);
    if (!mounted) return;
    await Navigator.of(
      context,
    ).pushNamed('/parent/child/${item.alert.childId}');
    if (!mounted) return;
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_AlertWithChild>>(
      future: _future,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <_AlertWithChild>[];
        return Column(
          children: [
            GradientHeader(
              role: Role.parent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('parent.notifications_screen.title'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tr('parent.notifications_screen.total', args: ['${items.length}']),
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xCCFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      tr('notifications.empty'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textFaint,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 11),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    final level = item.alert.level == 'severe'
                        ? RiskLevel.severe
                        : RiskLevel.moderate;
                    return NotificationTile(
                      icon: level == RiskLevel.severe
                          ? Icons.priority_high
                          : Icons.trending_down,
                      iconBg: level.backgroundColor,
                      iconColor: level.dotColor,
                      title: tr('parent.notifications_screen.alert_for', args: [item.childName]),
                      body: item.alert.message,
                      time: relativeTime(item.alert.createdAt),
                      unread: item.unread,
                      onTap: () => _openAlert(item),
                    );
                  },
                ),
            ),
          ],
        );
      },
    );
  }
}
