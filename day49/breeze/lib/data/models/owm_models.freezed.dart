// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owm_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwmCurrent {

 List<OwmCondition> get weather; OwmMain get main; OwmWind get wind; int get dt; OwmSys get sys; int get timezone; String get name;
/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmCurrentCopyWith<OwmCurrent> get copyWith => _$OwmCurrentCopyWithImpl<OwmCurrent>(this as OwmCurrent, _$identity);

  /// Serializes this OwmCurrent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmCurrent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmCurrent&&const DeepCollectionEquality().equals(other.weather, _this.weather)&&(identical(other.main, _this.main) || other.main == _this.main)&&(identical(other.wind, _this.wind) || other.wind == _this.wind)&&(identical(other.dt, _this.dt) || other.dt == _this.dt)&&(identical(other.sys, _this.sys) || other.sys == _this.sys)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmCurrent;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.weather),_this.main,_this.wind,_this.dt,_this.sys,_this.timezone,_this.name);
}

@override
String toString() {
  final _this = this as OwmCurrent;
  return 'OwmCurrent(weather: ${_this.weather}, main: ${_this.main}, wind: ${_this.wind}, dt: ${_this.dt}, sys: ${_this.sys}, timezone: ${_this.timezone}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $OwmCurrentCopyWith<$Res>  {
  factory $OwmCurrentCopyWith(OwmCurrent value, $Res Function(OwmCurrent) _then) = _$OwmCurrentCopyWithImpl;
@useResult
$Res call({
 List<OwmCondition> weather, OwmMain main, OwmWind wind, int dt, OwmSys sys, int timezone, String name
});


$OwmMainCopyWith<$Res> get main;$OwmWindCopyWith<$Res> get wind;$OwmSysCopyWith<$Res> get sys;

}
/// @nodoc
class _$OwmCurrentCopyWithImpl<$Res>
    implements $OwmCurrentCopyWith<$Res> {
  _$OwmCurrentCopyWithImpl(this._self, this._then);

  final OwmCurrent _self;
  final $Res Function(OwmCurrent) _then;

/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weather = null,Object? main = null,Object? wind = null,Object? dt = null,Object? sys = null,Object? timezone = null,Object? name = null,}) {
  return _then(OwmCurrent(
weather: null == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as List<OwmCondition>,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as OwmMain,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as OwmWind,dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,sys: null == sys ? _self.sys : sys // ignore: cast_nullable_to_non_nullable
as OwmSys,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmMainCopyWith<$Res> get main {
  
  return $OwmMainCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmWindCopyWith<$Res> get wind {
  
  return $OwmWindCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmSysCopyWith<$Res> get sys {
  
  return $OwmSysCopyWith<$Res>(_self.sys, (value) {
    return _then(_self.copyWith(sys: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwmCurrent].
extension OwmCurrentPatterns on OwmCurrent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmCurrent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmCurrent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmCurrent value)  $default,){
final _that = this;
switch (_that) {
case _OwmCurrent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmCurrent value)?  $default,){
final _that = this;
switch (_that) {
case _OwmCurrent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OwmCondition> weather,  OwmMain main,  OwmWind wind,  int dt,  OwmSys sys,  int timezone,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmCurrent() when $default != null:
return $default(_that.weather,_that.main,_that.wind,_that.dt,_that.sys,_that.timezone,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OwmCondition> weather,  OwmMain main,  OwmWind wind,  int dt,  OwmSys sys,  int timezone,  String name)  $default,) {final _that = this;
switch (_that) {
case _OwmCurrent():
return $default(_that.weather,_that.main,_that.wind,_that.dt,_that.sys,_that.timezone,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OwmCondition> weather,  OwmMain main,  OwmWind wind,  int dt,  OwmSys sys,  int timezone,  String name)?  $default,) {final _that = this;
switch (_that) {
case _OwmCurrent() when $default != null:
return $default(_that.weather,_that.main,_that.wind,_that.dt,_that.sys,_that.timezone,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmCurrent implements OwmCurrent {
  const _OwmCurrent({required  List<OwmCondition> weather, required this.main, required this.wind, required this.dt, required this.sys, required this.timezone, this.name = ''}): _weather = weather;
  factory _OwmCurrent.fromJson(Map<String, dynamic> json) => _$OwmCurrentFromJson(json);

 final  List<OwmCondition> _weather;
@override List<OwmCondition> get weather {
  if (_weather is EqualUnmodifiableListView) return _weather;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weather);
}

@override final  OwmMain main;
@override final  OwmWind wind;
@override final  int dt;
@override final  OwmSys sys;
@override final  int timezone;
@override@JsonKey() final  String name;

/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmCurrentCopyWith<_OwmCurrent> get copyWith => __$OwmCurrentCopyWithImpl<_OwmCurrent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmCurrentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmCurrent&&const DeepCollectionEquality().equals(other.weather, _weather)&&(identical(other.main, main) || other.main == main)&&(identical(other.wind, wind) || other.wind == wind)&&(identical(other.dt, dt) || other.dt == dt)&&(identical(other.sys, sys) || other.sys == sys)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_weather),main,wind,dt,sys,timezone,name);
}

@override
String toString() {
    return 'OwmCurrent(weather: $weather, main: $main, wind: $wind, dt: $dt, sys: $sys, timezone: $timezone, name: $name)';
}


}

/// @nodoc
abstract mixin class _$OwmCurrentCopyWith<$Res> implements $OwmCurrentCopyWith<$Res> {
  factory _$OwmCurrentCopyWith(_OwmCurrent value, $Res Function(_OwmCurrent) _then) = __$OwmCurrentCopyWithImpl;
@override @useResult
$Res call({
 List<OwmCondition> weather, OwmMain main, OwmWind wind, int dt, OwmSys sys, int timezone, String name
});


@override $OwmMainCopyWith<$Res> get main;@override $OwmWindCopyWith<$Res> get wind;@override $OwmSysCopyWith<$Res> get sys;

}
/// @nodoc
class __$OwmCurrentCopyWithImpl<$Res>
    implements _$OwmCurrentCopyWith<$Res> {
  __$OwmCurrentCopyWithImpl(this._self, this._then);

  final _OwmCurrent _self;
  final $Res Function(_OwmCurrent) _then;

/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weather = null,Object? main = null,Object? wind = null,Object? dt = null,Object? sys = null,Object? timezone = null,Object? name = null,}) {
  return _then(_OwmCurrent(
weather: null == weather ? _self._weather : weather // ignore: cast_nullable_to_non_nullable
as List<OwmCondition>,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as OwmMain,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as OwmWind,dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,sys: null == sys ? _self.sys : sys // ignore: cast_nullable_to_non_nullable
as OwmSys,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmMainCopyWith<$Res> get main {
  
  return $OwmMainCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmWindCopyWith<$Res> get wind {
  
  return $OwmWindCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}/// Create a copy of OwmCurrent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmSysCopyWith<$Res> get sys {
  
  return $OwmSysCopyWith<$Res>(_self.sys, (value) {
    return _then(_self.copyWith(sys: value));
  });
}
}


/// @nodoc
mixin _$OwmForecast {

 List<OwmForecastItem> get list; OwmCity get city;
/// Create a copy of OwmForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmForecastCopyWith<OwmForecast> get copyWith => _$OwmForecastCopyWithImpl<OwmForecast>(this as OwmForecast, _$identity);

  /// Serializes this OwmForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmForecast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmForecast&&const DeepCollectionEquality().equals(other.list, _this.list)&&(identical(other.city, _this.city) || other.city == _this.city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmForecast;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.list),_this.city);
}

@override
String toString() {
  final _this = this as OwmForecast;
  return 'OwmForecast(list: ${_this.list}, city: ${_this.city})';
}


}

/// @nodoc
abstract mixin class $OwmForecastCopyWith<$Res>  {
  factory $OwmForecastCopyWith(OwmForecast value, $Res Function(OwmForecast) _then) = _$OwmForecastCopyWithImpl;
@useResult
$Res call({
 List<OwmForecastItem> list, OwmCity city
});


$OwmCityCopyWith<$Res> get city;

}
/// @nodoc
class _$OwmForecastCopyWithImpl<$Res>
    implements $OwmForecastCopyWith<$Res> {
  _$OwmForecastCopyWithImpl(this._self, this._then);

  final OwmForecast _self;
  final $Res Function(OwmForecast) _then;

/// Create a copy of OwmForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? city = null,}) {
  return _then(OwmForecast(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<OwmForecastItem>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as OwmCity,
  ));
}
/// Create a copy of OwmForecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmCityCopyWith<$Res> get city {
  
  return $OwmCityCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwmForecast].
extension OwmForecastPatterns on OwmForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmForecast value)  $default,){
final _that = this;
switch (_that) {
case _OwmForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmForecast value)?  $default,){
final _that = this;
switch (_that) {
case _OwmForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OwmForecastItem> list,  OwmCity city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmForecast() when $default != null:
return $default(_that.list,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OwmForecastItem> list,  OwmCity city)  $default,) {final _that = this;
switch (_that) {
case _OwmForecast():
return $default(_that.list,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OwmForecastItem> list,  OwmCity city)?  $default,) {final _that = this;
switch (_that) {
case _OwmForecast() when $default != null:
return $default(_that.list,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmForecast implements OwmForecast {
  const _OwmForecast({required  List<OwmForecastItem> list, required this.city}): _list = list;
  factory _OwmForecast.fromJson(Map<String, dynamic> json) => _$OwmForecastFromJson(json);

 final  List<OwmForecastItem> _list;
@override List<OwmForecastItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override final  OwmCity city;

/// Create a copy of OwmForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmForecastCopyWith<_OwmForecast> get copyWith => __$OwmForecastCopyWithImpl<_OwmForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmForecastToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmForecast&&const DeepCollectionEquality().equals(other.list, _list)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),city);
}

@override
String toString() {
    return 'OwmForecast(list: $list, city: $city)';
}


}

/// @nodoc
abstract mixin class _$OwmForecastCopyWith<$Res> implements $OwmForecastCopyWith<$Res> {
  factory _$OwmForecastCopyWith(_OwmForecast value, $Res Function(_OwmForecast) _then) = __$OwmForecastCopyWithImpl;
@override @useResult
$Res call({
 List<OwmForecastItem> list, OwmCity city
});


@override $OwmCityCopyWith<$Res> get city;

}
/// @nodoc
class __$OwmForecastCopyWithImpl<$Res>
    implements _$OwmForecastCopyWith<$Res> {
  __$OwmForecastCopyWithImpl(this._self, this._then);

  final _OwmForecast _self;
  final $Res Function(_OwmForecast) _then;

/// Create a copy of OwmForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? city = null,}) {
  return _then(_OwmForecast(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<OwmForecastItem>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as OwmCity,
  ));
}

/// Create a copy of OwmForecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmCityCopyWith<$Res> get city {
  
  return $OwmCityCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// @nodoc
mixin _$OwmForecastItem {

 int get dt; OwmMain get main; List<OwmCondition> get weather; OwmWind get wind;/// Probability of precipitation, 0 to 1.
 double get pop;
/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmForecastItemCopyWith<OwmForecastItem> get copyWith => _$OwmForecastItemCopyWithImpl<OwmForecastItem>(this as OwmForecastItem, _$identity);

  /// Serializes this OwmForecastItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmForecastItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmForecastItem&&(identical(other.dt, _this.dt) || other.dt == _this.dt)&&(identical(other.main, _this.main) || other.main == _this.main)&&const DeepCollectionEquality().equals(other.weather, _this.weather)&&(identical(other.wind, _this.wind) || other.wind == _this.wind)&&(identical(other.pop, _this.pop) || other.pop == _this.pop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmForecastItem;
  return Object.hash(runtimeType,_this.dt,_this.main,const DeepCollectionEquality().hash(_this.weather),_this.wind,_this.pop);
}

@override
String toString() {
  final _this = this as OwmForecastItem;
  return 'OwmForecastItem(dt: ${_this.dt}, main: ${_this.main}, weather: ${_this.weather}, wind: ${_this.wind}, pop: ${_this.pop})';
}


}

/// @nodoc
abstract mixin class $OwmForecastItemCopyWith<$Res>  {
  factory $OwmForecastItemCopyWith(OwmForecastItem value, $Res Function(OwmForecastItem) _then) = _$OwmForecastItemCopyWithImpl;
@useResult
$Res call({
 int dt, OwmMain main, List<OwmCondition> weather, OwmWind wind, double pop
});


$OwmMainCopyWith<$Res> get main;$OwmWindCopyWith<$Res> get wind;

}
/// @nodoc
class _$OwmForecastItemCopyWithImpl<$Res>
    implements $OwmForecastItemCopyWith<$Res> {
  _$OwmForecastItemCopyWithImpl(this._self, this._then);

  final OwmForecastItem _self;
  final $Res Function(OwmForecastItem) _then;

/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dt = null,Object? main = null,Object? weather = null,Object? wind = null,Object? pop = null,}) {
  return _then(OwmForecastItem(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as OwmMain,weather: null == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as List<OwmCondition>,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as OwmWind,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmMainCopyWith<$Res> get main {
  
  return $OwmMainCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmWindCopyWith<$Res> get wind {
  
  return $OwmWindCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwmForecastItem].
extension OwmForecastItemPatterns on OwmForecastItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmForecastItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmForecastItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmForecastItem value)  $default,){
final _that = this;
switch (_that) {
case _OwmForecastItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmForecastItem value)?  $default,){
final _that = this;
switch (_that) {
case _OwmForecastItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dt,  OwmMain main,  List<OwmCondition> weather,  OwmWind wind,  double pop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmForecastItem() when $default != null:
return $default(_that.dt,_that.main,_that.weather,_that.wind,_that.pop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dt,  OwmMain main,  List<OwmCondition> weather,  OwmWind wind,  double pop)  $default,) {final _that = this;
switch (_that) {
case _OwmForecastItem():
return $default(_that.dt,_that.main,_that.weather,_that.wind,_that.pop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dt,  OwmMain main,  List<OwmCondition> weather,  OwmWind wind,  double pop)?  $default,) {final _that = this;
switch (_that) {
case _OwmForecastItem() when $default != null:
return $default(_that.dt,_that.main,_that.weather,_that.wind,_that.pop);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmForecastItem implements OwmForecastItem {
  const _OwmForecastItem({required this.dt, required this.main, required  List<OwmCondition> weather, required this.wind, this.pop = 0}): _weather = weather;
  factory _OwmForecastItem.fromJson(Map<String, dynamic> json) => _$OwmForecastItemFromJson(json);

@override final  int dt;
@override final  OwmMain main;
 final  List<OwmCondition> _weather;
@override List<OwmCondition> get weather {
  if (_weather is EqualUnmodifiableListView) return _weather;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weather);
}

@override final  OwmWind wind;
/// Probability of precipitation, 0 to 1.
@override@JsonKey() final  double pop;

/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmForecastItemCopyWith<_OwmForecastItem> get copyWith => __$OwmForecastItemCopyWithImpl<_OwmForecastItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmForecastItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmForecastItem&&(identical(other.dt, dt) || other.dt == dt)&&(identical(other.main, main) || other.main == main)&&const DeepCollectionEquality().equals(other.weather, _weather)&&(identical(other.wind, wind) || other.wind == wind)&&(identical(other.pop, pop) || other.pop == pop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dt,main,const DeepCollectionEquality().hash(_weather),wind,pop);
}

@override
String toString() {
    return 'OwmForecastItem(dt: $dt, main: $main, weather: $weather, wind: $wind, pop: $pop)';
}


}

/// @nodoc
abstract mixin class _$OwmForecastItemCopyWith<$Res> implements $OwmForecastItemCopyWith<$Res> {
  factory _$OwmForecastItemCopyWith(_OwmForecastItem value, $Res Function(_OwmForecastItem) _then) = __$OwmForecastItemCopyWithImpl;
@override @useResult
$Res call({
 int dt, OwmMain main, List<OwmCondition> weather, OwmWind wind, double pop
});


@override $OwmMainCopyWith<$Res> get main;@override $OwmWindCopyWith<$Res> get wind;

}
/// @nodoc
class __$OwmForecastItemCopyWithImpl<$Res>
    implements _$OwmForecastItemCopyWith<$Res> {
  __$OwmForecastItemCopyWithImpl(this._self, this._then);

  final _OwmForecastItem _self;
  final $Res Function(_OwmForecastItem) _then;

/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dt = null,Object? main = null,Object? weather = null,Object? wind = null,Object? pop = null,}) {
  return _then(_OwmForecastItem(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as OwmMain,weather: null == weather ? _self._weather : weather // ignore: cast_nullable_to_non_nullable
as List<OwmCondition>,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as OwmWind,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmMainCopyWith<$Res> get main {
  
  return $OwmMainCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of OwmForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwmWindCopyWith<$Res> get wind {
  
  return $OwmWindCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}
}


/// @nodoc
mixin _$OwmCondition {

 int get id; String get main; String get description; String get icon;
/// Create a copy of OwmCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmConditionCopyWith<OwmCondition> get copyWith => _$OwmConditionCopyWithImpl<OwmCondition>(this as OwmCondition, _$identity);

  /// Serializes this OwmCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmCondition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmCondition&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.main, _this.main) || other.main == _this.main)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.icon, _this.icon) || other.icon == _this.icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmCondition;
  return Object.hash(runtimeType,_this.id,_this.main,_this.description,_this.icon);
}

@override
String toString() {
  final _this = this as OwmCondition;
  return 'OwmCondition(id: ${_this.id}, main: ${_this.main}, description: ${_this.description}, icon: ${_this.icon})';
}


}

/// @nodoc
abstract mixin class $OwmConditionCopyWith<$Res>  {
  factory $OwmConditionCopyWith(OwmCondition value, $Res Function(OwmCondition) _then) = _$OwmConditionCopyWithImpl;
@useResult
$Res call({
 int id, String main, String description, String icon
});




}
/// @nodoc
class _$OwmConditionCopyWithImpl<$Res>
    implements $OwmConditionCopyWith<$Res> {
  _$OwmConditionCopyWithImpl(this._self, this._then);

  final OwmCondition _self;
  final $Res Function(OwmCondition) _then;

/// Create a copy of OwmCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? main = null,Object? description = null,Object? icon = null,}) {
  return _then(OwmCondition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OwmCondition].
extension OwmConditionPatterns on OwmCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmCondition value)  $default,){
final _that = this;
switch (_that) {
case _OwmCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmCondition value)?  $default,){
final _that = this;
switch (_that) {
case _OwmCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String main,  String description,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmCondition() when $default != null:
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String main,  String description,  String icon)  $default,) {final _that = this;
switch (_that) {
case _OwmCondition():
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String main,  String description,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _OwmCondition() when $default != null:
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmCondition implements OwmCondition {
  const _OwmCondition({required this.id, required this.main, required this.description, required this.icon});
  factory _OwmCondition.fromJson(Map<String, dynamic> json) => _$OwmConditionFromJson(json);

@override final  int id;
@override final  String main;
@override final  String description;
@override final  String icon;

/// Create a copy of OwmCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmConditionCopyWith<_OwmCondition> get copyWith => __$OwmConditionCopyWithImpl<_OwmCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmConditionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmCondition&&(identical(other.id, id) || other.id == id)&&(identical(other.main, main) || other.main == main)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,main,description,icon);
}

@override
String toString() {
    return 'OwmCondition(id: $id, main: $main, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$OwmConditionCopyWith<$Res> implements $OwmConditionCopyWith<$Res> {
  factory _$OwmConditionCopyWith(_OwmCondition value, $Res Function(_OwmCondition) _then) = __$OwmConditionCopyWithImpl;
@override @useResult
$Res call({
 int id, String main, String description, String icon
});




}
/// @nodoc
class __$OwmConditionCopyWithImpl<$Res>
    implements _$OwmConditionCopyWith<$Res> {
  __$OwmConditionCopyWithImpl(this._self, this._then);

  final _OwmCondition _self;
  final $Res Function(_OwmCondition) _then;

/// Create a copy of OwmCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? main = null,Object? description = null,Object? icon = null,}) {
  return _then(_OwmCondition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OwmMain {

 double get temp; double get feelsLike; double get tempMin; double get tempMax; int get pressure; int get humidity;
/// Create a copy of OwmMain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmMainCopyWith<OwmMain> get copyWith => _$OwmMainCopyWithImpl<OwmMain>(this as OwmMain, _$identity);

  /// Serializes this OwmMain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmMain;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmMain&&(identical(other.temp, _this.temp) || other.temp == _this.temp)&&(identical(other.feelsLike, _this.feelsLike) || other.feelsLike == _this.feelsLike)&&(identical(other.tempMin, _this.tempMin) || other.tempMin == _this.tempMin)&&(identical(other.tempMax, _this.tempMax) || other.tempMax == _this.tempMax)&&(identical(other.pressure, _this.pressure) || other.pressure == _this.pressure)&&(identical(other.humidity, _this.humidity) || other.humidity == _this.humidity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmMain;
  return Object.hash(runtimeType,_this.temp,_this.feelsLike,_this.tempMin,_this.tempMax,_this.pressure,_this.humidity);
}

@override
String toString() {
  final _this = this as OwmMain;
  return 'OwmMain(temp: ${_this.temp}, feelsLike: ${_this.feelsLike}, tempMin: ${_this.tempMin}, tempMax: ${_this.tempMax}, pressure: ${_this.pressure}, humidity: ${_this.humidity})';
}


}

/// @nodoc
abstract mixin class $OwmMainCopyWith<$Res>  {
  factory $OwmMainCopyWith(OwmMain value, $Res Function(OwmMain) _then) = _$OwmMainCopyWithImpl;
@useResult
$Res call({
 double temp, double feelsLike, double tempMin, double tempMax, int pressure, int humidity
});




}
/// @nodoc
class _$OwmMainCopyWithImpl<$Res>
    implements $OwmMainCopyWith<$Res> {
  _$OwmMainCopyWithImpl(this._self, this._then);

  final OwmMain _self;
  final $Res Function(OwmMain) _then;

/// Create a copy of OwmMain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temp = null,Object? feelsLike = null,Object? tempMin = null,Object? tempMax = null,Object? pressure = null,Object? humidity = null,}) {
  return _then(OwmMain(
temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OwmMain].
extension OwmMainPatterns on OwmMain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmMain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmMain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmMain value)  $default,){
final _that = this;
switch (_that) {
case _OwmMain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmMain value)?  $default,){
final _that = this;
switch (_that) {
case _OwmMain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temp,  double feelsLike,  double tempMin,  double tempMax,  int pressure,  int humidity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmMain() when $default != null:
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.humidity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temp,  double feelsLike,  double tempMin,  double tempMax,  int pressure,  int humidity)  $default,) {final _that = this;
switch (_that) {
case _OwmMain():
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.humidity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temp,  double feelsLike,  double tempMin,  double tempMax,  int pressure,  int humidity)?  $default,) {final _that = this;
switch (_that) {
case _OwmMain() when $default != null:
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.humidity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmMain implements OwmMain {
  const _OwmMain({required this.temp, required this.feelsLike, required this.tempMin, required this.tempMax, required this.pressure, required this.humidity});
  factory _OwmMain.fromJson(Map<String, dynamic> json) => _$OwmMainFromJson(json);

@override final  double temp;
@override final  double feelsLike;
@override final  double tempMin;
@override final  double tempMax;
@override final  int pressure;
@override final  int humidity;

/// Create a copy of OwmMain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmMainCopyWith<_OwmMain> get copyWith => __$OwmMainCopyWithImpl<_OwmMain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmMainToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmMain&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.tempMin, tempMin) || other.tempMin == tempMin)&&(identical(other.tempMax, tempMax) || other.tempMax == tempMax)&&(identical(other.pressure, pressure) || other.pressure == pressure)&&(identical(other.humidity, humidity) || other.humidity == humidity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,temp,feelsLike,tempMin,tempMax,pressure,humidity);
}

@override
String toString() {
    return 'OwmMain(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, humidity: $humidity)';
}


}

/// @nodoc
abstract mixin class _$OwmMainCopyWith<$Res> implements $OwmMainCopyWith<$Res> {
  factory _$OwmMainCopyWith(_OwmMain value, $Res Function(_OwmMain) _then) = __$OwmMainCopyWithImpl;
@override @useResult
$Res call({
 double temp, double feelsLike, double tempMin, double tempMax, int pressure, int humidity
});




}
/// @nodoc
class __$OwmMainCopyWithImpl<$Res>
    implements _$OwmMainCopyWith<$Res> {
  __$OwmMainCopyWithImpl(this._self, this._then);

  final _OwmMain _self;
  final $Res Function(_OwmMain) _then;

/// Create a copy of OwmMain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temp = null,Object? feelsLike = null,Object? tempMin = null,Object? tempMax = null,Object? pressure = null,Object? humidity = null,}) {
  return _then(_OwmMain(
temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OwmWind {

 double get speed; int get deg;
/// Create a copy of OwmWind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmWindCopyWith<OwmWind> get copyWith => _$OwmWindCopyWithImpl<OwmWind>(this as OwmWind, _$identity);

  /// Serializes this OwmWind to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmWind;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmWind&&(identical(other.speed, _this.speed) || other.speed == _this.speed)&&(identical(other.deg, _this.deg) || other.deg == _this.deg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmWind;
  return Object.hash(runtimeType,_this.speed,_this.deg);
}

@override
String toString() {
  final _this = this as OwmWind;
  return 'OwmWind(speed: ${_this.speed}, deg: ${_this.deg})';
}


}

/// @nodoc
abstract mixin class $OwmWindCopyWith<$Res>  {
  factory $OwmWindCopyWith(OwmWind value, $Res Function(OwmWind) _then) = _$OwmWindCopyWithImpl;
@useResult
$Res call({
 double speed, int deg
});




}
/// @nodoc
class _$OwmWindCopyWithImpl<$Res>
    implements $OwmWindCopyWith<$Res> {
  _$OwmWindCopyWithImpl(this._self, this._then);

  final OwmWind _self;
  final $Res Function(OwmWind) _then;

/// Create a copy of OwmWind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speed = null,Object? deg = null,}) {
  return _then(OwmWind(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,deg: null == deg ? _self.deg : deg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OwmWind].
extension OwmWindPatterns on OwmWind {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmWind value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmWind() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmWind value)  $default,){
final _that = this;
switch (_that) {
case _OwmWind():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmWind value)?  $default,){
final _that = this;
switch (_that) {
case _OwmWind() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double speed,  int deg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmWind() when $default != null:
return $default(_that.speed,_that.deg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double speed,  int deg)  $default,) {final _that = this;
switch (_that) {
case _OwmWind():
return $default(_that.speed,_that.deg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double speed,  int deg)?  $default,) {final _that = this;
switch (_that) {
case _OwmWind() when $default != null:
return $default(_that.speed,_that.deg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmWind implements OwmWind {
  const _OwmWind({required this.speed, this.deg = 0});
  factory _OwmWind.fromJson(Map<String, dynamic> json) => _$OwmWindFromJson(json);

@override final  double speed;
@override@JsonKey() final  int deg;

/// Create a copy of OwmWind
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmWindCopyWith<_OwmWind> get copyWith => __$OwmWindCopyWithImpl<_OwmWind>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmWindToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmWind&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.deg, deg) || other.deg == deg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,speed,deg);
}

@override
String toString() {
    return 'OwmWind(speed: $speed, deg: $deg)';
}


}

/// @nodoc
abstract mixin class _$OwmWindCopyWith<$Res> implements $OwmWindCopyWith<$Res> {
  factory _$OwmWindCopyWith(_OwmWind value, $Res Function(_OwmWind) _then) = __$OwmWindCopyWithImpl;
@override @useResult
$Res call({
 double speed, int deg
});




}
/// @nodoc
class __$OwmWindCopyWithImpl<$Res>
    implements _$OwmWindCopyWith<$Res> {
  __$OwmWindCopyWithImpl(this._self, this._then);

  final _OwmWind _self;
  final $Res Function(_OwmWind) _then;

/// Create a copy of OwmWind
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speed = null,Object? deg = null,}) {
  return _then(_OwmWind(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,deg: null == deg ? _self.deg : deg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OwmSys {

 String? get country; int? get sunrise; int? get sunset;
/// Create a copy of OwmSys
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmSysCopyWith<OwmSys> get copyWith => _$OwmSysCopyWithImpl<OwmSys>(this as OwmSys, _$identity);

  /// Serializes this OwmSys to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmSys;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmSys&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.sunrise, _this.sunrise) || other.sunrise == _this.sunrise)&&(identical(other.sunset, _this.sunset) || other.sunset == _this.sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmSys;
  return Object.hash(runtimeType,_this.country,_this.sunrise,_this.sunset);
}

@override
String toString() {
  final _this = this as OwmSys;
  return 'OwmSys(country: ${_this.country}, sunrise: ${_this.sunrise}, sunset: ${_this.sunset})';
}


}

/// @nodoc
abstract mixin class $OwmSysCopyWith<$Res>  {
  factory $OwmSysCopyWith(OwmSys value, $Res Function(OwmSys) _then) = _$OwmSysCopyWithImpl;
@useResult
$Res call({
 String? country, int? sunrise, int? sunset
});




}
/// @nodoc
class _$OwmSysCopyWithImpl<$Res>
    implements $OwmSysCopyWith<$Res> {
  _$OwmSysCopyWithImpl(this._self, this._then);

  final OwmSys _self;
  final $Res Function(OwmSys) _then;

/// Create a copy of OwmSys
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? country = freezed,Object? sunrise = freezed,Object? sunset = freezed,}) {
  return _then(OwmSys(
country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,sunrise: freezed == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as int?,sunset: freezed == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [OwmSys].
extension OwmSysPatterns on OwmSys {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmSys value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmSys() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmSys value)  $default,){
final _that = this;
switch (_that) {
case _OwmSys():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmSys value)?  $default,){
final _that = this;
switch (_that) {
case _OwmSys() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? country,  int? sunrise,  int? sunset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmSys() when $default != null:
return $default(_that.country,_that.sunrise,_that.sunset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? country,  int? sunrise,  int? sunset)  $default,) {final _that = this;
switch (_that) {
case _OwmSys():
return $default(_that.country,_that.sunrise,_that.sunset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? country,  int? sunrise,  int? sunset)?  $default,) {final _that = this;
switch (_that) {
case _OwmSys() when $default != null:
return $default(_that.country,_that.sunrise,_that.sunset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmSys implements OwmSys {
  const _OwmSys({this.country, this.sunrise, this.sunset});
  factory _OwmSys.fromJson(Map<String, dynamic> json) => _$OwmSysFromJson(json);

@override final  String? country;
@override final  int? sunrise;
@override final  int? sunset;

/// Create a copy of OwmSys
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmSysCopyWith<_OwmSys> get copyWith => __$OwmSysCopyWithImpl<_OwmSys>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmSysToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmSys&&(identical(other.country, country) || other.country == country)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,country,sunrise,sunset);
}

@override
String toString() {
    return 'OwmSys(country: $country, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class _$OwmSysCopyWith<$Res> implements $OwmSysCopyWith<$Res> {
  factory _$OwmSysCopyWith(_OwmSys value, $Res Function(_OwmSys) _then) = __$OwmSysCopyWithImpl;
@override @useResult
$Res call({
 String? country, int? sunrise, int? sunset
});




}
/// @nodoc
class __$OwmSysCopyWithImpl<$Res>
    implements _$OwmSysCopyWith<$Res> {
  __$OwmSysCopyWithImpl(this._self, this._then);

  final _OwmSys _self;
  final $Res Function(_OwmSys) _then;

/// Create a copy of OwmSys
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? country = freezed,Object? sunrise = freezed,Object? sunset = freezed,}) {
  return _then(_OwmSys(
country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,sunrise: freezed == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as int?,sunset: freezed == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$OwmCity {

 String get name; String? get country; int get timezone;
/// Create a copy of OwmCity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwmCityCopyWith<OwmCity> get copyWith => _$OwmCityCopyWithImpl<OwmCity>(this as OwmCity, _$identity);

  /// Serializes this OwmCity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OwmCity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwmCity&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OwmCity;
  return Object.hash(runtimeType,_this.name,_this.country,_this.timezone);
}

@override
String toString() {
  final _this = this as OwmCity;
  return 'OwmCity(name: ${_this.name}, country: ${_this.country}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $OwmCityCopyWith<$Res>  {
  factory $OwmCityCopyWith(OwmCity value, $Res Function(OwmCity) _then) = _$OwmCityCopyWithImpl;
@useResult
$Res call({
 String name, String? country, int timezone
});




}
/// @nodoc
class _$OwmCityCopyWithImpl<$Res>
    implements $OwmCityCopyWith<$Res> {
  _$OwmCityCopyWithImpl(this._self, this._then);

  final OwmCity _self;
  final $Res Function(OwmCity) _then;

/// Create a copy of OwmCity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? country = freezed,Object? timezone = null,}) {
  return _then(OwmCity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OwmCity].
extension OwmCityPatterns on OwmCity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwmCity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwmCity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwmCity value)  $default,){
final _that = this;
switch (_that) {
case _OwmCity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwmCity value)?  $default,){
final _that = this;
switch (_that) {
case _OwmCity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? country,  int timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwmCity() when $default != null:
return $default(_that.name,_that.country,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? country,  int timezone)  $default,) {final _that = this;
switch (_that) {
case _OwmCity():
return $default(_that.name,_that.country,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? country,  int timezone)?  $default,) {final _that = this;
switch (_that) {
case _OwmCity() when $default != null:
return $default(_that.name,_that.country,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwmCity implements OwmCity {
  const _OwmCity({this.name = '', this.country, required this.timezone});
  factory _OwmCity.fromJson(Map<String, dynamic> json) => _$OwmCityFromJson(json);

@override@JsonKey() final  String name;
@override final  String? country;
@override final  int timezone;

/// Create a copy of OwmCity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwmCityCopyWith<_OwmCity> get copyWith => __$OwmCityCopyWithImpl<_OwmCity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwmCityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwmCity&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,country,timezone);
}

@override
String toString() {
    return 'OwmCity(name: $name, country: $country, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$OwmCityCopyWith<$Res> implements $OwmCityCopyWith<$Res> {
  factory _$OwmCityCopyWith(_OwmCity value, $Res Function(_OwmCity) _then) = __$OwmCityCopyWithImpl;
@override @useResult
$Res call({
 String name, String? country, int timezone
});




}
/// @nodoc
class __$OwmCityCopyWithImpl<$Res>
    implements _$OwmCityCopyWith<$Res> {
  __$OwmCityCopyWithImpl(this._self, this._then);

  final _OwmCity _self;
  final $Res Function(_OwmCity) _then;

/// Create a copy of OwmCity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? country = freezed,Object? timezone = null,}) {
  return _then(_OwmCity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
