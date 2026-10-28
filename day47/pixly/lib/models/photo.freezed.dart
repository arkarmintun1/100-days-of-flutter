// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Photo {

 int get id; int get width; int get height; String get url; String get photographer; String get photographerUrl; String get avgColor; String get alt; PhotoSrc get src;
/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoCopyWith<Photo> get copyWith => _$PhotoCopyWithImpl<Photo>(this as Photo, _$identity);

  /// Serializes this Photo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Photo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Photo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.photographer, _this.photographer) || other.photographer == _this.photographer)&&(identical(other.photographerUrl, _this.photographerUrl) || other.photographerUrl == _this.photographerUrl)&&(identical(other.avgColor, _this.avgColor) || other.avgColor == _this.avgColor)&&(identical(other.alt, _this.alt) || other.alt == _this.alt)&&(identical(other.src, _this.src) || other.src == _this.src));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Photo;
  return Object.hash(runtimeType,_this.id,_this.width,_this.height,_this.url,_this.photographer,_this.photographerUrl,_this.avgColor,_this.alt,_this.src);
}

@override
String toString() {
  final _this = this as Photo;
  return 'Photo(id: ${_this.id}, width: ${_this.width}, height: ${_this.height}, url: ${_this.url}, photographer: ${_this.photographer}, photographerUrl: ${_this.photographerUrl}, avgColor: ${_this.avgColor}, alt: ${_this.alt}, src: ${_this.src})';
}


}

/// @nodoc
abstract mixin class $PhotoCopyWith<$Res>  {
  factory $PhotoCopyWith(Photo value, $Res Function(Photo) _then) = _$PhotoCopyWithImpl;
@useResult
$Res call({
 int id, int width, int height, String url, String photographer, String photographerUrl, String avgColor, String alt, PhotoSrc src
});


$PhotoSrcCopyWith<$Res> get src;

}
/// @nodoc
class _$PhotoCopyWithImpl<$Res>
    implements $PhotoCopyWith<$Res> {
  _$PhotoCopyWithImpl(this._self, this._then);

  final Photo _self;
  final $Res Function(Photo) _then;

/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? width = null,Object? height = null,Object? url = null,Object? photographer = null,Object? photographerUrl = null,Object? avgColor = null,Object? alt = null,Object? src = null,}) {
  return _then(Photo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,photographer: null == photographer ? _self.photographer : photographer // ignore: cast_nullable_to_non_nullable
as String,photographerUrl: null == photographerUrl ? _self.photographerUrl : photographerUrl // ignore: cast_nullable_to_non_nullable
as String,avgColor: null == avgColor ? _self.avgColor : avgColor // ignore: cast_nullable_to_non_nullable
as String,alt: null == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as PhotoSrc,
  ));
}
/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhotoSrcCopyWith<$Res> get src {
  
  return $PhotoSrcCopyWith<$Res>(_self.src, (value) {
    return _then(_self.copyWith(src: value));
  });
}
}


/// Adds pattern-matching-related methods to [Photo].
extension PhotoPatterns on Photo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Photo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Photo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Photo value)  $default,){
final _that = this;
switch (_that) {
case _Photo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Photo value)?  $default,){
final _that = this;
switch (_that) {
case _Photo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int width,  int height,  String url,  String photographer,  String photographerUrl,  String avgColor,  String alt,  PhotoSrc src)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Photo() when $default != null:
return $default(_that.id,_that.width,_that.height,_that.url,_that.photographer,_that.photographerUrl,_that.avgColor,_that.alt,_that.src);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int width,  int height,  String url,  String photographer,  String photographerUrl,  String avgColor,  String alt,  PhotoSrc src)  $default,) {final _that = this;
switch (_that) {
case _Photo():
return $default(_that.id,_that.width,_that.height,_that.url,_that.photographer,_that.photographerUrl,_that.avgColor,_that.alt,_that.src);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int width,  int height,  String url,  String photographer,  String photographerUrl,  String avgColor,  String alt,  PhotoSrc src)?  $default,) {final _that = this;
switch (_that) {
case _Photo() when $default != null:
return $default(_that.id,_that.width,_that.height,_that.url,_that.photographer,_that.photographerUrl,_that.avgColor,_that.alt,_that.src);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Photo extends Photo {
  const _Photo({required this.id, this.width = 0, this.height = 0, this.url = '', this.photographer = 'Unknown', this.photographerUrl = '', this.avgColor = '#9E9E9E', this.alt = '', required this.src}): super._();
  factory _Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

@override final  int id;
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;
@override@JsonKey() final  String url;
@override@JsonKey() final  String photographer;
@override@JsonKey() final  String photographerUrl;
@override@JsonKey() final  String avgColor;
@override@JsonKey() final  String alt;
@override final  PhotoSrc src;

/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoCopyWith<_Photo> get copyWith => __$PhotoCopyWithImpl<_Photo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Photo&&(identical(other.id, id) || other.id == id)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.url, url) || other.url == url)&&(identical(other.photographer, photographer) || other.photographer == photographer)&&(identical(other.photographerUrl, photographerUrl) || other.photographerUrl == photographerUrl)&&(identical(other.avgColor, avgColor) || other.avgColor == avgColor)&&(identical(other.alt, alt) || other.alt == alt)&&(identical(other.src, src) || other.src == src));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,width,height,url,photographer,photographerUrl,avgColor,alt,src);
}

@override
String toString() {
    return 'Photo(id: $id, width: $width, height: $height, url: $url, photographer: $photographer, photographerUrl: $photographerUrl, avgColor: $avgColor, alt: $alt, src: $src)';
}


}

/// @nodoc
abstract mixin class _$PhotoCopyWith<$Res> implements $PhotoCopyWith<$Res> {
  factory _$PhotoCopyWith(_Photo value, $Res Function(_Photo) _then) = __$PhotoCopyWithImpl;
@override @useResult
$Res call({
 int id, int width, int height, String url, String photographer, String photographerUrl, String avgColor, String alt, PhotoSrc src
});


@override $PhotoSrcCopyWith<$Res> get src;

}
/// @nodoc
class __$PhotoCopyWithImpl<$Res>
    implements _$PhotoCopyWith<$Res> {
  __$PhotoCopyWithImpl(this._self, this._then);

  final _Photo _self;
  final $Res Function(_Photo) _then;

/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? width = null,Object? height = null,Object? url = null,Object? photographer = null,Object? photographerUrl = null,Object? avgColor = null,Object? alt = null,Object? src = null,}) {
  return _then(_Photo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,photographer: null == photographer ? _self.photographer : photographer // ignore: cast_nullable_to_non_nullable
as String,photographerUrl: null == photographerUrl ? _self.photographerUrl : photographerUrl // ignore: cast_nullable_to_non_nullable
as String,avgColor: null == avgColor ? _self.avgColor : avgColor // ignore: cast_nullable_to_non_nullable
as String,alt: null == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as PhotoSrc,
  ));
}

/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhotoSrcCopyWith<$Res> get src {
  
  return $PhotoSrcCopyWith<$Res>(_self.src, (value) {
    return _then(_self.copyWith(src: value));
  });
}
}

// dart format on
