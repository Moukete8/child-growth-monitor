import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../remote/supabase_client.dart';

/// Creates and resolves the alerts a nurse sees when a measurement comes
/// back moderate/severe, and that a linked parent sees too.
class AlertRepository {
  AlertRepository({SupabaseClient? client, AppDatabase? db})
      : _client = client ?? AppSupabase.client,
        _db = db ?? appDatabase;

  final SupabaseClient _client;
  final AppDatabase _db;
  final _uuid = const Uuid();

  Future<AlertRow> raiseAlert({
    required String childId,
    required String level, // 'moderate' | 'severe'
    required String message,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    var syncStatus = SyncStatus.synced;
    try {
      await _client.from('alerts').insert({
        'id': id,
        'child_id': childId,
        'level': level,
        'message': message,
      });
    } catch (_) {
      syncStatus = SyncStatus.pending;
    }
    final row = AlertRow(
      id: id,
      childId: childId,
      level: level,
      message: message,
      createdAt: now,
      resolved: false,
      syncStatus: syncStatus,
    );
    await _db.into(_db.alerts).insertOnConflictUpdate(row.toCompanion(false));
    return row;
  }

  Future<void> resolveAlert(String id) async {
    try {
      await _client.from('alerts').update({'resolved': true}).eq('id', id);
    } catch (_) {
      // Will read back as unresolved next pull until the device is back
      // online — no local "pending update" tracking yet for this field.
    }
    await (_db.update(_db.alerts)..where((a) => a.id.equals(id)))
        .write(const AlertsCompanion(resolved: Value(true)));
  }

  Future<List<AlertRow>> alertsForCurrentNurse() async {
    final nurseId = _client.auth.currentUser?.id;
    if (nurseId == null) return [];
    await _pull(registeredByNurseId: nurseId);
    final childIds = await (_db.select(_db.children)
          ..where((c) => c.registeredByNurseId.equals(nurseId)))
        .map((c) => c.id)
        .get();
    if (childIds.isEmpty) return [];
    return (_db.select(_db.alerts)
          ..where((a) => a.childId.isIn(childIds))
          ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]))
        .get();
  }

  Future<List<AlertRow>> alertsForChild(String childId) =>
      (_db.select(_db.alerts)
            ..where((a) => a.childId.equals(childId))
            ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]))
          .get();

  Future<void> _pull({required String registeredByNurseId}) async {
    try {
      final childIds = await (_db.select(_db.children)
            ..where((c) => c.registeredByNurseId.equals(registeredByNurseId)))
          .map((c) => c.id)
          .get();
      if (childIds.isEmpty) return;
      final rows = await _client.from('alerts').select().inFilter('child_id', childIds);
      for (final r in rows) {
        await _db.into(_db.alerts).insertOnConflictUpdate(
              AlertRow(
                id: r['id'] as String,
                childId: r['child_id'] as String,
                level: r['level'] as String,
                message: r['message'] as String,
                createdAt: DateTime.parse(r['created_at'] as String),
                resolved: r['resolved'] as bool,
                syncStatus: SyncStatus.synced,
              ).toCompanion(false),
            );
      }
    } catch (_) {
      // Offline — fall back to whatever is already cached locally.
    }
  }
}
