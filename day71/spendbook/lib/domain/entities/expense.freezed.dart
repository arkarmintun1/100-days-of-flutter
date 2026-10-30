// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Expense {

 String get id; String get title;/// In cents: $12.50 is 1250. Integers add up exactly; doubles
/// don't (0.1 + 0.2 is 0.30000000000000004).
 int get amountCents; ExpenseCategory get category; DateTime get date; String? get note;/// What was really paid, when it wasn't in the app's currency
/// (Day 63). amountCents is then the converted amount.
 ForeignAmount? get original;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Expense;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.amountCents, _this.amountCents) || other.amountCents == _this.amountCents)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.original, _this.original) || other.original == _this.original));
}


@override
int get hashCode {
  final _this = this as Expense;
  return Object.hash(runtimeType,_this.id,_this.title,_this.amountCents,_this.category,_this.date,_this.note,_this.original);
}

@override
String toString() {
  final _this = this as Expense;
  return 'Expense(id: ${_this.id}, title: ${_this.title}, amountCents: ${_this.amountCents}, category: ${_this.category}, date: ${_this.date}, note: ${_this.note}, original: ${_this.original})';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String title, int amountCents, ExpenseCategory category, DateTime date, String? note, ForeignAmount? original
});


$ForeignAmountCopyWith<$Res>? get original;

}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? amountCents = null,Object? category = null,Object? date = null,Object? note = freezed,Object? original = freezed,}) {
  return _then(Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as ForeignAmount?,
  ));
}
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForeignAmountCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $ForeignAmountCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}
}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int amountCents,  ExpenseCategory category,  DateTime date,  String? note,  ForeignAmount? original)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.title,_that.amountCents,_that.category,_that.date,_that.note,_that.original);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int amountCents,  ExpenseCategory category,  DateTime date,  String? note,  ForeignAmount? original)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.title,_that.amountCents,_that.category,_that.date,_that.note,_that.original);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int amountCents,  ExpenseCategory category,  DateTime date,  String? note,  ForeignAmount? original)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.title,_that.amountCents,_that.category,_that.date,_that.note,_that.original);case _:
  return null;

}
}

}

/// @nodoc


class _Expense implements Expense {
  const _Expense({required this.id, required this.title, required this.amountCents, required this.category, required this.date, this.note, this.original});
  

@override final  String id;
@override final  String title;
/// In cents: $12.50 is 1250. Integers add up exactly; doubles
/// don't (0.1 + 0.2 is 0.30000000000000004).
@override final  int amountCents;
@override final  ExpenseCategory category;
@override final  DateTime date;
@override final  String? note;
/// What was really paid, when it wasn't in the app's currency
/// (Day 63). amountCents is then the converted amount.
@override final  ForeignAmount? original;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.original, original) || other.original == original));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,amountCents,category,date,note,original);
}

@override
String toString() {
    return 'Expense(id: $id, title: $title, amountCents: $amountCents, category: $category, date: $date, note: $note, original: $original)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int amountCents, ExpenseCategory category, DateTime date, String? note, ForeignAmount? original
});


@override $ForeignAmountCopyWith<$Res>? get original;

}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amountCents = null,Object? category = null,Object? date = null,Object? note = freezed,Object? original = freezed,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as ForeignAmount?,
  ));
}

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForeignAmountCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $ForeignAmountCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}
}

/// @nodoc
mixin _$ForeignAmount {

/// ISO 4217 code, e.g. 'SGD'.
 String get currency;/// In the currency's smallest unit: SGD 16.00 is 1600, JPY 1500 is 1500.
 int get minorUnits;/// How many decimals the currency has: 2 for SGD, 0 for JPY.
 int get decimalDigits;
/// Create a copy of ForeignAmount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForeignAmountCopyWith<ForeignAmount> get copyWith => _$ForeignAmountCopyWithImpl<ForeignAmount>(this as ForeignAmount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ForeignAmount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForeignAmount&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.minorUnits, _this.minorUnits) || other.minorUnits == _this.minorUnits)&&(identical(other.decimalDigits, _this.decimalDigits) || other.decimalDigits == _this.decimalDigits));
}


@override
int get hashCode {
  final _this = this as ForeignAmount;
  return Object.hash(runtimeType,_this.currency,_this.minorUnits,_this.decimalDigits);
}

@override
String toString() {
  final _this = this as ForeignAmount;
  return 'ForeignAmount(currency: ${_this.currency}, minorUnits: ${_this.minorUnits}, decimalDigits: ${_this.decimalDigits})';
}


}

/// @nodoc
abstract mixin class $ForeignAmountCopyWith<$Res>  {
  factory $ForeignAmountCopyWith(ForeignAmount value, $Res Function(ForeignAmount) _then) = _$ForeignAmountCopyWithImpl;
@useResult
$Res call({
 String currency, int minorUnits, int decimalDigits
});




}
/// @nodoc
class _$ForeignAmountCopyWithImpl<$Res>
    implements $ForeignAmountCopyWith<$Res> {
  _$ForeignAmountCopyWithImpl(this._self, this._then);

  final ForeignAmount _self;
  final $Res Function(ForeignAmount) _then;

/// Create a copy of ForeignAmount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? minorUnits = null,Object? decimalDigits = null,}) {
  return _then(ForeignAmount(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,minorUnits: null == minorUnits ? _self.minorUnits : minorUnits // ignore: cast_nullable_to_non_nullable
as int,decimalDigits: null == decimalDigits ? _self.decimalDigits : decimalDigits // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ForeignAmount].
extension ForeignAmountPatterns on ForeignAmount {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForeignAmount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForeignAmount() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForeignAmount value)  $default,){
final _that = this;
switch (_that) {
case _ForeignAmount():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForeignAmount value)?  $default,){
final _that = this;
switch (_that) {
case _ForeignAmount() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency,  int minorUnits,  int decimalDigits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForeignAmount() when $default != null:
return $default(_that.currency,_that.minorUnits,_that.decimalDigits);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency,  int minorUnits,  int decimalDigits)  $default,) {final _that = this;
switch (_that) {
case _ForeignAmount():
return $default(_that.currency,_that.minorUnits,_that.decimalDigits);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency,  int minorUnits,  int decimalDigits)?  $default,) {final _that = this;
switch (_that) {
case _ForeignAmount() when $default != null:
return $default(_that.currency,_that.minorUnits,_that.decimalDigits);case _:
  return null;

}
}

}

/// @nodoc


class _ForeignAmount implements ForeignAmount {
  const _ForeignAmount({required this.currency, required this.minorUnits, required this.decimalDigits});
  

/// ISO 4217 code, e.g. 'SGD'.
@override final  String currency;
/// In the currency's smallest unit: SGD 16.00 is 1600, JPY 1500 is 1500.
@override final  int minorUnits;
/// How many decimals the currency has: 2 for SGD, 0 for JPY.
@override final  int decimalDigits;

/// Create a copy of ForeignAmount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForeignAmountCopyWith<_ForeignAmount> get copyWith => __$ForeignAmountCopyWithImpl<_ForeignAmount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForeignAmount&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.minorUnits, minorUnits) || other.minorUnits == minorUnits)&&(identical(other.decimalDigits, decimalDigits) || other.decimalDigits == decimalDigits));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currency,minorUnits,decimalDigits);
}

@override
String toString() {
    return 'ForeignAmount(currency: $currency, minorUnits: $minorUnits, decimalDigits: $decimalDigits)';
}


}

/// @nodoc
abstract mixin class _$ForeignAmountCopyWith<$Res> implements $ForeignAmountCopyWith<$Res> {
  factory _$ForeignAmountCopyWith(_ForeignAmount value, $Res Function(_ForeignAmount) _then) = __$ForeignAmountCopyWithImpl;
@override @useResult
$Res call({
 String currency, int minorUnits, int decimalDigits
});




}
/// @nodoc
class __$ForeignAmountCopyWithImpl<$Res>
    implements _$ForeignAmountCopyWith<$Res> {
  __$ForeignAmountCopyWithImpl(this._self, this._then);

  final _ForeignAmount _self;
  final $Res Function(_ForeignAmount) _then;

/// Create a copy of ForeignAmount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? minorUnits = null,Object? decimalDigits = null,}) {
  return _then(_ForeignAmount(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,minorUnits: null == minorUnits ? _self.minorUnits : minorUnits // ignore: cast_nullable_to_non_nullable
as int,decimalDigits: null == decimalDigits ? _self.decimalDigits : decimalDigits // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
