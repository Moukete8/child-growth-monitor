import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/age_format.dart';
import '../../core/utils/risk_mapping.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/atoms/risk_badge.dart';
import '../../design_system/molecules/avatar.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class _ChildSummary {
  const _ChildSummary({required this.child, required this.level});
  final ChildRow child;
  final RiskLevel level;
}

class NurseSearchScreen extends StatefulWidget {
  const NurseSearchScreen({super.key});

  @override
  State<NurseSearchScreen> createState() => _NurseSearchScreenState();
}

class _NurseSearchScreenState extends State<NurseSearchScreen> {
  String _query = '';
  final _childRepository = ChildRepository();
  final _measurementRepository = MeasurementRepository();
  late Future<List<_ChildSummary>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_ChildSummary>> _load() async {
    final children = await _childRepository.childrenForCurrentNurse();
    final summaries = <_ChildSummary>[];
    for (final child in children) {
      final history = await _measurementRepository.historyForChild(child.id);
      RiskLevel level = RiskLevel.normal;
      if (history.isNotEmpty) {
        final latest = history.first;
        level = riskLevelFor(worstClassification(waz: latest.waz ?? 0, haz: latest.haz ?? 0, whz: latest.whz ?? 0));
      }
      summaries.add(_ChildSummary(child: child, level: level));
    }
    return summaries;
  }

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: Role.nurse,
      currentNavIndex: 1,
      onNavTap: (i) => _navigate(context, i),
      header: GradientHeader(
        role: Role.nurse,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('nurse.search.title'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20, color: Colors.white.withValues(alpha: 0.75)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        hintText: tr('nurse.search.hint'),
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<_ChildSummary>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final q = _query.trim().toLowerCase();
          final all = snapshot.data!;
          final results = q.isEmpty
              ? all
              : all
                  .where((s) =>
                      s.child.name.toLowerCase().contains(q) || s.child.linkCode.toLowerCase().contains(q))
                  .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr('nurse.search.count', args: ['${results.length}']),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
                ],
              ),
              const SizedBox(height: 11),
              if (results.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(tr('nurse.search.empty'),
                        style: const TextStyle(color: AppColors.textFaint, fontSize: 13)),
                  ),
                ),
              for (final s in results) ...[
                Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () => Navigator.of(context).pushNamed('/nurse/child/${s.child.id}').then((_) {
                      setState(() { _future = _load(); });
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          AppAvatar(
                            imageUrl: s.child.avatarUrl,
                            fallbackIcon: Icons.child_care,
                            radius: 23,
                            backgroundColor: AppColors.background,
                            iconColor: AppColors.textFaint,
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.child.name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(tr('nurse.search.code_age', args: [s.child.linkCode, formatAge(s.child.dateOfBirth)]),
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          RiskBadge(level: s.level),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamed('/nurse/register').then((_) {
                  setState(() { _future = _load(); });
                }),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7FAFB),
                  side: const BorderSide(color: Color(0xFFB9CBD1)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add_outlined, size: 20, color: AppColors.nursePrimary),
                    const SizedBox(width: 9),
                    Text(tr('nurse.search.register_new'), style: const TextStyle(color: AppColors.nursePrimary, fontSize: 13.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = ['/nurse/dashboard', '/nurse/children', '/nurse/alerts', '/nurse/reports', '/nurse/settings'];
    if (i != 1) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
