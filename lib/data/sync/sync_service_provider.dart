import 'sync_service.dart';

/// Single shared SyncService for the whole app — mirrors the
/// `appDatabase` singleton pattern in `data/local/database_provider.dart`.
/// Starts listening for connectivity immediately; `main.dart` triggers
/// additional syncs on app resume and via the manual "Sync now" button.
final SyncService syncService = SyncService()..start();
