import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/age_format.dart';
import '../../core/utils/risk_mapping.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/organisms/growth_chart.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../who_growth/z_score_engine.dart';

const _monthAbbr = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
String _shortMonth(DateTime d) => _monthAbbr[d.month - 1];

class ParentGrowthChartsScreen extends StatefulWidget {
  const ParentGrowthChartsScreen({super.key});

  @override
  State<ParentGrowthChartsScreen> createState() => _ParentGrowthChartsScreenState();
}

class _ParentGrowthChartsScreenState extends State<ParentGrowthChartsScreen> {
  final _childRepository = ChildRepository();
  late Future<List<ChildRow>> _childrenFuture;
  String? _selectedChildId;

  @override
  void initState() {
    super.initState();
    _childrenFuture = _loadChildren();
  }

  Future<List<ChildRow>> _loadChildren() async {
    final children = await _childRepository.childrenForCurrentParent();
    if (children.isNotEmpty) _selectedChildId ??= children.first.id;
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChildRow>>(
      future: _childrenFuture,
      builder: (context, snapshot) {
        final children = snapshot.data ?? const <ChildRow>[];
        final selected = children.isEmpty
            ? null
            : children.firstWhere((c) => c.id == _selectedChildId, orElse: () => children.first);

        return Column(
          children: [
            GradientHeader(
              role: Role.parent,
              child: Row(
                children: [
                  Expanded(
                    child: Text(tr('parent.charts.title'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  if (selected != null)
                    _ChildPicker(
                      children: children,
                      selected: selected,
                      onChanged: (id) => setState(() => _selectedChildId = id),
                    ),
                ],
              ),
            ),
            Expanded(
              child: !snapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : selected == null
                      ? _emptyState(context)
                      : _ChartsBody(key: ValueKey(selected.id), child: selected),
            ),
          ],
        );
      },
    );
  }

  Widget _emptyState(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 40),
        Center(
          child: Text(tr('parent.charts.no_children'),
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.textFaint, fontSize: 13.5)),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: tr('parent.charts.link_a_child'),
          onPressed: () => Navigator.of(context).pushNamed('/parent/link-child'),
        ),
      ],
    );
  }
}

class _ChildPicker extends StatelessWidget {
  const _ChildPicker({required this.children, required this.selected, required this.onChanged});
  final List<ChildRow> children;
  final ChildRow selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        color: const Color(0xFFF7FAFB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.child_care, size: 16, color: AppColors.parentPrimary),
          const SizedBox(width: 6),
          Text(selected.name.split(' ').first,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          if (children.length > 1) Icon(Icons.expand_more, size: 16, color: AppColors.textFaint),
        ],
      ),
    );
    if (children.length <= 1) return content;
    return PopupMenuButton<String>(
      initialValue: selected.id,
      onSelected: onChanged,
      itemBuilder: (context) =>
          children.map((c) => PopupMenuItem<String>(value: c.id, child: Text(c.name))).toList(),
      child: content,
    );
  }
}

class _ChartsBody extends StatefulWidget {
  const _ChartsBody({super.key, required this.child});
  final ChildRow child;

  @override
  State<_ChartsBody> createState() => _ChartsBodyState();
}

class _ChartsBodyState extends State<_ChartsBody> {
  final _measurementRepository = MeasurementRepository();
  late Future<List<MeasurementRow>> _future;

  @override
  void initState() {
    super.initState();
    _future = _measurementRepository.historyForChild(widget.child.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MeasurementRow>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final history = snapshot.data!; // historyForChild orders desc by takenAt
        if (history.isEmpty) {
          return Center(
            child: Text(tr('parent.charts.no_measurements', args: [widget.child.name]),
                style: TextStyle(color: AppColors.textFaint, fontSize: 13.5)),
          );
        }

        final seriesByRange = {
          '6M': _pointsUpTo(history, 6),
          '1Y': _pointsUpTo(history, 12),
          '2Y': _pointsUpTo(history, 24),
        };
        final latest = history.first;
        final previous = history.length > 1 ? history[1] : null;
        final classification =
            worstClassification(waz: latest.waz ?? 0, haz: latest.haz ?? 0, whz: latest.whz ?? 0);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GrowthChart(
              title: tr('parent.charts.weight_for_age'),
              unit: tr('parent.charts.z_score_unit'),
              seriesByRange: seriesByRange,
              yMin: -4,
              yMax: 4,
              yTicks: const [-2, 0, 2],
              bands: kWhoZScoreBands,
              accent: AppColors.parentPrimary,
            ),
            const SizedBox(height: 14),
            GrowthChart(
              title: tr('parent.charts.height_for_age'),
              unit: tr('parent.charts.z_score_unit'),
              seriesByRange: {
                '6M': _hazPointsUpTo(history, 6),
                '1Y': _hazPointsUpTo(history, 12),
                '2Y': _hazPointsUpTo(history, 24),
              },
              yMin: -4,
              yMax: 4,
              yTicks: const [-2, 0, 2],
              bands: kWhoZScoreBands,
              accent: AppColors.parentPrimary,
            ),
            const SizedBox(height: 14),
            GrowthChart(
              title: tr('parent.charts.weight_for_height'),
              unit: tr('parent.charts.z_score_unit'),
              seriesByRange: {
                '6M': _whzPointsUpTo(history, 6),
                '1Y': _whzPointsUpTo(history, 12),
                '2Y': _whzPointsUpTo(history, 24),
              },
              yMin: -4,
              yMax: 4,
              yTicks: const [-2, 0, 2],
              bands: kWhoZScoreBands,
              accent: AppColors.parentPrimary,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                ZScoreBox(label: tr('parent.charts.weight_height'), value: _fmt(latest.whz), color: _colorFor(latest.whz)),
                const SizedBox(width: 9),
                ZScoreBox(label: tr('parent.charts.height_age'), value: _fmt(latest.haz), color: _colorFor(latest.haz)),
                const SizedBox(width: 9),
                ZScoreBox(label: tr('parent.charts.weight_age'), value: _fmt(latest.waz), color: _colorFor(latest.waz)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _StatCard(
                  label: tr('parent.charts.latest'),
                  value: '${latest.weightKg.toStringAsFixed(1)} kg',
                  sub: previous == null ? tr('parent.charts.first_measurement') : _deltaLabel(latest, previous),
                  subColor: previous == null
                      ? AppColors.textMuted
                      : (latest.weightKg >= previous.weightKg ? AppColors.riskNormalDot : AppColors.riskModerateDot),
                ),
                const SizedBox(width: 10),
                _StatCard(
                  label: tr('parent.charts.who_percentile'),
                  value: '${WhoZScoreEngine.percentileForZ(latest.waz ?? 0).round()}th',
                  sub: classification == ZClassification.normal ? tr('parent.charts.within_normal_range') : tr('parent.charts.needs_attention'),
                  subColor: classification == ZClassification.normal ? AppColors.textMuted : AppColors.riskModerateDot,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _infoBanner(context, classification),
          ],
        );
      },
    );
  }

  List<GrowthPoint> _pointsUpTo(List<MeasurementRow> history, int maxMonths) {
    final filtered =
        history.where((m) => ageInMonths(widget.child.dateOfBirth, m.takenAt) <= maxMonths).toList();
    return filtered.reversed
        .map((m) => GrowthPoint(
              label: formatAge(widget.child.dateOfBirth, at: m.takenAt),
              value: m.waz ?? 0,
              status: riskLevelFor(WhoZScoreEngine.classify(m.waz ?? 0)),
            ))
        .toList();
  }

  List<GrowthPoint> _hazPointsUpTo(List<MeasurementRow> history, int maxMonths) {
    final filtered =
        history.where((m) => ageInMonths(widget.child.dateOfBirth, m.takenAt) <= maxMonths).toList();
    return filtered.reversed
        .map((m) => GrowthPoint(
              label: formatAge(widget.child.dateOfBirth, at: m.takenAt),
              value: m.haz ?? 0,
              status: riskLevelFor(WhoZScoreEngine.classify(m.haz ?? 0)),
            ))
        .toList();
  }

  List<GrowthPoint> _whzPointsUpTo(List<MeasurementRow> history, int maxMonths) {
    final filtered =
        history.where((m) => ageInMonths(widget.child.dateOfBirth, m.takenAt) <= maxMonths).toList();
    return filtered.reversed
        .map((m) => GrowthPoint(
              label: formatAge(widget.child.dateOfBirth, at: m.takenAt),
              value: m.whz ?? 0,
              status: riskLevelFor(WhoZScoreEngine.classify(m.whz ?? 0)),
            ))
        .toList();
  }

  String _deltaLabel(MeasurementRow latest, MeasurementRow previous) {
    final diff = latest.weightKg - previous.weightKg;
    final sign = diff >= 0 ? '+' : '';
    return tr('parent.charts.since_month', args: [sign, diff.toStringAsFixed(1), _shortMonth(previous.takenAt)]);
  }

  String _fmt(double? z) => z == null ? '—' : z.toStringAsFixed(1);

  Color _colorFor(double? z) {
    if (z == null) return AppColors.textMuted;
    return switch (WhoZScoreEngine.classify(z)) {
      ZClassification.severe => AppColors.riskSevereText,
      ZClassification.moderate => AppColors.riskModerateText,
      _ => AppColors.riskNormalText,
    };
  }

  Widget _infoBanner(BuildContext context, ZClassification classification) {
    final name = widget.child.name.split(' ').first;
    final normal = classification == ZClassification.normal;
    final severe = classification == ZClassification.severe;
    final bg = normal ? AppColors.infoBg : (severe ? AppColors.riskSevereBg : AppColors.riskModerateBg);
    final fg = normal ? AppColors.infoText : (severe ? AppColors.riskSevereText : AppColors.riskModerateText);
    final text = normal
        ? tr('parent.charts.info_normal', args: [name])
        : tr('parent.charts.info_risk', args: [name, severe ? tr('parent.charts.severe') : tr('parent.charts.moderate')]);

    return GestureDetector(
      onTap: normal ? null : () => Navigator.of(context).pushNamed('/parent/child/${widget.child.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(normal ? Icons.info_outline : Icons.warning_amber_outlined, color: fg, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(fontSize: 12.5, color: fg, height: 1.5))),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.sub, required this.subColor});
  final String label;
  final String value;
  final String sub;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 3),
            Text(sub, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: subColor)),
          ],
        ),
      ),
    );
  }
}
