// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_schedule_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushScheduleRequestDto {

 bool get enabled;/// 수령 가능일 며칠 전에 보낼지. 당일은 0. 먼 시점부터 정렬돼 있다.
 List<int> get offsetDays;/// 'yyyy-MM-dd'.
 String get nextPickupDate; int get utcOffsetMinutes;
/// Create a copy of PushScheduleRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushScheduleRequestDtoCopyWith<PushScheduleRequestDto> get copyWith => _$PushScheduleRequestDtoCopyWithImpl<PushScheduleRequestDto>(this as PushScheduleRequestDto, _$identity);

  /// Serializes this PushScheduleRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushScheduleRequestDto&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.offsetDays, offsetDays)&&(identical(other.nextPickupDate, nextPickupDate) || other.nextPickupDate == nextPickupDate)&&(identical(other.utcOffsetMinutes, utcOffsetMinutes) || other.utcOffsetMinutes == utcOffsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(offsetDays),nextPickupDate,utcOffsetMinutes);

@override
String toString() {
  return 'PushScheduleRequestDto(enabled: $enabled, offsetDays: $offsetDays, nextPickupDate: $nextPickupDate, utcOffsetMinutes: $utcOffsetMinutes)';
}


}

/// @nodoc
abstract mixin class $PushScheduleRequestDtoCopyWith<$Res>  {
  factory $PushScheduleRequestDtoCopyWith(PushScheduleRequestDto value, $Res Function(PushScheduleRequestDto) _then) = _$PushScheduleRequestDtoCopyWithImpl;
@useResult
$Res call({
 bool enabled, List<int> offsetDays, String nextPickupDate, int utcOffsetMinutes
});




}
/// @nodoc
class _$PushScheduleRequestDtoCopyWithImpl<$Res>
    implements $PushScheduleRequestDtoCopyWith<$Res> {
  _$PushScheduleRequestDtoCopyWithImpl(this._self, this._then);

  final PushScheduleRequestDto _self;
  final $Res Function(PushScheduleRequestDto) _then;

/// Create a copy of PushScheduleRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? offsetDays = null,Object? nextPickupDate = null,Object? utcOffsetMinutes = null,}) {
  return _then(PushScheduleRequestDto(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,offsetDays: null == offsetDays ? _self.offsetDays : offsetDays // ignore: cast_nullable_to_non_nullable
as List<int>,nextPickupDate: null == nextPickupDate ? _self.nextPickupDate : nextPickupDate // ignore: cast_nullable_to_non_nullable
as String,utcOffsetMinutes: null == utcOffsetMinutes ? _self.utcOffsetMinutes : utcOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PushScheduleRequestDto].
extension PushScheduleRequestDtoPatterns on PushScheduleRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushScheduleRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushScheduleRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushScheduleRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _PushScheduleRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushScheduleRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _PushScheduleRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  List<int> offsetDays,  String nextPickupDate,  int utcOffsetMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushScheduleRequestDto() when $default != null:
return $default(_that.enabled,_that.offsetDays,_that.nextPickupDate,_that.utcOffsetMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  List<int> offsetDays,  String nextPickupDate,  int utcOffsetMinutes)  $default,) {final _that = this;
switch (_that) {
case _PushScheduleRequestDto():
return $default(_that.enabled,_that.offsetDays,_that.nextPickupDate,_that.utcOffsetMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  List<int> offsetDays,  String nextPickupDate,  int utcOffsetMinutes)?  $default,) {final _that = this;
switch (_that) {
case _PushScheduleRequestDto() when $default != null:
return $default(_that.enabled,_that.offsetDays,_that.nextPickupDate,_that.utcOffsetMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushScheduleRequestDto implements PushScheduleRequestDto {
  const _PushScheduleRequestDto({required this.enabled, required  List<int> offsetDays, required this.nextPickupDate, required this.utcOffsetMinutes}): _offsetDays = offsetDays;
  factory _PushScheduleRequestDto.fromJson(Map<String, dynamic> json) => _$PushScheduleRequestDtoFromJson(json);

@override final  bool enabled;
/// 수령 가능일 며칠 전에 보낼지. 당일은 0. 먼 시점부터 정렬돼 있다.
 final  List<int> _offsetDays;
/// 수령 가능일 며칠 전에 보낼지. 당일은 0. 먼 시점부터 정렬돼 있다.
@override List<int> get offsetDays {
  if (_offsetDays is EqualUnmodifiableListView) return _offsetDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offsetDays);
}

/// 'yyyy-MM-dd'.
@override final  String nextPickupDate;
@override final  int utcOffsetMinutes;

/// Create a copy of PushScheduleRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushScheduleRequestDtoCopyWith<_PushScheduleRequestDto> get copyWith => __$PushScheduleRequestDtoCopyWithImpl<_PushScheduleRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushScheduleRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushScheduleRequestDto&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._offsetDays, _offsetDays)&&(identical(other.nextPickupDate, nextPickupDate) || other.nextPickupDate == nextPickupDate)&&(identical(other.utcOffsetMinutes, utcOffsetMinutes) || other.utcOffsetMinutes == utcOffsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(_offsetDays),nextPickupDate,utcOffsetMinutes);

@override
String toString() {
  return 'PushScheduleRequestDto(enabled: $enabled, offsetDays: $offsetDays, nextPickupDate: $nextPickupDate, utcOffsetMinutes: $utcOffsetMinutes)';
}


}

/// @nodoc
abstract mixin class _$PushScheduleRequestDtoCopyWith<$Res> implements $PushScheduleRequestDtoCopyWith<$Res> {
  factory _$PushScheduleRequestDtoCopyWith(_PushScheduleRequestDto value, $Res Function(_PushScheduleRequestDto) _then) = __$PushScheduleRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, List<int> offsetDays, String nextPickupDate, int utcOffsetMinutes
});




}
/// @nodoc
class __$PushScheduleRequestDtoCopyWithImpl<$Res>
    implements _$PushScheduleRequestDtoCopyWith<$Res> {
  __$PushScheduleRequestDtoCopyWithImpl(this._self, this._then);

  final _PushScheduleRequestDto _self;
  final $Res Function(_PushScheduleRequestDto) _then;

/// Create a copy of PushScheduleRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? offsetDays = null,Object? nextPickupDate = null,Object? utcOffsetMinutes = null,}) {
  return _then(_PushScheduleRequestDto(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,offsetDays: null == offsetDays ? _self._offsetDays : offsetDays // ignore: cast_nullable_to_non_nullable
as List<int>,nextPickupDate: null == nextPickupDate ? _self.nextPickupDate : nextPickupDate // ignore: cast_nullable_to_non_nullable
as String,utcOffsetMinutes: null == utcOffsetMinutes ? _self.utcOffsetMinutes : utcOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
