// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceRegistration {

/// 앱 최초 실행 때 만들어 기기에 영구 저장하는 식별자.
 String get deviceId; String get fcmToken;/// 'android' | 'ios'.
 String get platform;
/// Create a copy of DeviceRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRegistrationCopyWith<DeviceRegistration> get copyWith => _$DeviceRegistrationCopyWithImpl<DeviceRegistration>(this as DeviceRegistration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRegistration&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.platform, platform) || other.platform == platform));
}


@override
int get hashCode => Object.hash(runtimeType,deviceId,fcmToken,platform);

@override
String toString() {
  return 'DeviceRegistration(deviceId: $deviceId, fcmToken: $fcmToken, platform: $platform)';
}


}

/// @nodoc
abstract mixin class $DeviceRegistrationCopyWith<$Res>  {
  factory $DeviceRegistrationCopyWith(DeviceRegistration value, $Res Function(DeviceRegistration) _then) = _$DeviceRegistrationCopyWithImpl;
@useResult
$Res call({
 String deviceId, String fcmToken, String platform
});




}
/// @nodoc
class _$DeviceRegistrationCopyWithImpl<$Res>
    implements $DeviceRegistrationCopyWith<$Res> {
  _$DeviceRegistrationCopyWithImpl(this._self, this._then);

  final DeviceRegistration _self;
  final $Res Function(DeviceRegistration) _then;

/// Create a copy of DeviceRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? fcmToken = null,Object? platform = null,}) {
  return _then(DeviceRegistration(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceRegistration].
extension DeviceRegistrationPatterns on DeviceRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRegistration value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String fcmToken,  String platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRegistration() when $default != null:
return $default(_that.deviceId,_that.fcmToken,_that.platform);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String fcmToken,  String platform)  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistration():
return $default(_that.deviceId,_that.fcmToken,_that.platform);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String fcmToken,  String platform)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistration() when $default != null:
return $default(_that.deviceId,_that.fcmToken,_that.platform);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceRegistration implements DeviceRegistration {
  const _DeviceRegistration({required this.deviceId, required this.fcmToken, required this.platform});
  

/// 앱 최초 실행 때 만들어 기기에 영구 저장하는 식별자.
@override final  String deviceId;
@override final  String fcmToken;
/// 'android' | 'ios'.
@override final  String platform;

/// Create a copy of DeviceRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRegistrationCopyWith<_DeviceRegistration> get copyWith => __$DeviceRegistrationCopyWithImpl<_DeviceRegistration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRegistration&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.platform, platform) || other.platform == platform));
}


@override
int get hashCode => Object.hash(runtimeType,deviceId,fcmToken,platform);

@override
String toString() {
  return 'DeviceRegistration(deviceId: $deviceId, fcmToken: $fcmToken, platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$DeviceRegistrationCopyWith<$Res> implements $DeviceRegistrationCopyWith<$Res> {
  factory _$DeviceRegistrationCopyWith(_DeviceRegistration value, $Res Function(_DeviceRegistration) _then) = __$DeviceRegistrationCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String fcmToken, String platform
});




}
/// @nodoc
class __$DeviceRegistrationCopyWithImpl<$Res>
    implements _$DeviceRegistrationCopyWith<$Res> {
  __$DeviceRegistrationCopyWithImpl(this._self, this._then);

  final _DeviceRegistration _self;
  final $Res Function(_DeviceRegistration) _then;

/// Create a copy of DeviceRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? fcmToken = null,Object? platform = null,}) {
  return _then(_DeviceRegistration(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
