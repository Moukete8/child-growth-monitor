import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../repositories/alert_repository.dart';
import '../repositories/child_repository.dart';
import '../repositories/measurement_repository.dart';

/// Result of one full [SyncService.syncNow] pass, aggregated across all
/// three repositories, plus when it happened — for the "Sync now" /
/// "Offline data" status rows in the UI.
class SyncStatusSnapshot {
  const SyncStatusSnapshot({required this.pushed, required this.failed, required this.lastSyncedAt});
  final int pushed;
  final int failed;
  final DateTime? lastSyncedAt;
}

/// Coordinates flushing locally `pending` rows (children, measurements,
/// alerts) to Supabase once connectivity is available. This is push-only:
/// the pull side already happens for free, since every repository's read
/// method (childrenForCurrentNurse, historyForChild, alertsForCurrentNurse,
/// etc.) already pulls-then-merges from Supabase before returning local
/// rows.
class SyncService {
  SyncService({
    ChildRepository? children,
    MeasurementRepository? measurements,
    AlertRepository? alerts,
    Connectivity? connectivity,
  })  : _children = children ?? ChildRepository(),
        _measurements = measurements ?? MeasurementRepository(),
        _alerts = alerts ?? AlertRepository(),
        _connectivity = connectivity ?? Connectivity();

  final ChildRepository _children;
  final MeasurementRepository _measurements;
  final AlertRepository _alerts;
  final Connectivity _connectivity;

  bool _syncing = false;
  SyncStatusSnapshot _last = const SyncStatusSnapshot(pushed: 0, failed: 0, lastSyncedAt: null);
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final _statusController = StreamController<SyncStatusSnapshot>.broadcast();

  /// Emits every time a sync pass finishes (success or partial failure).
  Stream<SyncStatusSnapshot> get statusStream => _statusController.stream;
  SyncStatusSnapshot get lastStatus => _last;

  /// Starts listening for connectivity changes and triggers a sync as soon
  /// as the device comes back online. Call once, at app startup.
  void start() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        syncNow();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }

  /// Pushes all pending rows (children first, then measurements, then
  /// alerts — children must exist server-side before rows that reference
  /// them via a foreign key). Safe to call concurrently; a sync already in
  /// flight is reused rather than doubled up.
  Future<SyncStatusSnapshot> syncNow() async {
    if (_syncing) return _last;
    _syncing = true;
    try {
      final childrenResult = await _children.pushPendingChildren();
      final measurementsResult = await _measurements.pushPendingMeasurements();
      final alertsResult = await _alerts.pushPendingAlerts();
      final combined = childrenResult + measurementsResult + alertsResult;
      _last = SyncStatusSnapshot(
        pushed: combined.pushed,
        failed: combined.failed,
        lastSyncedAt: DateTime.now(),
      );
      _statusController.add(_last);
      return _last;
    } finally {
      _syncing = false;
    }
  }
}
