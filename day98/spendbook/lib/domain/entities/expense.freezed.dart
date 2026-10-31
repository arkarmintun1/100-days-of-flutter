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



/// @nodoc
mixin _$ForeignAmount {


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



// dart format on
