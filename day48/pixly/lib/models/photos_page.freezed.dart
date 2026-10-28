// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photos_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotosPage {

 int get page; int get perPage; List<Photo> get photos; int? get totalResults; String? get nextPage;
/// Create a copy of PhotosPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotosPageCopyWith<PhotosPage> get copyWith => _$PhotosPageCopyWithImpl<PhotosPage>(this as PhotosPage, _$identity);

  /// Serializes this PhotosPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PhotosPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotosPage&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.perPage, _this.perPage) || other.perPage == _this.perPage)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&(identical(other.totalResults, _this.totalResults) || other.totalResults == _this.totalResults)&&(identical(other.nextPage, _this.nextPage) || other.nextPage == _this.nextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PhotosPage;
  return Object.hash(runtimeType,_this.page,_this.perPage,const DeepCollectionEquality().hash(_this.photos),_this.totalResults,_this.nextPage);
}

@override
String toString() {
  final _this = this as PhotosPage;
  return 'PhotosPage(page: ${_this.page}, perPage: ${_this.perPage}, photos: ${_this.photos}, totalResults: ${_this.totalResults}, nextPage: ${_this.nextPage})';
}


}

/// @nodoc
abstract mixin class $PhotosPageCopyWith<$Res>  {
  factory $PhotosPageCopyWith(PhotosPage value, $Res Function(PhotosPage) _then) = _$PhotosPageCopyWithImpl;
@useResult
$Res call({
 int page, int perPage, List<Photo> photos, int? totalResults, String? nextPage
});




}
/// @nodoc
class _$PhotosPageCopyWithImpl<$Res>
    implements $PhotosPageCopyWith<$Res> {
  _$PhotosPageCopyWithImpl(this._self, this._then);

  final PhotosPage _self;
  final $Res Function(PhotosPage) _then;

/// Create a copy of PhotosPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? perPage = null,Object? photos = null,Object? totalResults = freezed,Object? nextPage = freezed,}) {
  return _then(PhotosPage(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<Photo>,totalResults: freezed == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int?,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotosPage].
extension PhotosPagePatterns on PhotosPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotosPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotosPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotosPage value)  $default,){
final _that = this;
switch (_that) {
case _PhotosPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotosPage value)?  $default,){
final _that = this;
switch (_that) {
case _PhotosPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int perPage,  List<Photo> photos,  int? totalResults,  String? nextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotosPage() when $default != null:
return $default(_that.page,_that.perPage,_that.photos,_that.totalResults,_that.nextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int perPage,  List<Photo> photos,  int? totalResults,  String? nextPage)  $default,) {final _that = this;
switch (_that) {
case _PhotosPage():
return $default(_that.page,_that.perPage,_that.photos,_that.totalResults,_that.nextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int perPage,  List<Photo> photos,  int? totalResults,  String? nextPage)?  $default,) {final _that = this;
switch (_that) {
case _PhotosPage() when $default != null:
return $default(_that.page,_that.perPage,_that.photos,_that.totalResults,_that.nextPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotosPage extends PhotosPage {
  const _PhotosPage({this.page = 1, this.perPage = 15,  List<Photo> photos = const [], this.totalResults, this.nextPage}): _photos = photos,super._();
  factory _PhotosPage.fromJson(Map<String, dynamic> json) => _$PhotosPageFromJson(json);

@override@JsonKey() final  int page;
@override@JsonKey() final  int perPage;
 final  List<Photo> _photos;
@override@JsonKey() List<Photo> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  int? totalResults;
@override final  String? nextPage;

/// Create a copy of PhotosPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotosPageCopyWith<_PhotosPage> get copyWith => __$PhotosPageCopyWithImpl<_PhotosPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotosPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotosPage&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other.photos, _photos)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,page,perPage,const DeepCollectionEquality().hash(_photos),totalResults,nextPage);
}

@override
String toString() {
    return 'PhotosPage(page: $page, perPage: $perPage, photos: $photos, totalResults: $totalResults, nextPage: $nextPage)';
}


}

/// @nodoc
abstract mixin class _$PhotosPageCopyWith<$Res> implements $PhotosPageCopyWith<$Res> {
  factory _$PhotosPageCopyWith(_PhotosPage value, $Res Function(_PhotosPage) _then) = __$PhotosPageCopyWithImpl;
@override @useResult
$Res call({
 int page, int perPage, List<Photo> photos, int? totalResults, String? nextPage
});




}
/// @nodoc
class __$PhotosPageCopyWithImpl<$Res>
    implements _$PhotosPageCopyWith<$Res> {
  __$PhotosPageCopyWithImpl(this._self, this._then);

  final _PhotosPage _self;
  final $Res Function(_PhotosPage) _then;

/// Create a copy of PhotosPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? perPage = null,Object? photos = null,Object? totalResults = freezed,Object? nextPage = freezed,}) {
  return _then(_PhotosPage(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<Photo>,totalResults: freezed == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int?,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
