// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_src.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotoSrc {

 String get original; String get large2x; String get large; String get medium; String get small; String get portrait; String get landscape; String get tiny;
/// Create a copy of PhotoSrc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoSrcCopyWith<PhotoSrc> get copyWith => _$PhotoSrcCopyWithImpl<PhotoSrc>(this as PhotoSrc, _$identity);

  /// Serializes this PhotoSrc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PhotoSrc;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoSrc&&(identical(other.original, _this.original) || other.original == _this.original)&&(identical(other.large2x, _this.large2x) || other.large2x == _this.large2x)&&(identical(other.large, _this.large) || other.large == _this.large)&&(identical(other.medium, _this.medium) || other.medium == _this.medium)&&(identical(other.small, _this.small) || other.small == _this.small)&&(identical(other.portrait, _this.portrait) || other.portrait == _this.portrait)&&(identical(other.landscape, _this.landscape) || other.landscape == _this.landscape)&&(identical(other.tiny, _this.tiny) || other.tiny == _this.tiny));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PhotoSrc;
  return Object.hash(runtimeType,_this.original,_this.large2x,_this.large,_this.medium,_this.small,_this.portrait,_this.landscape,_this.tiny);
}

@override
String toString() {
  final _this = this as PhotoSrc;
  return 'PhotoSrc(original: ${_this.original}, large2x: ${_this.large2x}, large: ${_this.large}, medium: ${_this.medium}, small: ${_this.small}, portrait: ${_this.portrait}, landscape: ${_this.landscape}, tiny: ${_this.tiny})';
}


}

/// @nodoc
abstract mixin class $PhotoSrcCopyWith<$Res>  {
  factory $PhotoSrcCopyWith(PhotoSrc value, $Res Function(PhotoSrc) _then) = _$PhotoSrcCopyWithImpl;
@useResult
$Res call({
 String original, String large2x, String large, String medium, String small, String portrait, String landscape, String tiny
});




}
/// @nodoc
class _$PhotoSrcCopyWithImpl<$Res>
    implements $PhotoSrcCopyWith<$Res> {
  _$PhotoSrcCopyWithImpl(this._self, this._then);

  final PhotoSrc _self;
  final $Res Function(PhotoSrc) _then;

/// Create a copy of PhotoSrc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? large2x = null,Object? large = null,Object? medium = null,Object? small = null,Object? portrait = null,Object? landscape = null,Object? tiny = null,}) {
  return _then(PhotoSrc(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,large2x: null == large2x ? _self.large2x : large2x // ignore: cast_nullable_to_non_nullable
as String,large: null == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as String,medium: null == medium ? _self.medium : medium // ignore: cast_nullable_to_non_nullable
as String,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as String,portrait: null == portrait ? _self.portrait : portrait // ignore: cast_nullable_to_non_nullable
as String,landscape: null == landscape ? _self.landscape : landscape // ignore: cast_nullable_to_non_nullable
as String,tiny: null == tiny ? _self.tiny : tiny // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoSrc].
extension PhotoSrcPatterns on PhotoSrc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoSrc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoSrc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoSrc value)  $default,){
final _that = this;
switch (_that) {
case _PhotoSrc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoSrc value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoSrc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String original,  String large2x,  String large,  String medium,  String small,  String portrait,  String landscape,  String tiny)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoSrc() when $default != null:
return $default(_that.original,_that.large2x,_that.large,_that.medium,_that.small,_that.portrait,_that.landscape,_that.tiny);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String original,  String large2x,  String large,  String medium,  String small,  String portrait,  String landscape,  String tiny)  $default,) {final _that = this;
switch (_that) {
case _PhotoSrc():
return $default(_that.original,_that.large2x,_that.large,_that.medium,_that.small,_that.portrait,_that.landscape,_that.tiny);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String original,  String large2x,  String large,  String medium,  String small,  String portrait,  String landscape,  String tiny)?  $default,) {final _that = this;
switch (_that) {
case _PhotoSrc() when $default != null:
return $default(_that.original,_that.large2x,_that.large,_that.medium,_that.small,_that.portrait,_that.landscape,_that.tiny);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoSrc implements PhotoSrc {
  const _PhotoSrc({this.original = '', this.large2x = '', this.large = '', this.medium = '', this.small = '', this.portrait = '', this.landscape = '', this.tiny = ''});
  factory _PhotoSrc.fromJson(Map<String, dynamic> json) => _$PhotoSrcFromJson(json);

@override@JsonKey() final  String original;
@override@JsonKey() final  String large2x;
@override@JsonKey() final  String large;
@override@JsonKey() final  String medium;
@override@JsonKey() final  String small;
@override@JsonKey() final  String portrait;
@override@JsonKey() final  String landscape;
@override@JsonKey() final  String tiny;

/// Create a copy of PhotoSrc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoSrcCopyWith<_PhotoSrc> get copyWith => __$PhotoSrcCopyWithImpl<_PhotoSrc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoSrcToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoSrc&&(identical(other.original, original) || other.original == original)&&(identical(other.large2x, large2x) || other.large2x == large2x)&&(identical(other.large, large) || other.large == large)&&(identical(other.medium, medium) || other.medium == medium)&&(identical(other.small, small) || other.small == small)&&(identical(other.portrait, portrait) || other.portrait == portrait)&&(identical(other.landscape, landscape) || other.landscape == landscape)&&(identical(other.tiny, tiny) || other.tiny == tiny));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,original,large2x,large,medium,small,portrait,landscape,tiny);
}

@override
String toString() {
    return 'PhotoSrc(original: $original, large2x: $large2x, large: $large, medium: $medium, small: $small, portrait: $portrait, landscape: $landscape, tiny: $tiny)';
}


}

/// @nodoc
abstract mixin class _$PhotoSrcCopyWith<$Res> implements $PhotoSrcCopyWith<$Res> {
  factory _$PhotoSrcCopyWith(_PhotoSrc value, $Res Function(_PhotoSrc) _then) = __$PhotoSrcCopyWithImpl;
@override @useResult
$Res call({
 String original, String large2x, String large, String medium, String small, String portrait, String landscape, String tiny
});




}
/// @nodoc
class __$PhotoSrcCopyWithImpl<$Res>
    implements _$PhotoSrcCopyWith<$Res> {
  __$PhotoSrcCopyWithImpl(this._self, this._then);

  final _PhotoSrc _self;
  final $Res Function(_PhotoSrc) _then;

/// Create a copy of PhotoSrc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? large2x = null,Object? large = null,Object? medium = null,Object? small = null,Object? portrait = null,Object? landscape = null,Object? tiny = null,}) {
  return _then(_PhotoSrc(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,large2x: null == large2x ? _self.large2x : large2x // ignore: cast_nullable_to_non_nullable
as String,large: null == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as String,medium: null == medium ? _self.medium : medium // ignore: cast_nullable_to_non_nullable
as String,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as String,portrait: null == portrait ? _self.portrait : portrait // ignore: cast_nullable_to_non_nullable
as String,landscape: null == landscape ? _self.landscape : landscape // ignore: cast_nullable_to_non_nullable
as String,tiny: null == tiny ? _self.tiny : tiny // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
