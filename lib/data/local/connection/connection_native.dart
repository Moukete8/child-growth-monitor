import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native (Android/iOS/desktop) implementation — uses sqlite3 via dart:ffi.
DatabaseConnection openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'child_growth.sqlite'));
    return DatabaseConnection(NativeDatabase.createInBackground(file));
  }));
}
