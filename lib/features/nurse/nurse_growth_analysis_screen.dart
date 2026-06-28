import 'package:flutter/material.dart';
import '../../core/utils/age_format.dart';
import '../../core/utils/risk_mapping.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/risk_badge.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/organisms/growth_chart.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../who_growth/z_score_engine.dart';

class NurseGrowthAnalysisScreen extends StatefulWidget {
  const NurseGrowthAnalysisScreen({super.key, required this.childId});

  final String childId;

  @override
  State<NurseGrowthAnalysisScreen> createState() => _NurseGrowthAnalysisScreenState();
}

class _NurseGrowthAnalysisScreenState extends State<NurseGrowthAnalysisScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            GradientHeader(
              role: Role.nurse,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Row(
                children: [
                  HeaderIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                  const SizedBox(width: 14),
                  const Text('Growth Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final child = snapshot.data!.child;
                  final history = snapshot.data!.history;
                  if (child == null) {
                    return const Center(child: Text('Child not found.'));
                  }
                  if (history.isEmpty) {
                    return const Center(child: Text('No measurements recorded yet.'));
                  }
                  final latest = history.first; // historyForChild orders desc by takenAt
                  final classification =
                      worstClassification(waz: latest.waz ?? 0, haz: latest.haz ?? 0, whz: latest.whz ?? 0);
                  final level = riskLevelFor(classification);
                  final label = switch (classification) {
                    ZClassification.severe => 'Severe malnutrition',
                    ZClassification.moderate => 'Moderate malnutrition',
                    _ => 'Normal growth',
                  };

                  final series = history.reversed
                      .map((m) => GrowthPoint(
                            label: formatAge(child.dateOfBirth, at: m.takenAt),
                            value: m.waz ?? 0,
                            status: riskLevelFor(WhoZScoreEngine.classify(m.waz ?? 0)),
                          ))
                      .toList();

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                const Text('BMI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                                const SizedBox(height: 2),
                                Text((latest.bmi ?? 0).toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.1)),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Container(width: 1, height: 42, color: AppColors.borderSubtle),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('WHO classification', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                                  const SizedBox(height: 5),
                                  RiskBadge(level: level, label: label),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          ZScoreBox(label: 'Weight-Height', value: _fmt(latest.whz), color: _colorFor(latest.whz)),
                          const SizedBox(width: 9),
                          ZScoreBox(label: 'Height-Age', value: _fmt(latest.haz), color: _colorFor(latest.haz)),
                          const SizedBox(width: 9),
                          ZScoreBox(label: 'Weight-Age', value: _fmt(latest.waz), color: _colorFor(latest.waz)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      GrowthChart(
                        title: 'Weight-for-Age',
                        unit: 'Z-score · WHO standard',
                        seriesByRange: {'All': series},
                        yMin: -4,
                        yMax: 4,
                        yTicks: const [-2, 0, 2],
                        bands: kWhoZScoreBands,
                        accent: AppColors.nursePrimary,
                        initialRange: 'All',
                      ),
                      const SizedBox(height: 14),
                      if (classification != ZClassification.normal)
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: classification == ZClassification.severe ? AppColors.riskSevereBg : AppColors.riskModerateBg,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.medical_information_outlined, size: 19,
                                      color: classification == ZClassification.severe ? AppColors.riskSevereText : AppColors.riskModerateText),
                                  const SizedBox(width: 8),
                                  Text('Recommended action',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                                          color: classification == ZClassification.severe ? AppColors.riskSevereText : AppColors.riskModerateText)),
                                ],
                              ),
                              const SizedBox(height: 9),
                              ...(classification == ZClassification.severe
                                      ? const ['Refer to hospital nutritionist within 48 hours.', 'Begin therapeutic high-energy feeding (RUTF).']
                                      : const ['Schedule a follow-up measurement within 2 weeks.', 'Counsel caregiver on feeding practices.'])
                                  .map((t) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.arrow_right_alt, size: 17, color: Color(0xFF7A2F29)),
                                            const SizedBox(width: 7),
                                            Expanded(child: Text(t, style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A2F29), height: 1.5))),
                                          ],
                                        ),
                                      )),
                            ],
                          ),
                        ),
                      const SizedBox(height: 14),
                      AppButton(
                        label: 'Generate Report',
                        icon: Icons.description_outlined,
                        color: AppColors.nursePrimary,
                        onPressed: () => Navigator.of(context).pushNamed('/nurse/reports'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
}
