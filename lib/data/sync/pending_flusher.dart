/// Outcome of one [flushPending] pass: how many rows were pushed to
/// Supabase successfully vs. how many failed and stayed `pending`.
class SyncResult {
  const SyncResult({required this.pushed, required this.failed});
  final int pushed;
  final int failed;

  SyncResult operator +(SyncResult other) =>
      SyncResult(pushed: pushed + other.pushed, failed: failed + other.failed);

  static const zero = SyncResult(pushed: 0, failed: 0);
}

/// Generic push-side flush of locally `pending` rows of one table to
/// Supabase. Mirrors the try/insert/catch-fallback-to-pending shape already
/// used by every repository's write path, but as the reverse direction:
/// take what's stuck `pending` locally and retry it against the backend.
///
/// [upsert] is injected (rather than a concrete `SupabaseClient`) so this
/// function has no I/O dependencies of its own and can be unit-tested with
/// plain closures. Callers should pass an upsert (not a plain insert): a row
/// can be retried after a network failure that happened *after* the server
/// actually committed the previous attempt, and a plain insert would then
/// fail on the duplicate primary key.
Future<SyncResult> flushPending<T>({
  required Future<List<T>> Function() selectPending,
  required Map<String, dynamic> Function(T row) toSupabaseMap,
  required String supabaseTable,
  required Future<void> Function(T row) markSynced,
  required Future<void> Function(String table, Map<String, dynamic> data) upsert,
}) async {
  final rows = await selectPending();
  var pushed = 0;
  var failed = 0;
  for (final row in rows) {
    try {
      await upsert(supabaseTable, toSupabaseMap(row));
      await markSynced(row);
      pushed++;
    } catch (_) {
      // Leave it `pending` — it'll be retried on the next sync pass. No
      // max-attempt/backoff bookkeeping for this Palier 1 build.
      failed++;
    }
  }
  return SyncResult(pushed: pushed, failed: failed);
}
