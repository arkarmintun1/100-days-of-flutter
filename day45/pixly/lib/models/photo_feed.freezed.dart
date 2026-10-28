// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhotoFeed {

 List<Photo> get photos; int get page; bool get hasMore; bool get isLoadingMore; String? get loadMoreError;
/// Create a copy of PhotoFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoFeedCopyWith<PhotoFeed> get copyWith => _$PhotoFeedCopyWithImpl<PhotoFeed>(this as PhotoFeed, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PhotoFeed;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoFeed&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.loadMoreError, _this.loadMoreError) || other.loadMoreError == _this.loadMoreError));
}


@override
int get hashCode {
  final _this = this as PhotoFeed;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.photos),_this.page,_this.hasMore,_this.isLoadingMore,_this.loadMoreError);
}

@override
String toString() {
  final _this = this as PhotoFeed;
  return 'PhotoFeed(photos: ${_this.photos}, page: ${_this.page}, hasMore: ${_this.hasMore}, isLoadingMore: ${_this.isLoadingMore}, loadMoreError: ${_this.loadMoreError})';
}


}

/// @nodoc
abstract mixin class $PhotoFeedCopyWith<$Res>  {
  factory $PhotoFeedCopyWith(PhotoFeed value, $Res Function(PhotoFeed) _then) = _$PhotoFeedCopyWithImpl;
@useResult
$Res call({
 List<Photo> photos, int page, bool hasMore, bool isLoadingMore, String? loadMoreError
});




}
/// @nodoc
class _$PhotoFeedCopyWithImpl<$Res>
    implements $PhotoFeedCopyWith<$Res> {
  _$PhotoFeedCopyWithImpl(this._self, this._then);

  final PhotoFeed _self;
  final $Res Function(PhotoFeed) _then;

/// Create a copy of PhotoFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photos = null,Object? page = null,Object? hasMore = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(PhotoFeed(
photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<Photo>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoFeed].
extension PhotoFeedPatterns on PhotoFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoFeed value)  $default,){
final _that = this;
switch (_that) {
case _PhotoFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoFeed value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Photo> photos,  int page,  bool hasMore,  bool isLoadingMore,  String? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoFeed() when $default != null:
return $default(_that.photos,_that.page,_that.hasMore,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Photo> photos,  int page,  bool hasMore,  bool isLoadingMore,  String? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _PhotoFeed():
return $default(_that.photos,_that.page,_that.hasMore,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Photo> photos,  int page,  bool hasMore,  bool isLoadingMore,  String? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _PhotoFeed() when $default != null:
return $default(_that.photos,_that.page,_that.hasMore,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _PhotoFeed extends PhotoFeed {
  const _PhotoFeed({required  List<Photo> photos, required this.page, required this.hasMore, this.isLoadingMore = false, this.loadMoreError}): _photos = photos,super._();
  

 final  List<Photo> _photos;
@override List<Photo> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  int page;
@override final  bool hasMore;
@override@JsonKey() final  bool isLoadingMore;
@override final  String? loadMoreError;

/// Create a copy of PhotoFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoFeedCopyWith<_PhotoFeed> get copyWith => __$PhotoFeedCopyWithImpl<_PhotoFeed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoFeed&&const DeepCollectionEquality().equals(other.photos, _photos)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_photos),page,hasMore,isLoadingMore,loadMoreError);
}

@override
String toString() {
    return 'PhotoFeed(photos: $photos, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$PhotoFeedCopyWith<$Res> implements $PhotoFeedCopyWith<$Res> {
  factory _$PhotoFeedCopyWith(_PhotoFeed value, $Res Function(_PhotoFeed) _then) = __$PhotoFeedCopyWithImpl;
@override @useResult
$Res call({
 List<Photo> photos, int page, bool hasMore, bool isLoadingMore, String? loadMoreError
});




}
/// @nodoc
class __$PhotoFeedCopyWithImpl<$Res>
    implements _$PhotoFeedCopyWith<$Res> {
  __$PhotoFeedCopyWithImpl(this._self, this._then);

  final _PhotoFeed _self;
  final $Res Function(_PhotoFeed) _then;

/// Create a copy of PhotoFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photos = null,Object? page = null,Object? hasMore = null,Object? isLoadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_PhotoFeed(
photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<Photo>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
