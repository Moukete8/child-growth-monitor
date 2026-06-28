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
import '../../who_growth/z_score_engine.dart';

class NurseChildProfileScreen extends StatefulWidget {
  const NurseChildProfileScreen({super.key, required this.childId});

  final String childId;

  @override
  State<NurseChildProfileScreen> createState() => _NurseChildProfileScreenState();
}

class _NurseChildProfileScreenState extends State<NurseChildProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final child = snapshot.data?.child;
        final history = snapshot.data?.history ?? const <MeasurementRow>[];
        final latest = history.isEmpty ? null : history.first;
        final classification = latest == null
            ? ZClassification.normal
            : worstClassification(waz: latest.waz ?? 0, haz: latest.haz ?? 0, whz: latest.whz ?? 0);
        final level = riskLevelFor(classification);
        final label = switch (classification) {
          ZClassification.severe => 'Severe',
          ZClassification.moderate => 'Moderate',
          _ => 'Healthy',
        };

        return RoleScaffold(
          role: Role.nurse,
          currentNavIndex: 1,
          onNavTap: (i) => _navigate(context, i),
          header: GradientHeader(
                  role: Role.nurse,
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
                          HeaderIconButton(
                            icon: Icons.description_outlined,
                            onPressed: () => Navigator.of(context).pushNamed('/nurse/reports'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 31,
                            backgroundColor: Color(0x33FFFFFF),
                            child: Icon(Icons.child_care, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(child?.name ?? '…',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                                const SizedBox(height: 2),
                                Text(
                                  child == null
                                      ? ''
                                      : '${formatAge(child.dateOfBirth)} · ${child.sex == 'male' ? 'Male' : 'Female'} · Code: ${child.linkCode}',
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xD9FFFFFF)),
                                ),
                              ],
                            ),
                          ),
                          RiskBadge(level: level, label: label),
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      children: [
                                Row(
                                  children: [
                                    _MiniMetric(label: 'BMI', value: latest == null ? '—' : (latest.bmi ?? 0).toStringAsFixed(1), color: AppColors.textPrimary),
                                    const SizedBox(width: 9),
                                    _MiniMetric(label: 'WHZ', value: latest == null ? '—' : (latest.whz ?? 0).toStringAsFixed(1), color: AppColors.riskSevereText),
                                    const SizedBox(width: 9),
                                    _MiniMetric(label: 'WAZ', value: latest == null ? '—' : (latest.waz ?? 0).toStringAsFixed(1), color: AppColors.riskModerateText),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Text('MEASUREMENT HISTORY',
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
                                const SizedBox(height: 9),
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
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      children: [
                                        _headerRow(),
                                        for (var i = 0; i < history.length; i++)
                                          _dataRow(
                                            _formatDate(history[i].takenAt),
                                            history[i].weightKg.toStringAsFixed(1),
                                            history[i].heightCm.toStringAsFixed(0),
                                            history[i].muacCm?.toStringAsFixed(1) ?? '—',
                                            riskLevelFor(worstClassification(
                                                    waz: history[i].waz ?? 0, haz: history[i].haz ?? 0, whz: history[i].whz ?? 0))
                                                .dotColor,
                                            i == history.length - 1,
                                          ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        label: 'Measure',
                                        icon: Icons.add,
                                        color: AppColors.nursePrimary,
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed('/nurse/measure/${widget.childId}')
                                            .then((_) => setState(() { _future = _load(); })),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: AppButton(
                                        label: 'Charts',
                                        icon: Icons.monitor_heart_outlined,
                                        variant: AppButtonVariant.secondary,
                                        onPressed: () => Navigator.of(context).pushNamed('/nurse/analysis/${widget.childId}'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
        );
      },
    );
  }

  void _navigate(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.of(context).pushNamed('/nurse/dashboard');
      case 2:
        Navigator.of(context).pushNamed('/nurse/alerts');
      case 3:
        Navigator.of(context).pushNamed('/nurse/reports');
      case 4:
        Navigator.of(context).pushNamed('/nurse/settings');
    }
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}';
  }

  Widget _headerRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF7FAFB),
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 58, child: Text('DATE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.3))),
          Expanded(child: Text('WT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
          Expanded(child: Text('HT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
          Expanded(child: Text('MUAC', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
          SizedBox(width: 46, child: Text('STATUS', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
        ],
      ),
    );
  }

  Widget _dataRow(String date, String wt, String ht, String muac, Color statusColor, bool last) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: last ? Colors.transparent : AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          SizedBox(width: 58, child: Text(date, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted))),
          Expanded(child: Text(wt, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
          Expanded(child: Text(ht, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
          Expanded(child: Text(muac, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
          SizedBox(
            width: 46,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(width: 10, height: 10, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            const SizedBox(height: 3),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}
