import 'package:drift/drift.dart';
import 'connection/connection.dart' as conn;

part 'app_database.g.dart';

/// Sync state for rows created/edited while offline. Measurements are
/// effectively append-only (never edited once submitted), so in practice
/// only `pending` -> `synced` is exercised for them; `children` can also
/// transition through this when a nurse edits a profile offline.
class SyncStatus {
  static const synced = 'synced';
  static const pending = 'pending';
  static const failed = 'failed';
}

@DataClassName('UserRow')
class Users extends Table {
  TextColumn get id => text()(); // Supabase auth UUID
  TextColumn get role => text()(); // 'parent' | 'nurse'
  TextColumn get fullName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get hospitalId => text().nullable()(); // nurse-only
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant(SyncStatus.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChildRow')
class Children extends Table {
  TextColumn get id => text()(); // client-generated UUID, also encoded in the QR code
  TextColumn get name => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get sex => text()(); // 'male' | 'female'
  RealColumn get birthWeightKg => real().nullable()();
  TextColumn get parentUserId => text().nullable().references(Users, #id)();
  TextColumn get registeredByNurseId => text().nullable().references(Users, #id)();
  TextColumn get linkCode => text()(); // short code/QR payload used to claim this child
  TextColumn get parentContact => text().nullable()(); // phone/email the nurse noted, reference only
  TextColumn get avatarUrl => text().nullable()(); // set once by the nurse at registration, changeable by the linked parent afterwards
  TextColumn get syncStatus => text().withDefault(const Constant(SyncStatus.pending))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MeasurementRow')
class Measurements extends Table {
  TextColumn get id => text()(); // client-generated UUID
  TextColumn get childId => text().references(Children, #id)();
  TextColumn get nurseId => text().references(Users, #id)();
  DateTimeColumn get takenAt => dateTime()();
  RealColumn get weightKg => real()();
  RealColumn get heightCm => real()();
  RealColumn get muacCm => real().nullable()();
  RealColumn get headCircumferenceCm => real().nullable()();

  // Computed at entry time by the offline WHO LMS engine, persisted so the
  // history view never needs to recompute or hit the network.
  RealColumn get bmi => real().nullable()();
  RealColumn get waz => real().nullable()();
  RealColumn get haz => real().nullable()();
  RealColumn get whz => real().nullable()();

  TextColumn get syncStatus => text().withDefault(const Constant(SyncStatus.pending))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AlertRow')
class Alerts extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text().references(Children, #id)();
  TextColumn get level => text()(); // 'moderate' | 'severe'
  TextColumn get message => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant(SyncStatus.pending))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Users, Children, Measurements, Alerts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(conn.openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        // Pre-release app, no real user data on any device yet — drop and
        // recreate rather than writing a real migration for each bump.
        onUpgrade: (m, from, to) async {
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
          }
          await m.createAll();
        },
      );
}
