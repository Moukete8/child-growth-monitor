// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hospitalIdMeta = const VerificationMeta(
    'hospitalId',
  );
  @override
  late final GeneratedColumn<String> hospitalId = GeneratedColumn<String>(
    'hospital_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatus.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    role,
    fullName,
    email,
    phone,
    hospitalId,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('hospital_id')) {
      context.handle(
        _hospitalIdMeta,
        hospitalId.isAcceptableOrUnknown(data['hospital_id']!, _hospitalIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      hospitalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hospital_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final String id;
  final String role;
  final String fullName;
  final String? email;
  final String? phone;
  final String? hospitalId;
  final String syncStatus;
  const UserRow({
    required this.id,
    required this.role,
    required this.fullName,
    this.email,
    this.phone,
    this.hospitalId,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['role'] = Variable<String>(role);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || hospitalId != null) {
      map['hospital_id'] = Variable<String>(hospitalId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      role: Value(role),
      fullName: Value(fullName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      hospitalId: hospitalId == null && nullToAbsent
          ? const Value.absent()
          : Value(hospitalId),
      syncStatus: Value(syncStatus),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      hospitalId: serializer.fromJson<String?>(json['hospitalId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'hospitalId': serializer.toJson<String?>(hospitalId),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  UserRow copyWith({
    String? id,
    String? role,
    String? fullName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> hospitalId = const Value.absent(),
    String? syncStatus,
  }) => UserRow(
    id: id ?? this.id,
    role: role ?? this.role,
    fullName: fullName ?? this.fullName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    hospitalId: hospitalId.present ? hospitalId.value : this.hospitalId,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      hospitalId: data.hospitalId.present
          ? data.hospitalId.value
          : this.hospitalId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('hospitalId: $hospitalId, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, role, fullName, email, phone, hospitalId, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.role == this.role &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.hospitalId == this.hospitalId &&
          other.syncStatus == this.syncStatus);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<String> id;
  final Value<String> role;
  final Value<String> fullName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> hospitalId;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.hospitalId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String role,
    required String fullName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.hospitalId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       role = Value(role),
       fullName = Value(fullName);
  static Insertable<UserRow> custom({
    Expression<String>? id,
    Expression<String>? role,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? hospitalId,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (hospitalId != null) 'hospital_id': hospitalId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? role,
    Value<String>? fullName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? hospitalId,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      hospitalId: hospitalId ?? this.hospitalId,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (hospitalId.present) {
      map['hospital_id'] = Variable<String>(hospitalId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('hospitalId: $hospitalId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChildrenTable extends Children with TableInfo<$ChildrenTable, ChildRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthWeightKgMeta = const VerificationMeta(
    'birthWeightKg',
  );
  @override
  late final GeneratedColumn<double> birthWeightKg = GeneratedColumn<double>(
    'birth_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentUserIdMeta = const VerificationMeta(
    'parentUserId',
  );
  @override
  late final GeneratedColumn<String> parentUserId = GeneratedColumn<String>(
    'parent_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _registeredByNurseIdMeta =
      const VerificationMeta('registeredByNurseId');
  @override
  late final GeneratedColumn<String> registeredByNurseId =
      GeneratedColumn<String>(
        'registered_by_nurse_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id)',
        ),
      );
  static const VerificationMeta _linkCodeMeta = const VerificationMeta(
    'linkCode',
  );
  @override
  late final GeneratedColumn<String> linkCode = GeneratedColumn<String>(
    'link_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentContactMeta = const VerificationMeta(
    'parentContact',
  );
  @override
  late final GeneratedColumn<String> parentContact = GeneratedColumn<String>(
    'parent_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatus.pending),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dateOfBirth,
    sex,
    birthWeightKg,
    parentUserId,
    registeredByNurseId,
    linkCode,
    parentContact,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'children';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('birth_weight_kg')) {
      context.handle(
        _birthWeightKgMeta,
        birthWeightKg.isAcceptableOrUnknown(
          data['birth_weight_kg']!,
          _birthWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('parent_user_id')) {
      context.handle(
        _parentUserIdMeta,
        parentUserId.isAcceptableOrUnknown(
          data['parent_user_id']!,
          _parentUserIdMeta,
        ),
      );
    }
    if (data.containsKey('registered_by_nurse_id')) {
      context.handle(
        _registeredByNurseIdMeta,
        registeredByNurseId.isAcceptableOrUnknown(
          data['registered_by_nurse_id']!,
          _registeredByNurseIdMeta,
        ),
      );
    }
    if (data.containsKey('link_code')) {
      context.handle(
        _linkCodeMeta,
        linkCode.isAcceptableOrUnknown(data['link_code']!, _linkCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_linkCodeMeta);
    }
    if (data.containsKey('parent_contact')) {
      context.handle(
        _parentContactMeta,
        parentContact.isAcceptableOrUnknown(
          data['parent_contact']!,
          _parentContactMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      birthWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_weight_kg'],
      ),
      parentUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_user_id'],
      ),
      registeredByNurseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registered_by_nurse_id'],
      ),
      linkCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_code'],
      )!,
      parentContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_contact'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ChildrenTable createAlias(String alias) {
    return $ChildrenTable(attachedDatabase, alias);
  }
}

class ChildRow extends DataClass implements Insertable<ChildRow> {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String sex;
  final double? birthWeightKg;
  final String? parentUserId;
  final String? registeredByNurseId;
  final String linkCode;
  final String? parentContact;
  final String syncStatus;
  const ChildRow({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.sex,
    this.birthWeightKg,
    this.parentUserId,
    this.registeredByNurseId,
    required this.linkCode,
    this.parentContact,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || birthWeightKg != null) {
      map['birth_weight_kg'] = Variable<double>(birthWeightKg);
    }
    if (!nullToAbsent || parentUserId != null) {
      map['parent_user_id'] = Variable<String>(parentUserId);
    }
    if (!nullToAbsent || registeredByNurseId != null) {
      map['registered_by_nurse_id'] = Variable<String>(registeredByNurseId);
    }
    map['link_code'] = Variable<String>(linkCode);
    if (!nullToAbsent || parentContact != null) {
      map['parent_contact'] = Variable<String>(parentContact);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ChildrenCompanion toCompanion(bool nullToAbsent) {
    return ChildrenCompanion(
      id: Value(id),
      name: Value(name),
      dateOfBirth: Value(dateOfBirth),
      sex: Value(sex),
      birthWeightKg: birthWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(birthWeightKg),
      parentUserId: parentUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentUserId),
      registeredByNurseId: registeredByNurseId == null && nullToAbsent
          ? const Value.absent()
          : Value(registeredByNurseId),
      linkCode: Value(linkCode),
      parentContact: parentContact == null && nullToAbsent
          ? const Value.absent()
          : Value(parentContact),
      syncStatus: Value(syncStatus),
    );
  }

  factory ChildRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      sex: serializer.fromJson<String>(json['sex']),
      birthWeightKg: serializer.fromJson<double?>(json['birthWeightKg']),
      parentUserId: serializer.fromJson<String?>(json['parentUserId']),
      registeredByNurseId: serializer.fromJson<String?>(
        json['registeredByNurseId'],
      ),
      linkCode: serializer.fromJson<String>(json['linkCode']),
      parentContact: serializer.fromJson<String?>(json['parentContact']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'sex': serializer.toJson<String>(sex),
      'birthWeightKg': serializer.toJson<double?>(birthWeightKg),
      'parentUserId': serializer.toJson<String?>(parentUserId),
      'registeredByNurseId': serializer.toJson<String?>(registeredByNurseId),
      'linkCode': serializer.toJson<String>(linkCode),
      'parentContact': serializer.toJson<String?>(parentContact),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  ChildRow copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? sex,
    Value<double?> birthWeightKg = const Value.absent(),
    Value<String?> parentUserId = const Value.absent(),
    Value<String?> registeredByNurseId = const Value.absent(),
    String? linkCode,
    Value<String?> parentContact = const Value.absent(),
    String? syncStatus,
  }) => ChildRow(
    id: id ?? this.id,
    name: name ?? this.name,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    sex: sex ?? this.sex,
    birthWeightKg: birthWeightKg.present
        ? birthWeightKg.value
        : this.birthWeightKg,
    parentUserId: parentUserId.present ? parentUserId.value : this.parentUserId,
    registeredByNurseId: registeredByNurseId.present
        ? registeredByNurseId.value
        : this.registeredByNurseId,
    linkCode: linkCode ?? this.linkCode,
    parentContact: parentContact.present
        ? parentContact.value
        : this.parentContact,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  ChildRow copyWithCompanion(ChildrenCompanion data) {
    return ChildRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthWeightKg: data.birthWeightKg.present
          ? data.birthWeightKg.value
          : this.birthWeightKg,
      parentUserId: data.parentUserId.present
          ? data.parentUserId.value
          : this.parentUserId,
      registeredByNurseId: data.registeredByNurseId.present
          ? data.registeredByNurseId.value
          : this.registeredByNurseId,
      linkCode: data.linkCode.present ? data.linkCode.value : this.linkCode,
      parentContact: data.parentContact.present
          ? data.parentContact.value
          : this.parentContact,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('sex: $sex, ')
          ..write('birthWeightKg: $birthWeightKg, ')
          ..write('parentUserId: $parentUserId, ')
          ..write('registeredByNurseId: $registeredByNurseId, ')
          ..write('linkCode: $linkCode, ')
          ..write('parentContact: $parentContact, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dateOfBirth,
    sex,
    birthWeightKg,
    parentUserId,
    registeredByNurseId,
    linkCode,
    parentContact,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.dateOfBirth == this.dateOfBirth &&
          other.sex == this.sex &&
          other.birthWeightKg == this.birthWeightKg &&
          other.parentUserId == this.parentUserId &&
          other.registeredByNurseId == this.registeredByNurseId &&
          other.linkCode == this.linkCode &&
          other.parentContact == this.parentContact &&
          other.syncStatus == this.syncStatus);
}

class ChildrenCompanion extends UpdateCompanion<ChildRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> dateOfBirth;
  final Value<String> sex;
  final Value<double?> birthWeightKg;
  final Value<String?> parentUserId;
  final Value<String?> registeredByNurseId;
  final Value<String> linkCode;
  final Value<String?> parentContact;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthWeightKg = const Value.absent(),
    this.parentUserId = const Value.absent(),
    this.registeredByNurseId = const Value.absent(),
    this.linkCode = const Value.absent(),
    this.parentContact = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChildrenCompanion.insert({
    required String id,
    required String name,
    required DateTime dateOfBirth,
    required String sex,
    this.birthWeightKg = const Value.absent(),
    this.parentUserId = const Value.absent(),
    this.registeredByNurseId = const Value.absent(),
    required String linkCode,
    this.parentContact = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       dateOfBirth = Value(dateOfBirth),
       sex = Value(sex),
       linkCode = Value(linkCode);
  static Insertable<ChildRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? sex,
    Expression<double>? birthWeightKg,
    Expression<String>? parentUserId,
    Expression<String>? registeredByNurseId,
    Expression<String>? linkCode,
    Expression<String>? parentContact,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (sex != null) 'sex': sex,
      if (birthWeightKg != null) 'birth_weight_kg': birthWeightKg,
      if (parentUserId != null) 'parent_user_id': parentUserId,
      if (registeredByNurseId != null)
        'registered_by_nurse_id': registeredByNurseId,
      if (linkCode != null) 'link_code': linkCode,
      if (parentContact != null) 'parent_contact': parentContact,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChildrenCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? dateOfBirth,
    Value<String>? sex,
    Value<double?>? birthWeightKg,
    Value<String?>? parentUserId,
    Value<String?>? registeredByNurseId,
    Value<String>? linkCode,
    Value<String?>? parentContact,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return ChildrenCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sex: sex ?? this.sex,
      birthWeightKg: birthWeightKg ?? this.birthWeightKg,
      parentUserId: parentUserId ?? this.parentUserId,
      registeredByNurseId: registeredByNurseId ?? this.registeredByNurseId,
      linkCode: linkCode ?? this.linkCode,
      parentContact: parentContact ?? this.parentContact,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthWeightKg.present) {
      map['birth_weight_kg'] = Variable<double>(birthWeightKg.value);
    }
    if (parentUserId.present) {
      map['parent_user_id'] = Variable<String>(parentUserId.value);
    }
    if (registeredByNurseId.present) {
      map['registered_by_nurse_id'] = Variable<String>(
        registeredByNurseId.value,
      );
    }
    if (linkCode.present) {
      map['link_code'] = Variable<String>(linkCode.value);
    }
    if (parentContact.present) {
      map['parent_contact'] = Variable<String>(parentContact.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('sex: $sex, ')
          ..write('birthWeightKg: $birthWeightKg, ')
          ..write('parentUserId: $parentUserId, ')
          ..write('registeredByNurseId: $registeredByNurseId, ')
          ..write('linkCode: $linkCode, ')
          ..write('parentContact: $parentContact, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurementsTable extends Measurements
    with TableInfo<$MeasurementsTable, MeasurementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES children (id)',
    ),
  );
  static const VerificationMeta _nurseIdMeta = const VerificationMeta(
    'nurseId',
  );
  @override
  late final GeneratedColumn<String> nurseId = GeneratedColumn<String>(
    'nurse_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _muacCmMeta = const VerificationMeta('muacCm');
  @override
  late final GeneratedColumn<double> muacCm = GeneratedColumn<double>(
    'muac_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headCircumferenceCmMeta =
      const VerificationMeta('headCircumferenceCm');
  @override
  late final GeneratedColumn<double> headCircumferenceCm =
      GeneratedColumn<double>(
        'head_circumference_cm',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bmiMeta = const VerificationMeta('bmi');
  @override
  late final GeneratedColumn<double> bmi = GeneratedColumn<double>(
    'bmi',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wazMeta = const VerificationMeta('waz');
  @override
  late final GeneratedColumn<double> waz = GeneratedColumn<double>(
    'waz',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hazMeta = const VerificationMeta('haz');
  @override
  late final GeneratedColumn<double> haz = GeneratedColumn<double>(
    'haz',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whzMeta = const VerificationMeta('whz');
  @override
  late final GeneratedColumn<double> whz = GeneratedColumn<double>(
    'whz',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatus.pending),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    nurseId,
    takenAt,
    weightKg,
    heightCm,
    muacCm,
    headCircumferenceCm,
    bmi,
    waz,
    haz,
    whz,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('nurse_id')) {
      context.handle(
        _nurseIdMeta,
        nurseId.isAcceptableOrUnknown(data['nurse_id']!, _nurseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nurseIdMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('muac_cm')) {
      context.handle(
        _muacCmMeta,
        muacCm.isAcceptableOrUnknown(data['muac_cm']!, _muacCmMeta),
      );
    }
    if (data.containsKey('head_circumference_cm')) {
      context.handle(
        _headCircumferenceCmMeta,
        headCircumferenceCm.isAcceptableOrUnknown(
          data['head_circumference_cm']!,
          _headCircumferenceCmMeta,
        ),
      );
    }
    if (data.containsKey('bmi')) {
      context.handle(
        _bmiMeta,
        bmi.isAcceptableOrUnknown(data['bmi']!, _bmiMeta),
      );
    }
    if (data.containsKey('waz')) {
      context.handle(
        _wazMeta,
        waz.isAcceptableOrUnknown(data['waz']!, _wazMeta),
      );
    }
    if (data.containsKey('haz')) {
      context.handle(
        _hazMeta,
        haz.isAcceptableOrUnknown(data['haz']!, _hazMeta),
      );
    }
    if (data.containsKey('whz')) {
      context.handle(
        _whzMeta,
        whz.isAcceptableOrUnknown(data['whz']!, _whzMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasurementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      nurseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nurse_id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      muacCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muac_cm'],
      ),
      headCircumferenceCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}head_circumference_cm'],
      ),
      bmi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bmi'],
      ),
      waz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waz'],
      ),
      haz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}haz'],
      ),
      whz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}whz'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $MeasurementsTable createAlias(String alias) {
    return $MeasurementsTable(attachedDatabase, alias);
  }
}

class MeasurementRow extends DataClass implements Insertable<MeasurementRow> {
  final String id;
  final String childId;
  final String nurseId;
  final DateTime takenAt;
  final double weightKg;
  final double heightCm;
  final double? muacCm;
  final double? headCircumferenceCm;
  final double? bmi;
  final double? waz;
  final double? haz;
  final double? whz;
  final String syncStatus;
  const MeasurementRow({
    required this.id,
    required this.childId,
    required this.nurseId,
    required this.takenAt,
    required this.weightKg,
    required this.heightCm,
    this.muacCm,
    this.headCircumferenceCm,
    this.bmi,
    this.waz,
    this.haz,
    this.whz,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['nurse_id'] = Variable<String>(nurseId);
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['weight_kg'] = Variable<double>(weightKg);
    map['height_cm'] = Variable<double>(heightCm);
    if (!nullToAbsent || muacCm != null) {
      map['muac_cm'] = Variable<double>(muacCm);
    }
    if (!nullToAbsent || headCircumferenceCm != null) {
      map['head_circumference_cm'] = Variable<double>(headCircumferenceCm);
    }
    if (!nullToAbsent || bmi != null) {
      map['bmi'] = Variable<double>(bmi);
    }
    if (!nullToAbsent || waz != null) {
      map['waz'] = Variable<double>(waz);
    }
    if (!nullToAbsent || haz != null) {
      map['haz'] = Variable<double>(haz);
    }
    if (!nullToAbsent || whz != null) {
      map['whz'] = Variable<double>(whz);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  MeasurementsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementsCompanion(
      id: Value(id),
      childId: Value(childId),
      nurseId: Value(nurseId),
      takenAt: Value(takenAt),
      weightKg: Value(weightKg),
      heightCm: Value(heightCm),
      muacCm: muacCm == null && nullToAbsent
          ? const Value.absent()
          : Value(muacCm),
      headCircumferenceCm: headCircumferenceCm == null && nullToAbsent
          ? const Value.absent()
          : Value(headCircumferenceCm),
      bmi: bmi == null && nullToAbsent ? const Value.absent() : Value(bmi),
      waz: waz == null && nullToAbsent ? const Value.absent() : Value(waz),
      haz: haz == null && nullToAbsent ? const Value.absent() : Value(haz),
      whz: whz == null && nullToAbsent ? const Value.absent() : Value(whz),
      syncStatus: Value(syncStatus),
    );
  }

  factory MeasurementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementRow(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      nurseId: serializer.fromJson<String>(json['nurseId']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      muacCm: serializer.fromJson<double?>(json['muacCm']),
      headCircumferenceCm: serializer.fromJson<double?>(
        json['headCircumferenceCm'],
      ),
      bmi: serializer.fromJson<double?>(json['bmi']),
      waz: serializer.fromJson<double?>(json['waz']),
      haz: serializer.fromJson<double?>(json['haz']),
      whz: serializer.fromJson<double?>(json['whz']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'nurseId': serializer.toJson<String>(nurseId),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double>(heightCm),
      'muacCm': serializer.toJson<double?>(muacCm),
      'headCircumferenceCm': serializer.toJson<double?>(headCircumferenceCm),
      'bmi': serializer.toJson<double?>(bmi),
      'waz': serializer.toJson<double?>(waz),
      'haz': serializer.toJson<double?>(haz),
      'whz': serializer.toJson<double?>(whz),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  MeasurementRow copyWith({
    String? id,
    String? childId,
    String? nurseId,
    DateTime? takenAt,
    double? weightKg,
    double? heightCm,
    Value<double?> muacCm = const Value.absent(),
    Value<double?> headCircumferenceCm = const Value.absent(),
    Value<double?> bmi = const Value.absent(),
    Value<double?> waz = const Value.absent(),
    Value<double?> haz = const Value.absent(),
    Value<double?> whz = const Value.absent(),
    String? syncStatus,
  }) => MeasurementRow(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    nurseId: nurseId ?? this.nurseId,
    takenAt: takenAt ?? this.takenAt,
    weightKg: weightKg ?? this.weightKg,
    heightCm: heightCm ?? this.heightCm,
    muacCm: muacCm.present ? muacCm.value : this.muacCm,
    headCircumferenceCm: headCircumferenceCm.present
        ? headCircumferenceCm.value
        : this.headCircumferenceCm,
    bmi: bmi.present ? bmi.value : this.bmi,
    waz: waz.present ? waz.value : this.waz,
    haz: haz.present ? haz.value : this.haz,
    whz: whz.present ? whz.value : this.whz,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  MeasurementRow copyWithCompanion(MeasurementsCompanion data) {
    return MeasurementRow(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      nurseId: data.nurseId.present ? data.nurseId.value : this.nurseId,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      muacCm: data.muacCm.present ? data.muacCm.value : this.muacCm,
      headCircumferenceCm: data.headCircumferenceCm.present
          ? data.headCircumferenceCm.value
          : this.headCircumferenceCm,
      bmi: data.bmi.present ? data.bmi.value : this.bmi,
      waz: data.waz.present ? data.waz.value : this.waz,
      haz: data.haz.present ? data.haz.value : this.haz,
      whz: data.whz.present ? data.whz.value : this.whz,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementRow(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('nurseId: $nurseId, ')
          ..write('takenAt: $takenAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('muacCm: $muacCm, ')
          ..write('headCircumferenceCm: $headCircumferenceCm, ')
          ..write('bmi: $bmi, ')
          ..write('waz: $waz, ')
          ..write('haz: $haz, ')
          ..write('whz: $whz, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    childId,
    nurseId,
    takenAt,
    weightKg,
    heightCm,
    muacCm,
    headCircumferenceCm,
    bmi,
    waz,
    haz,
    whz,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementRow &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.nurseId == this.nurseId &&
          other.takenAt == this.takenAt &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.muacCm == this.muacCm &&
          other.headCircumferenceCm == this.headCircumferenceCm &&
          other.bmi == this.bmi &&
          other.waz == this.waz &&
          other.haz == this.haz &&
          other.whz == this.whz &&
          other.syncStatus == this.syncStatus);
}

class MeasurementsCompanion extends UpdateCompanion<MeasurementRow> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> nurseId;
  final Value<DateTime> takenAt;
  final Value<double> weightKg;
  final Value<double> heightCm;
  final Value<double?> muacCm;
  final Value<double?> headCircumferenceCm;
  final Value<double?> bmi;
  final Value<double?> waz;
  final Value<double?> haz;
  final Value<double?> whz;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const MeasurementsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.nurseId = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.muacCm = const Value.absent(),
    this.headCircumferenceCm = const Value.absent(),
    this.bmi = const Value.absent(),
    this.waz = const Value.absent(),
    this.haz = const Value.absent(),
    this.whz = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementsCompanion.insert({
    required String id,
    required String childId,
    required String nurseId,
    required DateTime takenAt,
    required double weightKg,
    required double heightCm,
    this.muacCm = const Value.absent(),
    this.headCircumferenceCm = const Value.absent(),
    this.bmi = const Value.absent(),
    this.waz = const Value.absent(),
    this.haz = const Value.absent(),
    this.whz = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       nurseId = Value(nurseId),
       takenAt = Value(takenAt),
       weightKg = Value(weightKg),
       heightCm = Value(heightCm);
  static Insertable<MeasurementRow> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? nurseId,
    Expression<DateTime>? takenAt,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<double>? muacCm,
    Expression<double>? headCircumferenceCm,
    Expression<double>? bmi,
    Expression<double>? waz,
    Expression<double>? haz,
    Expression<double>? whz,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (nurseId != null) 'nurse_id': nurseId,
      if (takenAt != null) 'taken_at': takenAt,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (muacCm != null) 'muac_cm': muacCm,
      if (headCircumferenceCm != null)
        'head_circumference_cm': headCircumferenceCm,
      if (bmi != null) 'bmi': bmi,
      if (waz != null) 'waz': waz,
      if (haz != null) 'haz': haz,
      if (whz != null) 'whz': whz,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? nurseId,
    Value<DateTime>? takenAt,
    Value<double>? weightKg,
    Value<double>? heightCm,
    Value<double?>? muacCm,
    Value<double?>? headCircumferenceCm,
    Value<double?>? bmi,
    Value<double?>? waz,
    Value<double?>? haz,
    Value<double?>? whz,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return MeasurementsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      nurseId: nurseId ?? this.nurseId,
      takenAt: takenAt ?? this.takenAt,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      muacCm: muacCm ?? this.muacCm,
      headCircumferenceCm: headCircumferenceCm ?? this.headCircumferenceCm,
      bmi: bmi ?? this.bmi,
      waz: waz ?? this.waz,
      haz: haz ?? this.haz,
      whz: whz ?? this.whz,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (nurseId.present) {
      map['nurse_id'] = Variable<String>(nurseId.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (muacCm.present) {
      map['muac_cm'] = Variable<double>(muacCm.value);
    }
    if (headCircumferenceCm.present) {
      map['head_circumference_cm'] = Variable<double>(
        headCircumferenceCm.value,
      );
    }
    if (bmi.present) {
      map['bmi'] = Variable<double>(bmi.value);
    }
    if (waz.present) {
      map['waz'] = Variable<double>(waz.value);
    }
    if (haz.present) {
      map['haz'] = Variable<double>(haz.value);
    }
    if (whz.present) {
      map['whz'] = Variable<double>(whz.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('nurseId: $nurseId, ')
          ..write('takenAt: $takenAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('muacCm: $muacCm, ')
          ..write('headCircumferenceCm: $headCircumferenceCm, ')
          ..write('bmi: $bmi, ')
          ..write('waz: $waz, ')
          ..write('haz: $haz, ')
          ..write('whz: $whz, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, AlertRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES children (id)',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatus.pending),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    level,
    message,
    createdAt,
    resolved,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlertRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class AlertRow extends DataClass implements Insertable<AlertRow> {
  final String id;
  final String childId;
  final String level;
  final String message;
  final DateTime createdAt;
  final bool resolved;
  final String syncStatus;
  const AlertRow({
    required this.id,
    required this.childId,
    required this.level,
    required this.message,
    required this.createdAt,
    required this.resolved,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['level'] = Variable<String>(level);
    map['message'] = Variable<String>(message);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['resolved'] = Variable<bool>(resolved);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      childId: Value(childId),
      level: Value(level),
      message: Value(message),
      createdAt: Value(createdAt),
      resolved: Value(resolved),
      syncStatus: Value(syncStatus),
    );
  }

  factory AlertRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertRow(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      level: serializer.fromJson<String>(json['level']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolved: serializer.fromJson<bool>(json['resolved']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'level': serializer.toJson<String>(level),
      'message': serializer.toJson<String>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolved': serializer.toJson<bool>(resolved),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  AlertRow copyWith({
    String? id,
    String? childId,
    String? level,
    String? message,
    DateTime? createdAt,
    bool? resolved,
    String? syncStatus,
  }) => AlertRow(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    level: level ?? this.level,
    message: message ?? this.message,
    createdAt: createdAt ?? this.createdAt,
    resolved: resolved ?? this.resolved,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  AlertRow copyWithCompanion(AlertsCompanion data) {
    return AlertRow(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      level: data.level.present ? data.level.value : this.level,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertRow(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolved: $resolved, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, childId, level, message, createdAt, resolved, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertRow &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.level == this.level &&
          other.message == this.message &&
          other.createdAt == this.createdAt &&
          other.resolved == this.resolved &&
          other.syncStatus == this.syncStatus);
}

class AlertsCompanion extends UpdateCompanion<AlertRow> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> level;
  final Value<String> message;
  final Value<DateTime> createdAt;
  final Value<bool> resolved;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolved = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertsCompanion.insert({
    required String id,
    required String childId,
    required String level,
    required String message,
    required DateTime createdAt,
    this.resolved = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       level = Value(level),
       message = Value(message),
       createdAt = Value(createdAt);
  static Insertable<AlertRow> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? level,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
    Expression<bool>? resolved,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
      if (resolved != null) 'resolved': resolved,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? level,
    Value<String>? message,
    Value<DateTime>? createdAt,
    Value<bool>? resolved,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return AlertsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      level: level ?? this.level,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      resolved: resolved ?? this.resolved,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolved: $resolved, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $MeasurementsTable measurements = $MeasurementsTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    children,
    measurements,
    alerts,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String role,
      required String fullName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> hospitalId,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> role,
      Value<String> fullName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> hospitalId,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, UserRow> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MeasurementsTable, List<MeasurementRow>>
  _measurementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.measurements,
    aliasName: 'users__id__measurements__nurse_id',
  );

  $$MeasurementsTableProcessedTableManager get measurementsRefs {
    final manager = $$MeasurementsTableTableManager(
      $_db,
      $_db.measurements,
    ).filter((f) => f.nurseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_measurementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hospitalId => $composableBuilder(
    column: $table.hospitalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> measurementsRefs(
    Expression<bool> Function($$MeasurementsTableFilterComposer f) f,
  ) {
    final $$MeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.nurseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hospitalId => $composableBuilder(
    column: $table.hospitalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get hospitalId => $composableBuilder(
    column: $table.hospitalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  Expression<T> measurementsRefs<T extends Object>(
    Expression<T> Function($$MeasurementsTableAnnotationComposer a) f,
  ) {
    final $$MeasurementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.nurseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserRow,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserRow, $$UsersTableReferences),
          UserRow,
          PrefetchHooks Function({bool measurementsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> hospitalId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                role: role,
                fullName: fullName,
                email: email,
                phone: phone,
                hospitalId: hospitalId,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String role,
                required String fullName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> hospitalId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                role: role,
                fullName: fullName,
                email: email,
                phone: phone,
                hospitalId: hospitalId,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({measurementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (measurementsRefs) db.measurements],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (measurementsRefs)
                    await $_getPrefetchedData<
                      UserRow,
                      $UsersTable,
                      MeasurementRow
                    >(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences
                          ._measurementsRefsTable(db),
                      managerFromTypedResult: (p0) => $$UsersTableReferences(
                        db,
                        table,
                        p0,
                      ).measurementsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.nurseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserRow,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserRow, $$UsersTableReferences),
      UserRow,
      PrefetchHooks Function({bool measurementsRefs})
    >;
typedef $$ChildrenTableCreateCompanionBuilder =
    ChildrenCompanion Function({
      required String id,
      required String name,
      required DateTime dateOfBirth,
      required String sex,
      Value<double?> birthWeightKg,
      Value<String?> parentUserId,
      Value<String?> registeredByNurseId,
      required String linkCode,
      Value<String?> parentContact,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$ChildrenTableUpdateCompanionBuilder =
    ChildrenCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> dateOfBirth,
      Value<String> sex,
      Value<double?> birthWeightKg,
      Value<String?> parentUserId,
      Value<String?> registeredByNurseId,
      Value<String> linkCode,
      Value<String?> parentContact,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$ChildrenTableReferences
    extends BaseReferences<_$AppDatabase, $ChildrenTable, ChildRow> {
  $$ChildrenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _parentUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('children__parent_user_id__users__id');

  $$UsersTableProcessedTableManager? get parentUserId {
    final $_column = $_itemColumn<String>('parent_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _registeredByNurseIdTable(_$AppDatabase db) =>
      db.users.createAlias('children__registered_by_nurse_id__users__id');

  $$UsersTableProcessedTableManager? get registeredByNurseId {
    final $_column = $_itemColumn<String>('registered_by_nurse_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_registeredByNurseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MeasurementsTable, List<MeasurementRow>>
  _measurementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.measurements,
    aliasName: 'children__id__measurements__child_id',
  );

  $$MeasurementsTableProcessedTableManager get measurementsRefs {
    final manager = $$MeasurementsTableTableManager(
      $_db,
      $_db.measurements,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_measurementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AlertsTable, List<AlertRow>> _alertsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.alerts,
    aliasName: 'children__id__alerts__child_id',
  );

  $$AlertsTableProcessedTableManager get alertsRefs {
    final manager = $$AlertsTableTableManager(
      $_db,
      $_db.alerts,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_alertsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkCode => $composableBuilder(
    column: $table.linkCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentContact => $composableBuilder(
    column: $table.parentContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get parentUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get registeredByNurseId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registeredByNurseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> measurementsRefs(
    Expression<bool> Function($$MeasurementsTableFilterComposer f) f,
  ) {
    final $$MeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> alertsRefs(
    Expression<bool> Function($$AlertsTableFilterComposer f) f,
  ) {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alerts,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertsTableFilterComposer(
            $db: $db,
            $table: $db.alerts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkCode => $composableBuilder(
    column: $table.linkCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentContact => $composableBuilder(
    column: $table.parentContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get parentUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get registeredByNurseId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registeredByNurseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkCode =>
      $composableBuilder(column: $table.linkCode, builder: (column) => column);

  GeneratedColumn<String> get parentContact => $composableBuilder(
    column: $table.parentContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get parentUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get registeredByNurseId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registeredByNurseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> measurementsRefs<T extends Object>(
    Expression<T> Function($$MeasurementsTableAnnotationComposer a) f,
  ) {
    final $$MeasurementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> alertsRefs<T extends Object>(
    Expression<T> Function($$AlertsTableAnnotationComposer a) f,
  ) {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alerts,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertsTableAnnotationComposer(
            $db: $db,
            $table: $db.alerts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildrenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChildrenTable,
          ChildRow,
          $$ChildrenTableFilterComposer,
          $$ChildrenTableOrderingComposer,
          $$ChildrenTableAnnotationComposer,
          $$ChildrenTableCreateCompanionBuilder,
          $$ChildrenTableUpdateCompanionBuilder,
          (ChildRow, $$ChildrenTableReferences),
          ChildRow,
          PrefetchHooks Function({
            bool parentUserId,
            bool registeredByNurseId,
            bool measurementsRefs,
            bool alertsRefs,
          })
        > {
  $$ChildrenTableTableManager(_$AppDatabase db, $ChildrenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> dateOfBirth = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<double?> birthWeightKg = const Value.absent(),
                Value<String?> parentUserId = const Value.absent(),
                Value<String?> registeredByNurseId = const Value.absent(),
                Value<String> linkCode = const Value.absent(),
                Value<String?> parentContact = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildrenCompanion(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                sex: sex,
                birthWeightKg: birthWeightKg,
                parentUserId: parentUserId,
                registeredByNurseId: registeredByNurseId,
                linkCode: linkCode,
                parentContact: parentContact,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime dateOfBirth,
                required String sex,
                Value<double?> birthWeightKg = const Value.absent(),
                Value<String?> parentUserId = const Value.absent(),
                Value<String?> registeredByNurseId = const Value.absent(),
                required String linkCode,
                Value<String?> parentContact = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildrenCompanion.insert(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                sex: sex,
                birthWeightKg: birthWeightKg,
                parentUserId: parentUserId,
                registeredByNurseId: registeredByNurseId,
                linkCode: linkCode,
                parentContact: parentContact,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChildrenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentUserId = false,
                registeredByNurseId = false,
                measurementsRefs = false,
                alertsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (measurementsRefs) db.measurements,
                    if (alertsRefs) db.alerts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentUserId,
                                    referencedTable: $$ChildrenTableReferences
                                        ._parentUserIdTable(db),
                                    referencedColumn: $$ChildrenTableReferences
                                        ._parentUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (registeredByNurseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.registeredByNurseId,
                                    referencedTable: $$ChildrenTableReferences
                                        ._registeredByNurseIdTable(db),
                                    referencedColumn: $$ChildrenTableReferences
                                        ._registeredByNurseIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (measurementsRefs)
                        await $_getPrefetchedData<
                          ChildRow,
                          $ChildrenTable,
                          MeasurementRow
                        >(
                          currentTable: table,
                          referencedTable: $$ChildrenTableReferences
                              ._measurementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).measurementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (alertsRefs)
                        await $_getPrefetchedData<
                          ChildRow,
                          $ChildrenTable,
                          AlertRow
                        >(
                          currentTable: table,
                          referencedTable: $$ChildrenTableReferences
                              ._alertsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildrenTableReferences(
                                db,
                                table,
                                p0,
                              ).alertsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChildrenTable,
      ChildRow,
      $$ChildrenTableFilterComposer,
      $$ChildrenTableOrderingComposer,
      $$ChildrenTableAnnotationComposer,
      $$ChildrenTableCreateCompanionBuilder,
      $$ChildrenTableUpdateCompanionBuilder,
      (ChildRow, $$ChildrenTableReferences),
      ChildRow,
      PrefetchHooks Function({
        bool parentUserId,
        bool registeredByNurseId,
        bool measurementsRefs,
        bool alertsRefs,
      })
    >;
typedef $$MeasurementsTableCreateCompanionBuilder =
    MeasurementsCompanion Function({
      required String id,
      required String childId,
      required String nurseId,
      required DateTime takenAt,
      required double weightKg,
      required double heightCm,
      Value<double?> muacCm,
      Value<double?> headCircumferenceCm,
      Value<double?> bmi,
      Value<double?> waz,
      Value<double?> haz,
      Value<double?> whz,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$MeasurementsTableUpdateCompanionBuilder =
    MeasurementsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> nurseId,
      Value<DateTime> takenAt,
      Value<double> weightKg,
      Value<double> heightCm,
      Value<double?> muacCm,
      Value<double?> headCircumferenceCm,
      Value<double?> bmi,
      Value<double?> waz,
      Value<double?> haz,
      Value<double?> whz,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$MeasurementsTableReferences
    extends BaseReferences<_$AppDatabase, $MeasurementsTable, MeasurementRow> {
  $$MeasurementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildrenTable _childIdTable(_$AppDatabase db) =>
      db.children.createAlias('measurements__child_id__children__id');

  $$ChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$ChildrenTableTableManager(
      $_db,
      $_db.children,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _nurseIdTable(_$AppDatabase db) =>
      db.users.createAlias('measurements__nurse_id__users__id');

  $$UsersTableProcessedTableManager get nurseId {
    final $_column = $_itemColumn<String>('nurse_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nurseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get muacCm => $composableBuilder(
    column: $table.muacCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headCircumferenceCm => $composableBuilder(
    column: $table.headCircumferenceCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waz => $composableBuilder(
    column: $table.waz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get haz => $composableBuilder(
    column: $table.haz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get whz => $composableBuilder(
    column: $table.whz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableFilterComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get nurseId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nurseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get muacCm => $composableBuilder(
    column: $table.muacCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headCircumferenceCm => $composableBuilder(
    column: $table.headCircumferenceCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waz => $composableBuilder(
    column: $table.waz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get haz => $composableBuilder(
    column: $table.haz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get whz => $composableBuilder(
    column: $table.whz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get nurseId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nurseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get muacCm =>
      $composableBuilder(column: $table.muacCm, builder: (column) => column);

  GeneratedColumn<double> get headCircumferenceCm => $composableBuilder(
    column: $table.headCircumferenceCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bmi =>
      $composableBuilder(column: $table.bmi, builder: (column) => column);

  GeneratedColumn<double> get waz =>
      $composableBuilder(column: $table.waz, builder: (column) => column);

  GeneratedColumn<double> get haz =>
      $composableBuilder(column: $table.haz, builder: (column) => column);

  GeneratedColumn<double> get whz =>
      $composableBuilder(column: $table.whz, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$ChildrenTableAnnotationComposer get childId {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get nurseId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nurseId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementsTable,
          MeasurementRow,
          $$MeasurementsTableFilterComposer,
          $$MeasurementsTableOrderingComposer,
          $$MeasurementsTableAnnotationComposer,
          $$MeasurementsTableCreateCompanionBuilder,
          $$MeasurementsTableUpdateCompanionBuilder,
          (MeasurementRow, $$MeasurementsTableReferences),
          MeasurementRow,
          PrefetchHooks Function({bool childId, bool nurseId})
        > {
  $$MeasurementsTableTableManager(_$AppDatabase db, $MeasurementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> nurseId = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double?> muacCm = const Value.absent(),
                Value<double?> headCircumferenceCm = const Value.absent(),
                Value<double?> bmi = const Value.absent(),
                Value<double?> waz = const Value.absent(),
                Value<double?> haz = const Value.absent(),
                Value<double?> whz = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementsCompanion(
                id: id,
                childId: childId,
                nurseId: nurseId,
                takenAt: takenAt,
                weightKg: weightKg,
                heightCm: heightCm,
                muacCm: muacCm,
                headCircumferenceCm: headCircumferenceCm,
                bmi: bmi,
                waz: waz,
                haz: haz,
                whz: whz,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String nurseId,
                required DateTime takenAt,
                required double weightKg,
                required double heightCm,
                Value<double?> muacCm = const Value.absent(),
                Value<double?> headCircumferenceCm = const Value.absent(),
                Value<double?> bmi = const Value.absent(),
                Value<double?> waz = const Value.absent(),
                Value<double?> haz = const Value.absent(),
                Value<double?> whz = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementsCompanion.insert(
                id: id,
                childId: childId,
                nurseId: nurseId,
                takenAt: takenAt,
                weightKg: weightKg,
                heightCm: heightCm,
                muacCm: muacCm,
                headCircumferenceCm: headCircumferenceCm,
                bmi: bmi,
                waz: waz,
                haz: haz,
                whz: whz,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false, nurseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable: $$MeasurementsTableReferences
                                    ._childIdTable(db),
                                referencedColumn: $$MeasurementsTableReferences
                                    ._childIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (nurseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.nurseId,
                                referencedTable: $$MeasurementsTableReferences
                                    ._nurseIdTable(db),
                                referencedColumn: $$MeasurementsTableReferences
                                    ._nurseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementsTable,
      MeasurementRow,
      $$MeasurementsTableFilterComposer,
      $$MeasurementsTableOrderingComposer,
      $$MeasurementsTableAnnotationComposer,
      $$MeasurementsTableCreateCompanionBuilder,
      $$MeasurementsTableUpdateCompanionBuilder,
      (MeasurementRow, $$MeasurementsTableReferences),
      MeasurementRow,
      PrefetchHooks Function({bool childId, bool nurseId})
    >;
typedef $$AlertsTableCreateCompanionBuilder =
    AlertsCompanion Function({
      required String id,
      required String childId,
      required String level,
      required String message,
      required DateTime createdAt,
      Value<bool> resolved,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$AlertsTableUpdateCompanionBuilder =
    AlertsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> level,
      Value<String> message,
      Value<DateTime> createdAt,
      Value<bool> resolved,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$AlertsTableReferences
    extends BaseReferences<_$AppDatabase, $AlertsTable, AlertRow> {
  $$AlertsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildrenTable _childIdTable(_$AppDatabase db) =>
      db.children.createAlias('alerts__child_id__children__id');

  $$ChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$ChildrenTableTableManager(
      $_db,
      $_db.children,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableFilterComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableOrderingComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$ChildrenTableAnnotationComposer get childId {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.children,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.children,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertsTable,
          AlertRow,
          $$AlertsTableFilterComposer,
          $$AlertsTableOrderingComposer,
          $$AlertsTableAnnotationComposer,
          $$AlertsTableCreateCompanionBuilder,
          $$AlertsTableUpdateCompanionBuilder,
          (AlertRow, $$AlertsTableReferences),
          AlertRow,
          PrefetchHooks Function({bool childId})
        > {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertsCompanion(
                id: id,
                childId: childId,
                level: level,
                message: message,
                createdAt: createdAt,
                resolved: resolved,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String level,
                required String message,
                required DateTime createdAt,
                Value<bool> resolved = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertsCompanion.insert(
                id: id,
                childId: childId,
                level: level,
                message: message,
                createdAt: createdAt,
                resolved: resolved,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AlertsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable: $$AlertsTableReferences
                                    ._childIdTable(db),
                                referencedColumn: $$AlertsTableReferences
                                    ._childIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertsTable,
      AlertRow,
      $$AlertsTableFilterComposer,
      $$AlertsTableOrderingComposer,
      $$AlertsTableAnnotationComposer,
      $$AlertsTableCreateCompanionBuilder,
      $$AlertsTableUpdateCompanionBuilder,
      (AlertRow, $$AlertsTableReferences),
      AlertRow,
      PrefetchHooks Function({bool childId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db, _db.children);
  $$MeasurementsTableTableManager get measurements =>
      $$MeasurementsTableTableManager(_db, _db.measurements);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
}
