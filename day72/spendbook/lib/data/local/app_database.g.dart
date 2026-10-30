// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ExpenseCategory>($ExpensesTable.$convertercategory);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalCurrencyMeta = const VerificationMeta(
    'originalCurrency',
  );
  @override
  late final GeneratedColumn<String> originalCurrency = GeneratedColumn<String>(
    'original_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalMinorUnitsMeta =
      const VerificationMeta('originalMinorUnits');
  @override
  late final GeneratedColumn<int> originalMinorUnits = GeneratedColumn<int>(
    'original_minor_units',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalDecimalDigitsMeta =
      const VerificationMeta('originalDecimalDigits');
  @override
  late final GeneratedColumn<int> originalDecimalDigits = GeneratedColumn<int>(
    'original_decimal_digits',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amountCents,
    category,
    date,
    note,
    originalCurrency,
    originalMinorUnits,
    originalDecimalDigits,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('original_currency')) {
      context.handle(
        _originalCurrencyMeta,
        originalCurrency.isAcceptableOrUnknown(
          data['original_currency']!,
          _originalCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('original_minor_units')) {
      context.handle(
        _originalMinorUnitsMeta,
        originalMinorUnits.isAcceptableOrUnknown(
          data['original_minor_units']!,
          _originalMinorUnitsMeta,
        ),
      );
    }
    if (data.containsKey('original_decimal_digits')) {
      context.handle(
        _originalDecimalDigitsMeta,
        originalDecimalDigits.isAcceptableOrUnknown(
          data['original_decimal_digits']!,
          _originalDecimalDigitsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      category: $ExpensesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      originalCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_currency'],
      ),
      originalMinorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_minor_units'],
      ),
      originalDecimalDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_decimal_digits'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExpenseCategory, String, String>
  $convertercategory = const EnumNameConverter<ExpenseCategory>(
    ExpenseCategory.values,
  );
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final String id;
  final String title;
  final int amountCents;

  /// Stored as the enum's name ('food'), so adding a category later is
  /// safe; renaming one would need a migration.
  final ExpenseCategory category;
  final DateTime date;
  final String? note;
  final String? originalCurrency;
  final int? originalMinorUnits;
  final int? originalDecimalDigits;
  const ExpenseRow({
    required this.id,
    required this.title,
    required this.amountCents,
    required this.category,
    required this.date,
    this.note,
    this.originalCurrency,
    this.originalMinorUnits,
    this.originalDecimalDigits,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount_cents'] = Variable<int>(amountCents);
    {
      map['category'] = Variable<String>(
        $ExpensesTable.$convertercategory.toSql(category),
      );
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || originalCurrency != null) {
      map['original_currency'] = Variable<String>(originalCurrency);
    }
    if (!nullToAbsent || originalMinorUnits != null) {
      map['original_minor_units'] = Variable<int>(originalMinorUnits);
    }
    if (!nullToAbsent || originalDecimalDigits != null) {
      map['original_decimal_digits'] = Variable<int>(originalDecimalDigits);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      title: Value(title),
      amountCents: Value(amountCents),
      category: Value(category),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      originalCurrency: originalCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(originalCurrency),
      originalMinorUnits: originalMinorUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(originalMinorUnits),
      originalDecimalDigits: originalDecimalDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(originalDecimalDigits),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      category: $ExpensesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      originalCurrency: serializer.fromJson<String?>(json['originalCurrency']),
      originalMinorUnits: serializer.fromJson<int?>(json['originalMinorUnits']),
      originalDecimalDigits: serializer.fromJson<int?>(
        json['originalDecimalDigits'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amountCents': serializer.toJson<int>(amountCents),
      'category': serializer.toJson<String>(
        $ExpensesTable.$convertercategory.toJson(category),
      ),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'originalCurrency': serializer.toJson<String?>(originalCurrency),
      'originalMinorUnits': serializer.toJson<int?>(originalMinorUnits),
      'originalDecimalDigits': serializer.toJson<int?>(originalDecimalDigits),
    };
  }

  ExpenseRow copyWith({
    String? id,
    String? title,
    int? amountCents,
    ExpenseCategory? category,
    DateTime? date,
    Value<String?> note = const Value.absent(),
    Value<String?> originalCurrency = const Value.absent(),
    Value<int?> originalMinorUnits = const Value.absent(),
    Value<int?> originalDecimalDigits = const Value.absent(),
  }) => ExpenseRow(
    id: id ?? this.id,
    title: title ?? this.title,
    amountCents: amountCents ?? this.amountCents,
    category: category ?? this.category,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    originalCurrency: originalCurrency.present
        ? originalCurrency.value
        : this.originalCurrency,
    originalMinorUnits: originalMinorUnits.present
        ? originalMinorUnits.value
        : this.originalMinorUnits,
    originalDecimalDigits: originalDecimalDigits.present
        ? originalDecimalDigits.value
        : this.originalDecimalDigits,
  );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      originalCurrency: data.originalCurrency.present
          ? data.originalCurrency.value
          : this.originalCurrency,
      originalMinorUnits: data.originalMinorUnits.present
          ? data.originalMinorUnits.value
          : this.originalMinorUnits,
      originalDecimalDigits: data.originalDecimalDigits.present
          ? data.originalDecimalDigits.value
          : this.originalDecimalDigits,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('originalMinorUnits: $originalMinorUnits, ')
          ..write('originalDecimalDigits: $originalDecimalDigits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amountCents,
    category,
    date,
    note,
    originalCurrency,
    originalMinorUnits,
    originalDecimalDigits,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.amountCents == this.amountCents &&
          other.category == this.category &&
          other.date == this.date &&
          other.note == this.note &&
          other.originalCurrency == this.originalCurrency &&
          other.originalMinorUnits == this.originalMinorUnits &&
          other.originalDecimalDigits == this.originalDecimalDigits);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> amountCents;
  final Value<ExpenseCategory> category;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String?> originalCurrency;
  final Value<int?> originalMinorUnits;
  final Value<int?> originalDecimalDigits;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.originalCurrency = const Value.absent(),
    this.originalMinorUnits = const Value.absent(),
    this.originalDecimalDigits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String title,
    required int amountCents,
    required ExpenseCategory category,
    required DateTime date,
    this.note = const Value.absent(),
    this.originalCurrency = const Value.absent(),
    this.originalMinorUnits = const Value.absent(),
    this.originalDecimalDigits = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       amountCents = Value(amountCents),
       category = Value(category),
       date = Value(date);
  static Insertable<ExpenseRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? amountCents,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? originalCurrency,
    Expression<int>? originalMinorUnits,
    Expression<int>? originalDecimalDigits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amountCents != null) 'amount_cents': amountCents,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (originalCurrency != null) 'original_currency': originalCurrency,
      if (originalMinorUnits != null)
        'original_minor_units': originalMinorUnits,
      if (originalDecimalDigits != null)
        'original_decimal_digits': originalDecimalDigits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? amountCents,
    Value<ExpenseCategory>? category,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<String?>? originalCurrency,
    Value<int?>? originalMinorUnits,
    Value<int?>? originalDecimalDigits,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amountCents: amountCents ?? this.amountCents,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      originalCurrency: originalCurrency ?? this.originalCurrency,
      originalMinorUnits: originalMinorUnits ?? this.originalMinorUnits,
      originalDecimalDigits:
          originalDecimalDigits ?? this.originalDecimalDigits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ExpensesTable.$convertercategory.toSql(category.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (originalCurrency.present) {
      map['original_currency'] = Variable<String>(originalCurrency.value);
    }
    if (originalMinorUnits.present) {
      map['original_minor_units'] = Variable<int>(originalMinorUnits.value);
    }
    if (originalDecimalDigits.present) {
      map['original_decimal_digits'] = Variable<int>(
        originalDecimalDigits.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('originalMinorUnits: $originalMinorUnits, ')
          ..write('originalDecimalDigits: $originalDecimalDigits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyCentsMeta = const VerificationMeta(
    'monthlyCents',
  );
  @override
  late final GeneratedColumn<int> monthlyCents = GeneratedColumn<int>(
    'monthly_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, monthlyCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monthly_cents')) {
      context.handle(
        _monthlyCentsMeta,
        monthlyCents.isAcceptableOrUnknown(
          data['monthly_cents']!,
          _monthlyCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      monthlyCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_cents'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final int id;
  final int monthlyCents;
  const BudgetRow({required this.id, required this.monthlyCents});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['monthly_cents'] = Variable<int>(monthlyCents);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(id: Value(id), monthlyCents: Value(monthlyCents));
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<int>(json['id']),
      monthlyCents: serializer.fromJson<int>(json['monthlyCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthlyCents': serializer.toJson<int>(monthlyCents),
    };
  }

  BudgetRow copyWith({int? id, int? monthlyCents}) => BudgetRow(
    id: id ?? this.id,
    monthlyCents: monthlyCents ?? this.monthlyCents,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      monthlyCents: data.monthlyCents.present
          ? data.monthlyCents.value
          : this.monthlyCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('monthlyCents: $monthlyCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, monthlyCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.monthlyCents == this.monthlyCents);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<int> id;
  final Value<int> monthlyCents;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.monthlyCents = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int monthlyCents,
  }) : monthlyCents = Value(monthlyCents);
  static Insertable<BudgetRow> custom({
    Expression<int>? id,
    Expression<int>? monthlyCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthlyCents != null) 'monthly_cents': monthlyCents,
    });
  }

  BudgetsCompanion copyWith({Value<int>? id, Value<int>? monthlyCents}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      monthlyCents: monthlyCents ?? this.monthlyCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthlyCents.present) {
      map['monthly_cents'] = Variable<int>(monthlyCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('monthlyCents: $monthlyCents')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final Index expensesDate = Index(
    'expenses_date',
    'CREATE INDEX expenses_date ON expenses (date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    expenses,
    budgets,
    expensesDate,
  ];
}

typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required String title,
      required int amountCents,
      required ExpenseCategory category,
      required DateTime date,
      Value<String?> note,
      Value<String?> originalCurrency,
      Value<int?> originalMinorUnits,
      Value<int?> originalDecimalDigits,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> amountCents,
      Value<ExpenseCategory> category,
      Value<DateTime> date,
      Value<String?> note,
      Value<String?> originalCurrency,
      Value<int?> originalMinorUnits,
      Value<int?> originalDecimalDigits,
      Value<int> rowid,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpenseCategory, ExpenseCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalMinorUnits => $composableBuilder(
    column: $table.originalMinorUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalDecimalDigits => $composableBuilder(
    column: $table.originalDecimalDigits,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalMinorUnits => $composableBuilder(
    column: $table.originalMinorUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalDecimalDigits => $composableBuilder(
    column: $table.originalDecimalDigits,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ExpenseCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalMinorUnits => $composableBuilder(
    column: $table.originalMinorUnits,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalDecimalDigits => $composableBuilder(
    column: $table.originalDecimalDigits,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseRow,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (
            ExpenseRow,
            BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>,
          ),
          ExpenseRow,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<ExpenseCategory> category = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> originalCurrency = const Value.absent(),
                Value<int?> originalMinorUnits = const Value.absent(),
                Value<int?> originalDecimalDigits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                title: title,
                amountCents: amountCents,
                category: category,
                date: date,
                note: note,
                originalCurrency: originalCurrency,
                originalMinorUnits: originalMinorUnits,
                originalDecimalDigits: originalDecimalDigits,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required int amountCents,
                required ExpenseCategory category,
                required DateTime date,
                Value<String?> note = const Value.absent(),
                Value<String?> originalCurrency = const Value.absent(),
                Value<int?> originalMinorUnits = const Value.absent(),
                Value<int?> originalDecimalDigits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                title: title,
                amountCents: amountCents,
                category: category,
                date: date,
                note: note,
                originalCurrency: originalCurrency,
                originalMinorUnits: originalMinorUnits,
                originalDecimalDigits: originalDecimalDigits,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, ExpenseRow>(table),
                  BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseRow,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (ExpenseRow, BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>),
      ExpenseRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({Value<int> id, required int monthlyCents});
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({Value<int> id, Value<int> monthlyCents});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => column,
  );
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
          BudgetRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> monthlyCents = const Value.absent(),
              }) => BudgetsCompanion(id: id, monthlyCents: monthlyCents),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int monthlyCents,
              }) => BudgetsCompanion.insert(id: id, monthlyCents: monthlyCents),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetRow>(table),
                  BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
      BudgetRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
}
