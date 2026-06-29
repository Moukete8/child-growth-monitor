import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/risk_mapping.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/atoms/stat_tile.dart';
import '../../design_system/molecules/list_tiles.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class _Activity {
  const _Activity({required this.childName, required this.text, required this.time});
  final String childName;
  final String text;
  final DateTime time;
}

class _DashboardData {
  const _DashboardData({
    required this.nurseName,
    required this.monitored,
    required this.atRisk,
    required this.critical,
    required this.activity,
  });
  final String nurseName;
  final int monitored;
  final int atRisk;
  final int critical;
  final List<_Activity> activity;
}

class NurseDashboardScreen extends StatefulWidget {
  const NurseDashboardScreen({super.key});

  @override
  State<NurseDashboardScreen> createState() => _NurseDashboardScreenState();
}

class _NurseDashboardScreenState extends State<NurseDashboardScreen> {
  final _authRepository = AuthRepository();
  final _childRepository = ChildRepository();
  final _measurementRepository = MeasurementRepository();
  late Future<_DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashboardData> _load() async {
    final profile = await _authRepository.cachedProfile();
    final children = await _childRepository.childrenForCurrentNurse();
    var atRisk = 0;
    var critical = 0;
    final activity = <_Activity>[];
    for (final child in children) {
      final history = await _measurementRepository.historyForChild(child.id);
      if (history.isNotEmpty) {
        final latest = history.first;
        final classification = worstClassification(waz: latest.waz ?? 0, haz: latest.haz ?? 0, whz: latest.whz ?? 0);
        if (riskLevelFor(classification) == RiskLevel.severe) {
          critical++;
        } else if (riskLevelFor(classification) == RiskLevel.moderate) {
          atRisk++;
        }
        activity.add(_Activity(childName: child.name, text: tr('nurse.dashboard.new_measurement'), time: latest.takenAt));
      } else {
        activity.add(_Activity(childName: child.name, text: tr('nurse.dashboard.registered_awaiting'), time: child.dateOfBirth));
      }
    }
    activity.sort((a, b) => b.time.compareTo(a.time));

    return _DashboardData(
      nurseName: profile?.fullName.split(' ').first ?? 'there',
      monitored: children.length,
      atRisk: atRisk,
      critical: critical,
      activity: activity.take(3).toList(),
    );
  }

  String _relativeTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(0, 59)}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardData>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        return RoleScaffold(
          role: Role.nurse,
          currentNavIndex: 0,
          onNavTap: (i) => _navigate(context, i),
          header: GradientHeader(
            role: Role.nurse,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medical_services_outlined, color: Color(0xFF7FB4D8), size: 19),
                    const SizedBox(width: 7),
                    Text(tr('nurse.dashboard.role_label'), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    const Icon(Icons.cloud_sync_outlined, color: Colors.white, size: 19),
                  ],
                ),
                const SizedBox(height: 18),
                Text(tr('nurse.dashboard.greeting', args: [data?.nurseName ?? '…']),
                    style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
              ],
            ),
          ),
          body: !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  children: [
                    Row(
                      children: [
                        StatTile(value: '${data!.monitored}', label: tr('nurse.dashboard.monitored'), tone: StatTone.brand),
                        const SizedBox(width: 10),
                        StatTile(value: '${data.atRisk}', label: tr('nurse.dashboard.at_risk'), tone: StatTone.moderate),
                        const SizedBox(width: 10),
                        StatTile(value: '${data.critical}', label: tr('nurse.dashboard.critical'), tone: StatTone.severe),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(tr('nurse.dashboard.quick_actions'),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
                    const SizedBox(height: 11),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 11,
                      childAspectRatio: 2.6,
                      children: [
                        _quickAction(context, Icons.search, tr('nurse.dashboard.search_child'), AppColors.nursePrimary, '/nurse/children'),
                        _quickAction(context, Icons.person_add_outlined, tr('nurse.dashboard.register_child'), AppColors.riskNormalDot, '/nurse/register'),
                        _quickAction(context, Icons.straighten_outlined, tr('nurse.dashboard.record_measure'), AppColors.parentPrimary, '/nurse/children'),
                        _quickAction(context, Icons.warning_amber_outlined, tr('nurse.dashboard.view_alerts'), AppColors.riskModerateDot, '/nurse/alerts'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(tr('nurse.dashboard.recent_activity'),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
                    const SizedBox(height: 11),
                    if (data.activity.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(tr('nurse.dashboard.no_activity'),
                            style: const TextStyle(color: AppColors.textFaint, fontSize: 13)),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < data.activity.length; i++) ...[
                              if (i > 0) const Divider(height: 1, color: AppColors.borderSubtle),
                              ActivityTile(
                                icon: Icons.add_chart,
                                iconBg: AppColors.infoBg,
                                iconColor: AppColors.parentPrimary,
                                name: data.activity[i].childName,
                                text: data.activity[i].text,
                                time: _relativeTime(data.activity[i].time),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _quickAction(BuildContext context, IconData icon, String label, Color color, String route) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).pushNamed(route).then((_) => setState(() { _future = _load(); })),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 23, color: color),
          const SizedBox(width: 11),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int i) {
    switch (i) {
      case 1:
        Navigator.of(context).pushNamed('/nurse/children');
      case 2:
        Navigator.of(context).pushNamed('/nurse/alerts');
      case 3:
        Navigator.of(context).pushNamed('/nurse/reports');
      case 4:
        Navigator.of(context).pushNamed('/nurse/settings');
    }
  }
}
