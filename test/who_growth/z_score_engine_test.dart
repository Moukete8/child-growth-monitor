import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:child_growth_monitor/who_growth/lms_table.dart';
import 'package:child_growth_monitor/who_growth/z_score_engine.dart';

void main() {
  group('WhoZScoreEngine (formula correctness, synthetic fixtures — NOT real WHO data)', () {
    // These LMS values are made up purely to exercise the math. They must
    // never be confused with the official WHO tables (see
    // assets/who_tables/README.md).
    final engine = WhoZScoreEngine(tables: {
      'weightForAge_male': const LmsTable([
        LmsEntry(x: 0, l: 0.3, m: 3.3, s: 0.15),
        LmsEntry(x: 12, l: 0.1, m: 9.6, s: 0.12),
      ]),
      'heightForAge_male': const LmsTable([
        LmsEntry(x: 0, l: 0, m: 49.9, s: 0.04),
        LmsEntry(x: 12, l: 0, m: 75.7, s: 0.035),
      ]),
      // Indexed by height (cm), not age — matches the real WHO methodology
      // for weight-for-height (see lib/who_growth/z_score_engine.dart).
      'weightForHeight_male': const LmsTable([
        LmsEntry(x: 50, l: -0.35, m: 3.3, s: 0.09),
        LmsEntry(x: 100, l: -0.35, m: 15.5, s: 0.08),
      ]),
    });

    test('matches the hand-computed LMS formula when L != 0', () {
      const m = 3.3, l = 0.3, s = 0.15;
      const x = 3.6;
      final expected = (math.pow(x / m, l) - 1) / (l * s);

      final z = engine.computeZScore(
        indicator: GrowthIndicator.weightForAge,
        sex: Sex.male,
        ageMonths: 0,
        measurement: x,
      );

      expect(z, closeTo(expected, 1e-9));
    });

    test('falls back to the logarithmic form when L == 0', () {
      const m = 49.9, s = 0.04;
      const x = 51.0;
      final expected = math.log(x / m) / s;

      final z = engine.computeZScore(
        indicator: GrowthIndicator.heightForAge,
        sex: Sex.male,
        ageMonths: 0,
        measurement: x,
      );

      expect(z, closeTo(expected, 1e-9));
    });

    test('a measurement exactly at the median gives a Z-score of 0', () {
      final z = engine.computeZScore(
        indicator: GrowthIndicator.weightForAge,
        sex: Sex.male,
        ageMonths: 0,
        measurement: 3.3,
      );
      expect(z, closeTo(0, 1e-9));
    });

    test('interpolates L/M/S linearly between two tabulated ages', () {
      final table = engine.tables['weightForAge_male']!;
      final mid = table.at(6);
      expect(mid.m, closeTo((3.3 + 9.6) / 2, 1e-9));
    });

    test('weight-for-height looks up by height (cm), not age', () {
      const m = 3.3, l = -0.35, s = 0.09;
      const measurement = 3.5;
      final expected = (math.pow(measurement / m, l) - 1) / (l * s);

      final z = engine.computeZScore(
        indicator: GrowthIndicator.weightForHeight,
        sex: Sex.male,
        ageMonths: 999, // deliberately wrong/irrelevant — must be ignored
        heightCm: 50,
        measurement: measurement,
      );

      expect(z, closeTo(expected, 1e-9));
    });

    test('weight-for-height throws if heightCm is omitted', () {
      expect(
        () => engine.computeZScore(
          indicator: GrowthIndicator.weightForHeight,
          sex: Sex.male,
          ageMonths: 6,
          measurement: 7.0,
        ),
        throwsArgumentError,
      );
    });

    test('throws when asked for an indicator/sex with no loaded table', () {
      expect(
        () => engine.computeZScore(
          indicator: GrowthIndicator.bmiForAge,
          sex: Sex.female,
          ageMonths: 6,
          measurement: 7.0,
        ),
        throwsStateError,
      );
    });

    test('classify() applies the -2/-3 SD thresholds used in the literature review', () {
      expect(WhoZScoreEngine.classify(-3.5), ZClassification.severe);
      expect(WhoZScoreEngine.classify(-2.1), ZClassification.moderate);
      expect(WhoZScoreEngine.classify(0.0), ZClassification.normal);
      expect(WhoZScoreEngine.classify(2.5), ZClassification.moderateHigh);
      expect(WhoZScoreEngine.classify(3.5), ZClassification.severeHigh);
    });
  });
}
