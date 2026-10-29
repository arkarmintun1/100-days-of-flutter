// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseFilter {

/// The first day of the month, e.g. 2026-10-01.
 DateTime get month;/// Null: all categories.
 ExpenseCategory? get category;
/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseFilterCopyWith<ExpenseFilter> get copyWith => _$ExpenseFilterCopyWithImpl<ExpenseFilter>(this as ExpenseFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExpenseFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseFilter&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.category, _this.category) || other.category == _this.category));
}


@override
int get hashCode {
  final _this = this as ExpenseFilter;
  return Object.hash(runtimeType,_this.month,_this.category);
}

@override
String toString() {
  final _this = this as ExpenseFilter;
  return 'ExpenseFilter(month: ${_this.month}, category: ${_this.category})';
}


}

/// @nodoc
abstract mixin class $ExpenseFilterCopyWith<$Res>  {
  factory $ExpenseFilterCopyWith(ExpenseFilter value, $Res Function(ExpenseFilter) _then) = _$ExpenseFilterCopyWithImpl;
@useResult
$Res call({
 DateTime month, ExpenseCategory? category
});




}
/// @nodoc
class _$ExpenseFilterCopyWithImpl<$Res>
    implements $ExpenseFilterCopyWith<$Res> {
  _$ExpenseFilterCopyWithImpl(this._self, this._then);

  final ExpenseFilter _self;
  final $Res Function(ExpenseFilter) _then;

/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? category = freezed,}) {
  return _then(ExpenseFilter(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseFilter].
extension ExpenseFilterPatterns on ExpenseFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseFilter value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  ExpenseCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
return $default(_that.month,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  ExpenseCategory? category)  $default,) {final _that = this;
switch (_that) {
case _ExpenseFilter():
return $default(_that.month,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  ExpenseCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
return $default(_that.month,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseFilter implements ExpenseFilter {
  const _ExpenseFilter({required this.month, this.category});
  

/// The first day of the month, e.g. 2026-10-01.
@override final  DateTime month;
/// Null: all categories.
@override final  ExpenseCategory? category;

/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseFilterCopyWith<_ExpenseFilter> get copyWith => __$ExpenseFilterCopyWithImpl<_ExpenseFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseFilter&&(identical(other.month, month) || other.month == month)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,category);
}

@override
String toString() {
    return 'ExpenseFilter(month: $month, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ExpenseFilterCopyWith<$Res> implements $ExpenseFilterCopyWith<$Res> {
  factory _$ExpenseFilterCopyWith(_ExpenseFilter value, $Res Function(_ExpenseFilter) _then) = __$ExpenseFilterCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, ExpenseCategory? category
});




}
/// @nodoc
class __$ExpenseFilterCopyWithImpl<$Res>
    implements _$ExpenseFilterCopyWith<$Res> {
  __$ExpenseFilterCopyWithImpl(this._self, this._then);

  final _ExpenseFilter _self;
  final $Res Function(_ExpenseFilter) _then;

/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? category = freezed,}) {
  return _then(_ExpenseFilter(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExpenseCategory?,
  ));
}


}

// dart format on
