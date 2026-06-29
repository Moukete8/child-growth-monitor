import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/age_format.dart';
import '../../core/utils/relative_time.dart';
import '../../core/utils/risk_mapping.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/molecules/child_card.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class _ChildWithLatest {
  const _ChildWithLatest({required this.child, required this.latest});
  final ChildRow child;
  final MeasurementRow? latest;
}

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final _authRepository = AuthRepository();
  final _childRepository = ChildRepository();
  final _measurementRepository = MeasurementRepository();
  late Future<({String name, List<_ChildWithLatest> children})> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<({String name, List<_ChildWithLatest> children})> _load() async {
    final profile = await _authRepository.cachedProfile();
    final children = await _childRepository.childrenForCurrentParent();
    final withLatest = <_ChildWithLatest>[];
    for (final child in children) {
      final history = await _measurementRepository.historyForChild(child.id);
      withLatest.add(_ChildWithLatest(child: child, latest: history.isEmpty ? null : history.first));
    }
    return (name: profile?.fullName.split(' ').first ?? 'there', children: withLatest);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final name = snapshot.data?.name ?? '…';
        final children = snapshot.data?.children ?? const <_ChildWithLatest>[];

        return RoleScaffold(
          role: Role.parent,
          currentNavIndex: 0,
          onNavTap: (i) => _navigate(context, i),
          header: GradientHeader(
            role: Role.parent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: AppColors.accentCoral, size: 19),
                    const SizedBox(width: 7),
                    Text(tr('parent.dashboard.role_label'), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    HeaderIconButton(icon: Icons.notifications_outlined, showDot: true, onPressed: () {
                      Navigator.of(context).pushNamed('/parent/notifications');
                    }),
                  ],
                ),
                const SizedBox(height: 18),
                Text(tr('parent.dashboard.greeting', args: [name]),
                    style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            children: [
              Text(tr('parent.dashboard.your_children'),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
              const SizedBox(height: 11),
              if (!snapshot.hasData)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (children.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(tr('parent.dashboard.no_children'),
                      style: const TextStyle(color: AppColors.textFaint, fontSize: 13)),
                )
              else
                for (final c in children) ...[
                  ChildCard(
                    name: c.child.name,
                    avatarUrl: c.child.avatarUrl,
                    meta: '${formatAge(c.child.dateOfBirth)} · ${c.child.sex == 'male' ? tr('shared.sex.male') : tr('shared.sex.female')}',
                    metric: c.latest == null ? '—' : '${c.latest!.weightKg.toStringAsFixed(1)} kg',
                    lastUpdated: c.latest == null ? tr('parent.dashboard.no_data_yet') : relativeTime(c.latest!.takenAt),
                    level: c.latest == null
                        ? RiskLevel.normal
                        : riskLevelFor(worstClassification(
                            waz: c.latest!.waz ?? 0, haz: c.latest!.haz ?? 0, whz: c.latest!.whz ?? 0)),
                    badgeLabel: c.latest == null
                        ? tr('parent.dashboard.no_data_badge')
                        : riskLevelFor(worstClassification(
                                    waz: c.latest!.waz ?? 0, haz: c.latest!.haz ?? 0, whz: c.latest!.whz ?? 0)) ==
                                RiskLevel.normal
                            ? tr('parent.dashboard.healthy')
                            : tr('parent.dashboard.at_risk'),
                    onTap: () => Navigator.of(context)
                        .pushNamed('/parent/child/${c.child.id}')
                        .then((_) => setState(() { _future = _load(); })),
                  ),
                  const SizedBox(height: 12),
                ],
              OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed('/parent/link-child')
                    .then((_) => setState(() { _future = _load(); })),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7FAFB),
                  side: const BorderSide(color: Color(0xFFB9CBD1), style: BorderStyle.solid, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner, size: 20, color: AppColors.parentPrimary),
                    const SizedBox(width: 9),
                    Text(tr('parent.dashboard.link_another_child'),
                        style: const TextStyle(color: AppColors.parentPrimary, fontSize: 13.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(tr('parent.dashboard.quick_actions'),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
              const SizedBox(height: 11),
              Row(
                children: [
                  Expanded(child: _quickAction(context, Icons.monitor_heart_outlined, tr('parent.dashboard.growth_charts'),
                      AppColors.parentPrimary, '/parent/charts')),
                  const SizedBox(width: 11),
                  Expanded(child: _quickAction(context, Icons.eco_outlined, tr('parent.dashboard.recommendations'),
                      AppColors.riskNormalDot, '/parent/tips')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _quickAction(BuildContext context, IconData icon, String label, Color color, String route) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).pushNamed(route),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 9),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int i) {
    switch (i) {
      case 1:
        Navigator.of(context).pushNamed('/parent/charts');
      case 2:
        Navigator.of(context).pushNamed('/parent/tips');
      case 3:
        Navigator.of(context).pushNamed('/parent/notifications');
      case 4:
        Navigator.of(context).pushNamed('/parent/profile');
    }
  }
}
