import 'dart:math';
import 'dart:typed_data';
import 'package:drift/drift.dart' show Value;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../remote/supabase_client.dart';
import '../sync/pending_flusher.dart';

class ChildNotFoundException implements Exception {
  ChildNotFoundException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// A short, human-typeable code (and QR payload) used to link a child record
/// to a parent account without needing the parent's contact info up front.
String generateLinkCode() {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // no 0/O/1/I — ambiguous on a clinic form
  final rand = Random.secure();
  return List.generate(6, (_) => alphabet[rand.nextInt(alphabet.length)]).join();
}

/// Registers/links children and keeps the local drift cache in sync with
/// Supabase. Writes are online-first with an offline fallback: if the
/// network call fails, the row is still saved locally as `pending`, and
/// [pushPendingChildren] (driven by SyncService) flushes it once
/// connectivity returns.
class ChildRepository {
  ChildRepository({SupabaseClient? client, AppDatabase? db})
      : _client = client ?? AppSupabase.client,
        _db = db ?? appDatabase;

  final SupabaseClient _client;
  final AppDatabase _db;
  final _uuid = const Uuid();

  Future<ChildRow> registerChild({
    required String name,
    required DateTime dateOfBirth,
    required String sex, // 'male' | 'female'
    double? birthWeightKg,
    String? parentContact,
    Uint8List? avatarBytes,
  }) async {
    final nurseId = _client.auth.currentUser?.id;
    if (nurseId == null) {
      throw StateError('Must be signed in as a nurse to register a child.');
    }
    final id = _uuid.v4();
    final linkCode = generateLinkCode();
    var syncStatus = SyncStatus.synced;

    // A photo can only be set here (by the nurse) or later by the linked
    // parent — never edited by the nurse afterwards. Upload first so
    // avatar_url is part of the initial row, not a follow-up update (which
    // the parent-only RLS policy added in 0003_avatars.sql would reject for
    // a nurse anyway after creation).
    String? avatarUrl;
    if (avatarBytes != null) {
      final path = '$nurseId/child-$id.jpg';
      await _client.storage.from('avatars').uploadBinary(
            path,
            avatarBytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );
      avatarUrl = _client.storage.from('avatars').getPublicUrl(path);
    }

    try {
      await _client.from('children').insert({
        'id': id,
        'name': name,
        'date_of_birth': dateOfBirth.toIso8601String().split('T').first,
        'sex': sex,
        'birth_weight_kg': birthWeightKg,
        'registered_by_nurse_id': nurseId,
        'link_code': linkCode,
        'parent_contact': parentContact,
        'avatar_url': avatarUrl,
      });
    } catch (_) {
      syncStatus = SyncStatus.pending;
    }

    final row = ChildRow(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      sex: sex,
      birthWeightKg: birthWeightKg,
      parentUserId: null,
      registeredByNurseId: nurseId,
      linkCode: linkCode,
      parentContact: parentContact,
      avatarUrl: avatarUrl,
      syncStatus: syncStatus,
    );
    await _db.into(_db.children).insertOnConflictUpdate(row.toCompanion(false));
    return row;
  }

  /// Lets the linked parent change their child's avatar after registration
  /// — the one edit a parent is allowed to make to a child's record (see
  /// the RLS policy in supabase/migrations/0003_avatars.sql).
  Future<ChildRow> updateChildAvatarAsParent(String childId, Uint8List bytes, {required String contentType}) async {
    final parentId = _client.auth.currentUser?.id;
    if (parentId == null) {
      throw StateError('Must be signed in as a parent to update a child avatar.');
    }
    final path = '$parentId/child-$childId.jpg';
    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: true),
        );
    final url = _client.storage.from('avatars').getPublicUrl(path);
    await _client.from('children').update({'avatar_url': url}).eq('id', childId);

    final existing = await childById(childId);
    if (existing == null) {
      throw StateError('Child $childId not found locally after avatar update.');
    }
    final updated = existing.copyWith(avatarUrl: Value(url));
    await _db.into(_db.children).insertOnConflictUpdate(updated.toCompanion(false));
    return updated;
  }

  /// Looks up an unlinked child by [linkCode] and claims it for the
  /// currently signed-in parent.
  Future<ChildRow> linkChildByCode(String linkCode) async {
    final parentId = _client.auth.currentUser?.id;
    if (parentId == null) {
      throw StateError('Must be signed in as a parent to link a child.');
    }
    final normalized = linkCode.trim().toUpperCase();

    Map<String, dynamic>? found;
    try {
      found = await _client.from('children').select().eq('link_code', normalized).maybeSingle();
    } catch (_) {
      // Offline — fall back to whatever is already cached locally (e.g.
      // from a prior pull on this device). There's no way to discover a
      // child record this device has never seen without the network.
      final local =
          await (_db.select(_db.children)..where((c) => c.linkCode.equals(normalized))).getSingleOrNull();
      found = local == null ? null : _mapFromRow(local);
    }
    if (found == null) {
      throw ChildNotFoundException('No child found for code "$normalized".');
    }
    if (found['parent_user_id'] != null) {
      throw ChildNotFoundException('This child is already linked to a parent account.');
    }

    var syncStatus = SyncStatus.synced;
    try {
      await _client.from('children').update({'parent_user_id': parentId}).eq('id', found['id']);
    } catch (_) {
      syncStatus = SyncStatus.pending;
    }

    final row = _rowFromMap({...found, 'parent_user_id': parentId}, syncStatus: syncStatus);
    await _db.into(_db.children).insertOnConflictUpdate(row.toCompanion(false));
    return row;
  }

  Future<List<ChildRow>> childrenForCurrentNurse() async {
    final nurseId = _client.auth.currentUser?.id;
    if (nurseId == null) return [];
    await _pullChildrenForNurse(nurseId);
    return (_db.select(_db.children)..where((c) => c.registeredByNurseId.equals(nurseId))).get();
  }

  Future<List<ChildRow>> childrenForCurrentParent() async {
    final parentId = _client.auth.currentUser?.id;
    if (parentId == null) return [];
    await _pullChildrenForParent(parentId);
    return (_db.select(_db.children)..where((c) => c.parentUserId.equals(parentId))).get();
  }

  Future<ChildRow?> childById(String id) =>
      (_db.select(_db.children)..where((c) => c.id.equals(id))).getSingleOrNull();

  /// Pushes locally `pending` child rows (new registrations and link-code
  /// claims made while offline) to Supabase. Called by SyncService.
  Future<SyncResult> pushPendingChildren() => flushPending<ChildRow>(
        selectPending: () =>
            (_db.select(_db.children)..where((c) => c.syncStatus.equals(SyncStatus.pending))).get(),
        toSupabaseMap: _mapFromRow,
        supabaseTable: 'children',
        markSynced: (row) => (_db.update(_db.children)..where((c) => c.id.equals(row.id)))
            .write(const ChildrenCompanion(syncStatus: Value(SyncStatus.synced))),
        upsert: (table, data) => _client.from(table).upsert(data),
      );

  Future<void> _pullChildrenForNurse(String nurseId) async {
    try {
      final rows = await _client.from('children').select().eq('registered_by_nurse_id', nurseId);
      for (final r in rows) {
        await _db.into(_db.children).insertOnConflictUpdate(_rowFromMap(r).toCompanion(false));
      }
    } catch (_) {
      // Offline — fall back to whatever is already cached locally.
    }
  }

  Future<void> _pullChildrenForParent(String parentId) async {
    try {
      final rows = await _client.from('children').select().eq('parent_user_id', parentId);
      for (final r in rows) {
        await _db.into(_db.children).insertOnConflictUpdate(_rowFromMap(r).toCompanion(false));
      }
    } catch (_) {
      // Offline — fall back to whatever is already cached locally.
    }
  }

  ChildRow _rowFromMap(Map<String, dynamic> map, {String syncStatus = SyncStatus.synced}) => ChildRow(
        id: map['id'] as String,
        name: map['name'] as String,
        dateOfBirth: DateTime.parse(map['date_of_birth'] as String),
        sex: map['sex'] as String,
        birthWeightKg: (map['birth_weight_kg'] as num?)?.toDouble(),
        parentUserId: map['parent_user_id'] as String?,
        registeredByNurseId: map['registered_by_nurse_id'] as String?,
        linkCode: map['link_code'] as String,
        parentContact: map['parent_contact'] as String?,
        avatarUrl: map['avatar_url'] as String?,
        syncStatus: syncStatus,
      );

  Map<String, dynamic> _mapFromRow(ChildRow row) => {
        'id': row.id,
        'name': row.name,
        'date_of_birth': row.dateOfBirth.toIso8601String().split('T').first,
        'sex': row.sex,
        'birth_weight_kg': row.birthWeightKg,
        'registered_by_nurse_id': row.registeredByNurseId,
        'link_code': row.linkCode,
        'parent_contact': row.parentContact,
        'parent_user_id': row.parentUserId,
        'avatar_url': row.avatarUrl,
      };
}
