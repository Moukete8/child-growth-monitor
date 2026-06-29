import 'package:child_growth_monitor/data/sync/pending_flusher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('flushPending', () {
    test('marks rows synced on success and leaves failures pending', () async {
      final synced = <String>[];
      final result = await flushPending<String>(
        selectPending: () async => ['a', 'b'],
        toSupabaseMap: (id) => {'id': id},
        supabaseTable: 'fake',
        markSynced: (id) async => synced.add(id),
        upsert: (table, data) async {
          if (data['id'] == 'b') throw Exception('offline');
        },
      );

      expect(result.pushed, 1);
      expect(result.failed, 1);
      expect(synced, ['a']);
    });

    test('pushes nothing when there are no pending rows', () async {
      final result = await flushPending<String>(
        selectPending: () async => [],
        toSupabaseMap: (id) => {'id': id},
        supabaseTable: 'fake',
        markSynced: (id) async {},
        upsert: (table, data) async {},
      );

      expect(result.pushed, 0);
      expect(result.failed, 0);
    });

    test('SyncResult addition aggregates pushed and failed counts', () {
      const a = SyncResult(pushed: 2, failed: 1);
      const b = SyncResult(pushed: 3, failed: 0);
      final combined = a + b;
      expect(combined.pushed, 5);
      expect(combined.failed, 1);
    });
  });
}
