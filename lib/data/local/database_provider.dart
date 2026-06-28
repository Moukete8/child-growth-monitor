import 'app_database.dart';

/// Single shared drift connection for the whole app — drift's
/// [LazyDatabase] should not be opened more than once per process.
final AppDatabase appDatabase = AppDatabase();
