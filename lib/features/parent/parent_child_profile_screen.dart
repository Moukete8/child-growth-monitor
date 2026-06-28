import 'package:flutter/material.dart';
import '../../core/utils/age_format.dart';
import '../../core/utils/risk_mapping.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/risk_badge.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class ParentChildProfileScreen extends StatefulWidget {
  const ParentChildProfileScreen({super.key, required this.childId});

  final String childId;

  @override
  State<ParentChildProfileScreen> createState() => _ParentChildProfileScreenState();
}

class _ParentChildProfileScreenState extends State<ParentChildProfileScreen> {
  final _childRepository = ChildRepository();
  final _measurementRepository = MeasurementRepository();
  late Future<({ChildRow? child, List<MeasurementRow> history})> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<({ChildRow? child, List<MeasurementRow> history})> _load() async {
    final child = await _childRepository.childById(widget.childId);
    final history = await _measurementRepository.historyForChild(widget.childId);
    return (child: child, history: history);
  }

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final child = snapshot.data?.child;
        final history = snapshot.data?.history ?? const <MeasurementRow>[];
        final latest = history.isEmpty ? null : history.first;
        final level = latest == null
            ? RiskLevel.normal
            : riskLevelFor(worstClassification(waz: latest.waz ?? 0, haz: latest.haz ?? 0, whz: latest.whz ?? 0));

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
                          HeaderIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                          const Expanded(
                            child: Center(
                              child: Text('Child Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          HeaderIconButton(icon: Icons.ios_share, onPressed: () {}),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: Color(0x33FFFFFF),
                            child: Icon(Icons.child_care, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(child?.name ?? '…',
                                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: Colors.white)),
                                const SizedBox(height: 3),
                                Text(
                                  child == null
                                      ? ''
                                      : '${formatAge(child.dateOfBirth)} · ${child.sex == 'male' ? 'Male' : 'Female'} · Born ${_formatDate(child.dateOfBirth)}',
                                  style: const TextStyle(fontSize: 13, color: Color(0xD9FFFFFF)),
                                ),
                              ],
                            ),
                          ),
                          RiskBadge(level: level, label: level == RiskLevel.normal ? 'Healthy' : (level == RiskLevel.moderate ? 'Watch' : 'At Risk')),
                        ],
                      ),
                    ],
                  ),
          ),
          body: !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : child == null
                  ? const Center(child: Text('Child not found.'))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                      children: [
                                Row(
                                  children: [
                                    _MetricBox(label: 'BMI', value: latest == null ? '—' : (latest.bmi ?? 0).toStringAsFixed(1), color: AppColors.textPrimary),
                                    const SizedBox(width: 10),
                                    _MetricBox(
                                      label: 'Weight-Age Z',
                                      value: latest == null ? '—' : (latest.waz ?? 0).toStringAsFixed(1),
                                      color: level.dotColor,
                                    ),
                                    const SizedBox(width: 10),
                                    _MetricBox(
                                      label: 'Birth wt',
                                      value: child.birthWeightKg == null ? '—' : '${child.birthWeightKg!.toStringAsFixed(1)}kg',
                                      color: AppColors.textPrimary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        label: 'View Charts',
                                        icon: Icons.monitor_heart_outlined,
                                        onPressed: () => Navigator.of(context).pushNamed('/parent/charts'),
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    Expanded(
                                      child: AppButton(
                                        label: 'Tips',
                                        icon: Icons.eco_outlined,
                                        variant: AppButtonVariant.secondary,
                                        onPressed: () => Navigator.of(context).pushNamed('/parent/tips'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text('MEASUREMENT TIMELINE',
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
                                const SizedBox(height: 11),
                                if (history.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Text('No measurements yet.', style: TextStyle(color: AppColors.textFaint, fontSize: 13)),
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
                                        for (var i = 0; i < history.length; i++)
                                          _TimelineRow(
                                            value: '${history[i].weightKg.toStringAsFixed(1)} kg · ${history[i].heightCm.toStringAsFixed(0)} cm',
                                            date: _formatDate(history[i].takenAt),
                                            level: riskLevelFor(worstClassification(
                                                waz: history[i].waz ?? 0, haz: history[i].haz ?? 0, whz: history[i].whz ?? 0)),
                                            last: i == history.length - 1,
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
        );
      },
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

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.value,
    required this.date,
    required this.level,
    required this.last,
  });

  final String value;
  final String date;
  final RiskLevel level;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: last ? Colors.transparent : AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: level.dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(level == RiskLevel.normal ? 'Healthy' : (level == RiskLevel.moderate ? 'Watch' : 'At Risk'),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: level.dotColor)),
        ],
      ),
    );
  }
}
