import '../../design_system/tokens/app_colors.dart';
import '../../who_growth/z_score_engine.dart';

/// Malnutrition screening only cares about the low tail of a Z-score
/// (stunting/wasting/underweight); a high Z-score (overweight) is mapped to
/// [RiskLevel.normal] since that's out of scope for this Palier 1 build.
RiskLevel riskLevelFor(ZClassification classification) {
  switch (classification) {
    case ZClassification.severe:
      return RiskLevel.severe;
    case ZClassification.moderate:
      return RiskLevel.moderate;
    case ZClassification.normal:
    case ZClassification.moderateHigh:
    case ZClassification.severeHigh:
      return RiskLevel.normal;
  }
}

/// Worst (lowest) classification across WAZ/HAZ/WHZ for one measurement.
ZClassification worstClassification({required double waz, required double haz, required double whz}) {
  final all = [WhoZScoreEngine.classify(waz), WhoZScoreEngine.classify(haz), WhoZScoreEngine.classify(whz)];
  if (all.contains(ZClassification.severe)) return ZClassification.severe;
  if (all.contains(ZClassification.moderate)) return ZClassification.moderate;
  return ZClassification.normal;
}
