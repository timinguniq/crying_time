// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_registration_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceRegistrationRequestDto {

 String get deviceId; String get fcmToken;/// 'android' | 'ios'.
 String get platform;/// UTC 기준 오프셋(분). 서버가 발송 시각을 기기 지역시간으로 맞출 때 쓴다.
 int get utcOffsetMinutes;
/// Create a copy of DeviceRegistrationRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRegistrationRequestDtoCopyWith<DeviceRegistrationRequestDto> get copyWith => _$DeviceRegistrationRequestDtoCopyWithImpl<DeviceRegistrationRequestDto>(this as DeviceRegistrationRequestDto, _$identity);

  /// Serializes this DeviceRegistrationRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRegistrationRequestDto&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.utcOffsetMinutes, utcOffsetMinutes) || other.utcOffsetMinutes == utcOffsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,fcmToken,platform,utcOffsetMinutes);

@override
String toString() {
  return 'DeviceRegistrationRequestDto(deviceId: $deviceId, fcmToken: $fcmToken, platform: $platform, utcOffsetMinutes: $utcOffsetMinutes)';
}


}

/// @nodoc
abstract mixin class $DeviceRegistrationRequestDtoCopyWith<$Res>  {
  factory $DeviceRegistrationRequestDtoCopyWith(DeviceRegistrationRequestDto value, $Res Function(DeviceRegistrationRequestDto) _then) = _$DeviceRegistrationRequestDtoCopyWithImpl;
@useResult
$Res call({
 String deviceId, String fcmToken, String platform, int utcOffsetMinutes
});




}
/// @nodoc
class _$DeviceRegistrationRequestDtoCopyWithImpl<$Res>
    implements $DeviceRegistrationRequestDtoCopyWith<$Res> {
  _$DeviceRegistrationRequestDtoCopyWithImpl(this._self, this._then);

  final DeviceRegistrationRequestDto _self;
  final $Res Function(DeviceRegistrationRequestDto) _then;

/// Create a copy of DeviceRegistrationRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? fcmToken = null,Object? platform = null,Object? utcOffsetMinutes = null,}) {
  return _then(DeviceRegistrationRequestDto(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,utcOffsetMinutes: null == utcOffsetMinutes ? _self.utcOffsetMinutes : utcOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceRegistrationRequestDto].
extension DeviceRegistrationRequestDtoPatterns on DeviceRegistrationRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRegistrationRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRegistrationRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRegistrationRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRegistrationRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String fcmToken,  String platform,  int utcOffsetMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRegistrationRequestDto() when $default != null:
return $default(_that.deviceId,_that.fcmToken,_that.platform,_that.utcOffsetMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String fcmToken,  String platform,  int utcOffsetMinutes)  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationRequestDto():
return $default(_that.deviceId,_that.fcmToken,_that.platform,_that.utcOffsetMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String fcmToken,  String platform,  int utcOffsetMinutes)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationRequestDto() when $default != null:
return $default(_that.deviceId,_that.fcmToken,_that.platform,_that.utcOffsetMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceRegistrationRequestDto implements DeviceRegistrationRequestDto {
  const _DeviceRegistrationRequestDto({required this.deviceId, required this.fcmToken, required this.platform, required this.utcOffsetMinutes});
  factory _DeviceRegistrationRequestDto.fromJson(Map<String, dynamic> json) => _$DeviceRegistrationRequestDtoFromJson(json);

@override final  String deviceId;
@override final  String fcmToken;
/// 'android' | 'ios'.
@override final  String platform;
/// UTC 기준 오프셋(분). 서버가 발송 시각을 기기 지역시간으로 맞출 때 쓴다.
@override final  int utcOffsetMinutes;

/// Create a copy of DeviceRegistrationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRegistrationRequestDtoCopyWith<_DeviceRegistrationRequestDto> get copyWith => __$DeviceRegistrationRequestDtoCopyWithImpl<_DeviceRegistrationRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceRegistrationRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRegistrationRequestDto&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.utcOffsetMinutes, utcOffsetMinutes) || other.utcOffsetMinutes == utcOffsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,fcmToken,platform,utcOffsetMinutes);

@override
String toString() {
  return 'DeviceRegistrationRequestDto(deviceId: $deviceId, fcmToken: $fcmToken, platform: $platform, utcOffsetMinutes: $utcOffsetMinutes)';
}


}

/// @nodoc
abstract mixin class _$DeviceRegistrationRequestDtoCopyWith<$Res> implements $DeviceRegistrationRequestDtoCopyWith<$Res> {
  factory _$DeviceRegistrationRequestDtoCopyWith(_DeviceRegistrationRequestDto value, $Res Function(_DeviceRegistrationRequestDto) _then) = __$DeviceRegistrationRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String fcmToken, String platform, int utcOffsetMinutes
});




}
/// @nodoc
class __$DeviceRegistrationRequestDtoCopyWithImpl<$Res>
    implements _$DeviceRegistrationRequestDtoCopyWith<$Res> {
  __$DeviceRegistrationRequestDtoCopyWithImpl(this._self, this._then);

  final _DeviceRegistrationRequestDto _self;
  final $Res Function(_DeviceRegistrationRequestDto) _then;

/// Create a copy of DeviceRegistrationRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? fcmToken = null,Object? platform = null,Object? utcOffsetMinutes = null,}) {
  return _then(_DeviceRegistrationRequestDto(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,utcOffsetMinutes: null == utcOffsetMinutes ? _self.utcOffsetMinutes : utcOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
