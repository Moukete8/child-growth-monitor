import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'lms_table.dart';
import 'z_score_engine.dart';

/// Loads the bundled WHO LMS JSON tables into a [WhoZScoreEngine].
///
/// IMPORTANT: see `assets/who_tables/README.md`. The JSON files shipped in
/// this repository are placeholders with empty `rows` arrays — they must be
/// replaced with the official WHO Child Growth Standards LMS tables before
/// this engine can be trusted for any real measurement. Loading a table with
/// empty rows will throw when a Z-score is requested, by design, so the app
/// fails loudly instead of silently returning a wrong clinical result.
class WhoTableLoader {
  static const _files = {
    'weightForAge_male': 'assets/who_tables/weight_for_age_boys.json',
    'weightForAge_female': 'assets/who_tables/weight_for_age_girls.json',
    'heightForAge_male': 'assets/who_tables/height_for_age_boys.json',
    'heightForAge_female': 'assets/who_tables/height_for_age_girls.json',
    'weightForHeight_male': 'assets/who_tables/weight_for_height_boys.json',
    'weightForHeight_female': 'assets/who_tables/weight_for_height_girls.json',
    'bmiForAge_male': 'assets/who_tables/bmi_for_age_boys.json',
    'bmiForAge_female': 'assets/who_tables/bmi_for_age_girls.json',
  };

  static Future<WhoZScoreEngine> load() async {
    final tables = <String, LmsTable>{};
    for (final entry in _files.entries) {
      final raw = await rootBundle.loadString(entry.value);
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final rows = decoded['rows'] as List<dynamic>;
      tables[entry.key] = LmsTable.fromJson(rows);
    }
    return WhoZScoreEngine(tables: tables);
  }
}
