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



// dart format on
