import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

class GrowthPoint {
  const GrowthPoint({required this.label, required this.value, required this.status});
  final String label;
  final double value;
  final RiskLevel status;
}

class GrowthBand {
  const GrowthBand({required this.from, required this.to, required this.color});
  final double from;
  final double to;
  final Color color;
}

/// Fixed WHO Z-score risk bands (-3/-2/+2/+3 SD cutoffs). Age-invariant, so
/// the same bands apply to any age-indexed Z-score chart (WAZ/HAZ/WHZ).
const kWhoZScoreBands = [
  GrowthBand(from: -4, to: -3, color: AppColors.riskSevereBg),
  GrowthBand(from: -3, to: -2, color: AppColors.riskModerateBg),
  GrowthBand(from: -2, to: 2, color: AppColors.riskNormalBg),
  GrowthBand(from: 2, to: 3, color: AppColors.riskModerateBg),
  GrowthBand(from: 3, to: 4, color: AppColors.riskSevereBg),
];

/// Small "label / value" box used to show the latest WHZ/HAZ/WAZ Z-scores
/// side by side, colored by WHO risk classification.
class ZScoreBox extends StatelessWidget {
  const ZScoreBox({super.key, required this.label, required this.value, required this.color});
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
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

/// Organism: WHO growth curve chart with risk bands and a 6M/1Y/2Y range
/// selector. Mirrors the custom SVG renderer in GrowthChart.dc.html, using
/// fl_chart instead of hand-rolled SVG.
class GrowthChart extends StatefulWidget {
  const GrowthChart({
    super.key,
    required this.title,
    required this.unit,
    required this.seriesByRange,
    required this.yMin,
    required this.yMax,
    required this.yTicks,
    required this.bands,
    this.accent = AppColors.parentPrimary,
    this.initialRange = '1Y',
  });

  final String title;
  final String unit;
  final Map<String, List<GrowthPoint>> seriesByRange;
  final double yMin;
  final double yMax;
  final List<double> yTicks;
  final List<GrowthBand> bands;
  final Color accent;
  final String initialRange;

  @override
  State<GrowthChart> createState() => _GrowthChartState();
}

class _GrowthChartState extends State<GrowthChart> {
  late String _range = widget.initialRange;

  Color _dotColor(RiskLevel level) => level.dotColor;

  @override
  Widget build(BuildContext context) {
    final points = widget.seriesByRange[_range] ?? const <GrowthPoint>[];
    final ranges = widget.seriesByRange.keys.toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 3),
                    Text(widget.unit,
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Wrap(
                spacing: 6,
                children: ranges.map((r) {
                  final active = r == _range;
                  return GestureDetector(
                    onTap: () => setState(() => _range = r),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? widget.accent : AppColors.surface,
                        border: active ? null : Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        r,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 196,
            child: points.length < 2
                ? Center(
                    child: Text('Not enough data yet', style: TextStyle(color: AppColors.textMuted)))
                : LineChart(_chartData(points)),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 12),
          Row(
            children: [
              _legendDot(AppColors.riskNormalDot, 'Normal'),
              const SizedBox(width: 16),
              _legendDot(AppColors.riskModerateDot, 'Moderate'),
              const SizedBox(width: 16),
              _legendDot(AppColors.riskSevereDot, 'Severe'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
      ],
    );
  }

  LineChartData _chartData(List<GrowthPoint> points) {
    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].value),
    ];

    return LineChartData(
      minY: widget.yMin,
      maxY: widget.yMax,
      minX: 0,
      maxX: (points.length - 1).toDouble(),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      rangeAnnotations: RangeAnnotations(
        horizontalRangeAnnotations: [
          for (final b in widget.bands)
            HorizontalRangeAnnotation(y1: b.from, y2: b.to, color: b.color),
        ],
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: widget.yTicks.length > 1 ? (widget.yTicks[1] - widget.yTicks[0]) : null,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(0),
              style: TextStyle(fontSize: 9, color: AppColors.textFaint),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            getTitlesWidget: (value, meta) {
              final i = value.round();
              if (i < 0 || i >= points.length) return const SizedBox.shrink();
              return Text(points[i].label,
                  style: TextStyle(fontSize: 9, color: AppColors.textFaint));
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: widget.accent,
          barWidth: 2.4,
          belowBarData: BarAreaData(show: true, color: widget.accent.withValues(alpha: 0.08)),
          dotData: FlDotData(
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 4,
              color: Colors.white,
              strokeWidth: 2.4,
              strokeColor: _dotColor(points[index].status),
            ),
          ),
        ),
      ],
    );
  }
}
