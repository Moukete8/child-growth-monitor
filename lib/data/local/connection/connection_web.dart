import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Web implementation — dart:ffi/dart:io aren't available on web, so the
/// local database runs through sqlite3 compiled to WebAssembly instead.
/// Requires web/sqlite3.wasm and web/drift_worker.dart.js (see README in
/// that folder for how those were generated).
DatabaseConnection openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'child_growth',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );
    return DatabaseConnection(result.resolvedExecutor);
  }));
}
