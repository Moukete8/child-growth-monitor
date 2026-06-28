import 'package:flutter/material.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/alert_repository.dart';
import '../../data/repositories/child_repository.dart';
import '../../design_system/molecules/list_tiles.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class _AlertWithChild {
  const _AlertWithChild({required this.alert, required this.childName});
  final AlertRow alert;
  final String childName;
}

class NurseAlertsScreen extends StatefulWidget {
  const NurseAlertsScreen({super.key});

  @override
  State<NurseAlertsScreen> createState() => _NurseAlertsScreenState();
}

class _NurseAlertsScreenState extends State<NurseAlertsScreen> {
  final _alertRepository = AlertRepository();
  final _childRepository = ChildRepository();
  late Future<List<_AlertWithChild>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_AlertWithChild>> _load() async {
    final alerts = await _alertRepository.alertsForCurrentNurse();
    final out = <_AlertWithChild>[];
    for (final a in alerts) {
      final child = await _childRepository.childById(a.childId);
      out.add(_AlertWithChild(alert: a, childName: child?.name ?? 'Unknown child'));
    }
    return out;
  }

  String _relativeTime(DateTime d) {
    final days = DateTime.now().difference(d).inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return '1 day';
    return '$days days';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_AlertWithChild>>(
      future: _future,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <_AlertWithChild>[];
        final openCount = items.where((a) => !a.alert.resolved).length;

        return RoleScaffold(
          role: Role.nurse,
          currentNavIndex: 2,
          onNavTap: (i) => _navigate(context, i),
          header: GradientHeader(
            role: Role.nurse,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Row(
              children: [
                const Expanded(child: Text('Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                  child: Text('$openCount active', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          body: !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
                  ? const Center(
                      child: Text('No alerts — every measured child is within normal range.',
                          textAlign: TextAlign.center, style: TextStyle(color: AppColors.textFaint, fontSize: 13)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                      itemCount: items.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(height: 11),
                      itemBuilder: (context, i) {
                        if (i == items.length) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('Tap an alert to open the child · check to resolve',
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, color: AppColors.textFaint)),
                          );
                        }
                        final item = items[i];
                        final level = item.alert.level == 'severe' ? RiskLevel.severe : RiskLevel.moderate;
                        return AlertTile(
                          icon: level == RiskLevel.severe ? Icons.priority_high : Icons.trending_down,
                          level: level,
                          name: item.childName,
                          text: item.alert.message,
                          time: _relativeTime(item.alert.createdAt),
                          resolved: item.alert.resolved,
                          onOpen: () => Navigator.of(context).pushNamed('/nurse/child/${item.alert.childId}'),
                          onResolve: () async {
                            await _alertRepository.resolveAlert(item.alert.id);
                            setState(() { _future = _load(); });
                          },
                        );
                      },
                    ),
        );
      },
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = ['/nurse/dashboard', '/nurse/children', '/nurse/alerts', '/nurse/reports', '/nurse/settings'];
    if (i != 2) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
