// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PickupInfo {

 DateTime get pickupDate; int get boxes;
/// Create a copy of PickupInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickupInfoCopyWith<PickupInfo> get copyWith => _$PickupInfoCopyWithImpl<PickupInfo>(this as PickupInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickupInfo&&(identical(other.pickupDate, pickupDate) || other.pickupDate == pickupDate)&&(identical(other.boxes, boxes) || other.boxes == boxes));
}


@override
int get hashCode => Object.hash(runtimeType,pickupDate,boxes);

@override
String toString() {
  return 'PickupInfo(pickupDate: $pickupDate, boxes: $boxes)';
}


}

/// @nodoc
abstract mixin class $PickupInfoCopyWith<$Res>  {
  factory $PickupInfoCopyWith(PickupInfo value, $Res Function(PickupInfo) _then) = _$PickupInfoCopyWithImpl;
@useResult
$Res call({
 DateTime pickupDate, int boxes
});




}
/// @nodoc
class _$PickupInfoCopyWithImpl<$Res>
    implements $PickupInfoCopyWith<$Res> {
  _$PickupInfoCopyWithImpl(this._self, this._then);

  final PickupInfo _self;
  final $Res Function(PickupInfo) _then;

/// Create a copy of PickupInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pickupDate = null,Object? boxes = null,}) {
  return _then(PickupInfo(
pickupDate: null == pickupDate ? _self.pickupDate : pickupDate // ignore: cast_nullable_to_non_nullable
as DateTime,boxes: null == boxes ? _self.boxes : boxes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PickupInfo].
extension PickupInfoPatterns on PickupInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickupInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickupInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickupInfo value)  $default,){
final _that = this;
switch (_that) {
case _PickupInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickupInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PickupInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime pickupDate,  int boxes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickupInfo() when $default != null:
return $default(_that.pickupDate,_that.boxes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime pickupDate,  int boxes)  $default,) {final _that = this;
switch (_that) {
case _PickupInfo():
return $default(_that.pickupDate,_that.boxes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime pickupDate,  int boxes)?  $default,) {final _that = this;
switch (_that) {
case _PickupInfo() when $default != null:
return $default(_that.pickupDate,_that.boxes);case _:
  return null;

}
}

}

/// @nodoc


class _PickupInfo extends PickupInfo {
  const _PickupInfo({required this.pickupDate, required this.boxes}): super._();
  

@override final  DateTime pickupDate;
@override final  int boxes;

/// Create a copy of PickupInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickupInfoCopyWith<_PickupInfo> get copyWith => __$PickupInfoCopyWithImpl<_PickupInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickupInfo&&(identical(other.pickupDate, pickupDate) || other.pickupDate == pickupDate)&&(identical(other.boxes, boxes) || other.boxes == boxes));
}


@override
int get hashCode => Object.hash(runtimeType,pickupDate,boxes);

@override
String toString() {
  return 'PickupInfo(pickupDate: $pickupDate, boxes: $boxes)';
}


}

/// @nodoc
abstract mixin class _$PickupInfoCopyWith<$Res> implements $PickupInfoCopyWith<$Res> {
  factory _$PickupInfoCopyWith(_PickupInfo value, $Res Function(_PickupInfo) _then) = __$PickupInfoCopyWithImpl;
@override @useResult
$Res call({
 DateTime pickupDate, int boxes
});




}
/// @nodoc
class __$PickupInfoCopyWithImpl<$Res>
    implements _$PickupInfoCopyWith<$Res> {
  __$PickupInfoCopyWithImpl(this._self, this._then);

  final _PickupInfo _self;
  final $Res Function(_PickupInfo) _then;

/// Create a copy of PickupInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pickupDate = null,Object? boxes = null,}) {
  return _then(_PickupInfo(
pickupDate: null == pickupDate ? _self.pickupDate : pickupDate // ignore: cast_nullable_to_non_nullable
as DateTime,boxes: null == boxes ? _self.boxes : boxes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
