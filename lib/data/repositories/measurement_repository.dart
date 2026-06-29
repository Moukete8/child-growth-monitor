import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../who_growth/engine_provider.dart';
import '../../who_growth/z_score_engine.dart';
import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../remote/supabase_client.dart';
import '../sync/pending_flusher.dart';
import 'alert_repository.dart';

/// Result of a measurement submission: the saved row plus the classification
/// of its worst (lowest) Z-score, so the UI can show a risk badge without
/// recomputing anything.
class MeasurementResult {
  const MeasurementResult({required this.row, required this.worstClassification});
  final MeasurementRow row;
  final ZClassification worstClassification;
}

int ageInMonths(DateTime dob, DateTime at) {
  var months = (at.year - dob.year) * 12 + (at.month - dob.month);
  if (at.day < dob.day) months -= 1;
  return months < 0 ? 0 : months;
}

/// Computes WHO Z-scores for a new measurement (weight-for-age,
/// height-for-age, weight-for-height) using the real WHO LMS tables, then
/// persists the row (drift first, Supabase online-first) and raises an
/// [AlertRepository] alert if any indicator is moderate/severe.
class MeasurementRepository {
  MeasurementRepository({SupabaseClient? client, AppDatabase? db, AlertRepository? alerts})
      : _client = client ?? AppSupabase.client,
        _db = db ?? appDatabase,
        _alerts = alerts ?? AlertRepository();

  final SupabaseClient _client;
  final AppDatabase _db;
  final AlertRepository _alerts;
  final _uuid = const Uuid();

  Future<MeasurementResult> addMeasurement({
    required ChildRow child,
    required double weightKg,
    required double heightCm,
    double? muacCm,
    double? headCircumferenceCm,
    DateTime? takenAt,
  }) async {
    final nurseId = _client.auth.currentUser?.id;
    if (nurseId == null) {
      throw StateError('Must be signed in as a nurse to record a measurement.');
    }
    final at = takenAt ?? DateTime.now();
    final sex = child.sex == 'male' ? Sex.male : Sex.female;
    final months = ageInMonths(child.dateOfBirth, at).toDouble();

    final engine = await whoZScoreEngine();
    final waz = engine.computeZScore(
      indicator: GrowthIndicator.weightForAge,
      sex: sex,
      ageMonths: months,
      measurement: weightKg,
    );
    final haz = engine.computeZScore(
      indicator: GrowthIndicator.heightForAge,
      sex: sex,
      ageMonths: months,
      measurement: heightCm,
    );
    final whz = engine.computeZScore(
      indicator: GrowthIndicator.weightForHeight,
      sex: sex,
      ageMonths: months,
      heightCm: heightCm,
      measurement: weightKg,
    );
    final bmi = weightKg / ((heightCm / 100) * (heightCm / 100));

    final id = _uuid.v4();
    var syncStatus = SyncStatus.synced;
    try {
      await _client.from('measurements').insert({
        'id': id,
        'child_id': child.id,
        'nurse_id': nurseId,
        'taken_at': at.toIso8601String(),
        'weight_kg': weightKg,
        'height_cm': heightCm,
        'muac_cm': muacCm,
        'head_circumference_cm': headCircumferenceCm,
        'bmi': bmi,
        'waz': waz,
        'haz': haz,
        'whz': whz,
      });
    } catch (_) {
      syncStatus = SyncStatus.pending;
    }

    final row = MeasurementRow(
      id: id,
      childId: child.id,
      nurseId: nurseId,
      takenAt: at,
      weightKg: weightKg,
      heightCm: heightCm,
      muacCm: muacCm,
      headCircumferenceCm: headCircumferenceCm,
      bmi: bmi,
      waz: waz,
      haz: haz,
      whz: whz,
      syncStatus: syncStatus,
    );
    await _db.into(_db.measurements).insertOnConflictUpdate(row.toCompanion(false));

    // Malnutrition screening only cares about the low tail (stunting,
    // wasting, underweight) — a high Z-score here is an overweight signal,
    // out of scope for this Palier 1 build.
    final classifications = [
      WhoZScoreEngine.classify(waz),
      WhoZScoreEngine.classify(haz),
      WhoZScoreEngine.classify(whz),
    ];
    final worst = classifications.contains(ZClassification.severe)
        ? ZClassification.severe
        : classifications.contains(ZClassification.moderate)
            ? ZClassification.moderate
            : ZClassification.normal;

    if (worst == ZClassification.severe || worst == ZClassification.moderate) {
      await _alerts.raiseAlert(
        childId: child.id,
        level: worst == ZClassification.severe ? 'severe' : 'moderate',
        message: _alertMessage(worst, waz: waz, haz: haz, whz: whz),
      );
    }

    return MeasurementResult(row: row, worstClassification: worst);
  }

  Future<List<MeasurementRow>> historyForChild(String childId) async {
    await _pullForChild(childId);
    return (_db.select(_db.measurements)
          ..where((m) => m.childId.equals(childId))
          ..orderBy([(m) => OrderingTerm.desc(m.takenAt)]))
        .get();
  }

  /// Pushes locally `pending` measurements (recorded while offline) to
  /// Supabase. Called by SyncService.
  Future<SyncResult> pushPendingMeasurements() => flushPending<MeasurementRow>(
        selectPending: () =>
            (_db.select(_db.measurements)..where((m) => m.syncStatus.equals(SyncStatus.pending))).get(),
        toSupabaseMap: (r) => {
          'id': r.id,
          'child_id': r.childId,
          'nurse_id': r.nurseId,
          'taken_at': r.takenAt.toIso8601String(),
          'weight_kg': r.weightKg,
          'height_cm': r.heightCm,
          'muac_cm': r.muacCm,
          'head_circumference_cm': r.headCircumferenceCm,
          'bmi': r.bmi,
          'waz': r.waz,
          'haz': r.haz,
          'whz': r.whz,
        },
        supabaseTable: 'measurements',
        markSynced: (row) => (_db.update(_db.measurements)..where((m) => m.id.equals(row.id)))
            .write(const MeasurementsCompanion(syncStatus: Value(SyncStatus.synced))),
        upsert: (table, data) => _client.from(table).upsert(data),
      );

  Future<void> _pullForChild(String childId) async {
    try {
      final rows = await _client.from('measurements').select().eq('child_id', childId);
      for (final r in rows) {
        await _db.into(_db.measurements).insertOnConflictUpdate(
              MeasurementRow(
                id: r['id'] as String,
                childId: r['child_id'] as String,
                nurseId: r['nurse_id'] as String,
                takenAt: DateTime.parse(r['taken_at'] as String),
                weightKg: (r['weight_kg'] as num).toDouble(),
                heightCm: (r['height_cm'] as num).toDouble(),
                muacCm: (r['muac_cm'] as num?)?.toDouble(),
                headCircumferenceCm: (r['head_circumference_cm'] as num?)?.toDouble(),
                bmi: (r['bmi'] as num?)?.toDouble(),
                waz: (r['waz'] as num?)?.toDouble(),
                haz: (r['haz'] as num?)?.toDouble(),
                whz: (r['whz'] as num?)?.toDouble(),
                syncStatus: SyncStatus.synced,
              ).toCompanion(false),
            );
      }
    } catch (_) {
      // Offline — fall back to whatever is already cached locally.
    }
  }

  String _alertMessage(ZClassification worst, {required double waz, required double haz, required double whz}) {
    final parts = <String>[];
    if (WhoZScoreEngine.classify(whz) == worst) parts.add('weight-for-height (wasting) Z=${whz.toStringAsFixed(2)}');
    if (WhoZScoreEngine.classify(waz) == worst) parts.add('weight-for-age (underweight) Z=${waz.toStringAsFixed(2)}');
    if (WhoZScoreEngine.classify(haz) == worst) parts.add('height-for-age (stunting) Z=${haz.toStringAsFixed(2)}');
    final label = worst == ZClassification.severe ? 'Severe' : 'Moderate';
    return '$label malnutrition risk — ${parts.join(', ')}.';
  }
}
