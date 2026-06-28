import 'dart:math' as math;
import 'lms_table.dart';

enum Sex { male, female }

enum GrowthIndicator { weightForAge, heightForAge, weightForHeight, bmiForAge }

/// Pure-Dart, offline implementation of the WHO LMS method for converting a
/// raw anthropometric measurement into a Z-score.
///
/// Formula (WHO Multicentre Growth Reference Study technical documentation):
///   Z = (((X / M) ^ L) - 1) / (L * S)   when L != 0
///   Z = ln(X / M) / S                    when L == 0
///
/// This class only does arithmetic; it does not know where the L/M/S values
/// come from. Tables are injected via [WhoZScoreEngine.tables] so they can be
/// swapped for the official WHO Child Growth Standards tables without
/// touching this logic.
class WhoZScoreEngine {
  WhoZScoreEngine({required this.tables});

  /// Keyed by `"${indicator.name}_${sex.name}"`, e.g. `"weightForAge_male"`.
  final Map<String, LmsTable> tables;

  double computeZScore({
    required GrowthIndicator indicator,
    required Sex sex,
    required double ageMonths,
    required double measurement,
    double? heightCm,
  }) {
    final table = tables['${indicator.name}_${sex.name}'];
    if (table == null) {
      throw StateError(
        'No LMS table loaded for $indicator/$sex. '
        'Load the official WHO Child Growth Standards table before computing scores.',
      );
    }
    // WHO indexes weight-for-height by the child's measured height/length
    // (cm), not by age — every other indicator here is age-indexed.
    final double lookupX;
    if (indicator == GrowthIndicator.weightForHeight) {
      if (heightCm == null) {
        throw ArgumentError('heightCm is required for GrowthIndicator.weightForHeight.');
      }
      lookupX = heightCm;
    } else {
      lookupX = ageMonths;
    }
    final lms = table.at(lookupX);
    if (lms.l == 0) {
      return math.log(measurement / lms.m) / lms.s;
    }
    return (math.pow(measurement / lms.m, lms.l) - 1) / (lms.l * lms.s);
  }

  /// Classifies a Z-score per WHO thresholds (the same -2 / -3 SD cutoffs
  /// used throughout the literature review for stunting/wasting/underweight).
  static ZClassification classify(double z) {
    if (z < -3) return ZClassification.severe;
    if (z < -2) return ZClassification.moderate;
    if (z > 3) return ZClassification.severeHigh;
    if (z > 2) return ZClassification.moderateHigh;
    return ZClassification.normal;
  }

  /// Converts a Z-score to a percentile (0-100) under the standard normal
  /// distribution, via the Abramowitz & Stegun 7.1.26 approximation of the
  /// normal CDF (accurate to ~1.5e-7 — plenty for a display percentile).
  static double percentileForZ(double z) {
    const b1 = 0.319381530;
    const b2 = -0.356563782;
    const b3 = 1.781477937;
    const b4 = -1.821255978;
    const b5 = 1.330274429;
    const p = 0.2316419;
    final az = z.abs();
    final t = 1 / (1 + p * az);
    final poly = t * (b1 + t * (b2 + t * (b3 + t * (b4 + t * b5))));
    final phiAz = 1 - (1 / math.sqrt(2 * math.pi)) * math.exp(-az * az / 2) * poly;
    final cdf = z >= 0 ? phiAz : 1 - phiAz;
    return cdf * 100;
  }
}

enum ZClassification { severe, moderate, normal, moderateHigh, severeHigh }
