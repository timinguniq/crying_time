// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PushSchedule {

 bool get enabled; bool get notifyD7; bool get notifyD3; bool get notifyDDay; bool get customEnabled; int get customDays;
/// Create a copy of PushSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushScheduleCopyWith<PushSchedule> get copyWith => _$PushScheduleCopyWithImpl<PushSchedule>(this as PushSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushSchedule&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.notifyD7, notifyD7) || other.notifyD7 == notifyD7)&&(identical(other.notifyD3, notifyD3) || other.notifyD3 == notifyD3)&&(identical(other.notifyDDay, notifyDDay) || other.notifyDDay == notifyDDay)&&(identical(other.customEnabled, customEnabled) || other.customEnabled == customEnabled)&&(identical(other.customDays, customDays) || other.customDays == customDays));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,notifyD7,notifyD3,notifyDDay,customEnabled,customDays);

@override
String toString() {
  return 'PushSchedule(enabled: $enabled, notifyD7: $notifyD7, notifyD3: $notifyD3, notifyDDay: $notifyDDay, customEnabled: $customEnabled, customDays: $customDays)';
}


}

/// @nodoc
abstract mixin class $PushScheduleCopyWith<$Res>  {
  factory $PushScheduleCopyWith(PushSchedule value, $Res Function(PushSchedule) _then) = _$PushScheduleCopyWithImpl;
@useResult
$Res call({
 bool enabled, bool notifyD7, bool notifyD3, bool notifyDDay, bool customEnabled, int customDays
});




}
/// @nodoc
class _$PushScheduleCopyWithImpl<$Res>
    implements $PushScheduleCopyWith<$Res> {
  _$PushScheduleCopyWithImpl(this._self, this._then);

  final PushSchedule _self;
  final $Res Function(PushSchedule) _then;

/// Create a copy of PushSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? notifyD7 = null,Object? notifyD3 = null,Object? notifyDDay = null,Object? customEnabled = null,Object? customDays = null,}) {
  return _then(PushSchedule(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,notifyD7: null == notifyD7 ? _self.notifyD7 : notifyD7 // ignore: cast_nullable_to_non_nullable
as bool,notifyD3: null == notifyD3 ? _self.notifyD3 : notifyD3 // ignore: cast_nullable_to_non_nullable
as bool,notifyDDay: null == notifyDDay ? _self.notifyDDay : notifyDDay // ignore: cast_nullable_to_non_nullable
as bool,customEnabled: null == customEnabled ? _self.customEnabled : customEnabled // ignore: cast_nullable_to_non_nullable
as bool,customDays: null == customDays ? _self.customDays : customDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PushSchedule].
extension PushSchedulePatterns on PushSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushSchedule value)  $default,){
final _that = this;
switch (_that) {
case _PushSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _PushSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  bool notifyD7,  bool notifyD3,  bool notifyDDay,  bool customEnabled,  int customDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushSchedule() when $default != null:
return $default(_that.enabled,_that.notifyD7,_that.notifyD3,_that.notifyDDay,_that.customEnabled,_that.customDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  bool notifyD7,  bool notifyD3,  bool notifyDDay,  bool customEnabled,  int customDays)  $default,) {final _that = this;
switch (_that) {
case _PushSchedule():
return $default(_that.enabled,_that.notifyD7,_that.notifyD3,_that.notifyDDay,_that.customEnabled,_that.customDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  bool notifyD7,  bool notifyD3,  bool notifyDDay,  bool customEnabled,  int customDays)?  $default,) {final _that = this;
switch (_that) {
case _PushSchedule() when $default != null:
return $default(_that.enabled,_that.notifyD7,_that.notifyD3,_that.notifyDDay,_that.customEnabled,_that.customDays);case _:
  return null;

}
}

}

/// @nodoc


class _PushSchedule extends PushSchedule {
  const _PushSchedule({required this.enabled, required this.notifyD7, required this.notifyD3, required this.notifyDDay, required this.customEnabled, required this.customDays}): super._();
  

@override final  bool enabled;
@override final  bool notifyD7;
@override final  bool notifyD3;
@override final  bool notifyDDay;
@override final  bool customEnabled;
@override final  int customDays;

/// Create a copy of PushSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushScheduleCopyWith<_PushSchedule> get copyWith => __$PushScheduleCopyWithImpl<_PushSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushSchedule&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.notifyD7, notifyD7) || other.notifyD7 == notifyD7)&&(identical(other.notifyD3, notifyD3) || other.notifyD3 == notifyD3)&&(identical(other.notifyDDay, notifyDDay) || other.notifyDDay == notifyDDay)&&(identical(other.customEnabled, customEnabled) || other.customEnabled == customEnabled)&&(identical(other.customDays, customDays) || other.customDays == customDays));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,notifyD7,notifyD3,notifyDDay,customEnabled,customDays);

@override
String toString() {
  return 'PushSchedule(enabled: $enabled, notifyD7: $notifyD7, notifyD3: $notifyD3, notifyDDay: $notifyDDay, customEnabled: $customEnabled, customDays: $customDays)';
}


}

/// @nodoc
abstract mixin class _$PushScheduleCopyWith<$Res> implements $PushScheduleCopyWith<$Res> {
  factory _$PushScheduleCopyWith(_PushSchedule value, $Res Function(_PushSchedule) _then) = __$PushScheduleCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, bool notifyD7, bool notifyD3, bool notifyDDay, bool customEnabled, int customDays
});




}
/// @nodoc
class __$PushScheduleCopyWithImpl<$Res>
    implements _$PushScheduleCopyWith<$Res> {
  __$PushScheduleCopyWithImpl(this._self, this._then);

  final _PushSchedule _self;
  final $Res Function(_PushSchedule) _then;

/// Create a copy of PushSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? notifyD7 = null,Object? notifyD3 = null,Object? notifyDDay = null,Object? customEnabled = null,Object? customDays = null,}) {
  return _then(_PushSchedule(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,notifyD7: null == notifyD7 ? _self.notifyD7 : notifyD7 // ignore: cast_nullable_to_non_nullable
as bool,notifyD3: null == notifyD3 ? _self.notifyD3 : notifyD3 // ignore: cast_nullable_to_non_nullable
as bool,notifyDDay: null == notifyDDay ? _self.notifyDDay : notifyDDay // ignore: cast_nullable_to_non_nullable
as bool,customEnabled: null == customEnabled ? _self.customEnabled : customEnabled // ignore: cast_nullable_to_non_nullable
as bool,customDays: null == customDays ? _self.customDays : customDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
