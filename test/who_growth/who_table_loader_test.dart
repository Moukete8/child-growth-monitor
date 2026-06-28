import 'package:flutter_test/flutter_test.dart';
import 'package:child_growth_monitor/who_growth/who_table_loader.dart';
import 'package:child_growth_monitor/who_growth/z_score_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the real WHO tables and reproduces known reference points', () async {
    final engine = await WhoTableLoader.load();

    // Boy, birth, weight at the WHO median (M=3.3464kg) -> Z should be ~0.
    final wazAtBirth = engine.computeZScore(
      indicator: GrowthIndicator.weightForAge,
      sex: Sex.male,
      ageMonths: 0,
      measurement: 3.3464,
    );
    expect(wazAtBirth, closeTo(0, 1e-3));

    // Boy, 60 months, weight at the WHO median (M=18.3366kg) -> Z should be ~0.
    final wazAt5y = engine.computeZScore(
      indicator: GrowthIndicator.weightForAge,
      sex: Sex.male,
      ageMonths: 60,
      measurement: 18.3366,
    );
    expect(wazAt5y, closeTo(0, 1e-3));

    // Weight-for-height is indexed by height (cm), not age.
    final whz = engine.computeZScore(
      indicator: GrowthIndicator.weightForHeight,
      sex: Sex.female,
      ageMonths: 999, // irrelevant for this indicator
      heightCm: 65,
      measurement: engine.tables['weightForHeight_female']!.at(65).m,
    );
    expect(whz, closeTo(0, 1e-3));
  });
}
