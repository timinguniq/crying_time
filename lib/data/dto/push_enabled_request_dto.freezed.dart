// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_enabled_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushEnabledRequestDto {

 bool get enabled;
/// Create a copy of PushEnabledRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushEnabledRequestDtoCopyWith<PushEnabledRequestDto> get copyWith => _$PushEnabledRequestDtoCopyWithImpl<PushEnabledRequestDto>(this as PushEnabledRequestDto, _$identity);

  /// Serializes this PushEnabledRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushEnabledRequestDto&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'PushEnabledRequestDto(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $PushEnabledRequestDtoCopyWith<$Res>  {
  factory $PushEnabledRequestDtoCopyWith(PushEnabledRequestDto value, $Res Function(PushEnabledRequestDto) _then) = _$PushEnabledRequestDtoCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$PushEnabledRequestDtoCopyWithImpl<$Res>
    implements $PushEnabledRequestDtoCopyWith<$Res> {
  _$PushEnabledRequestDtoCopyWithImpl(this._self, this._then);

  final PushEnabledRequestDto _self;
  final $Res Function(PushEnabledRequestDto) _then;

/// Create a copy of PushEnabledRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,}) {
  return _then(PushEnabledRequestDto(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PushEnabledRequestDto].
extension PushEnabledRequestDtoPatterns on PushEnabledRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushEnabledRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushEnabledRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushEnabledRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _PushEnabledRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushEnabledRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _PushEnabledRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushEnabledRequestDto() when $default != null:
return $default(_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled)  $default,) {final _that = this;
switch (_that) {
case _PushEnabledRequestDto():
return $default(_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _PushEnabledRequestDto() when $default != null:
return $default(_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushEnabledRequestDto implements PushEnabledRequestDto {
  const _PushEnabledRequestDto({required this.enabled});
  factory _PushEnabledRequestDto.fromJson(Map<String, dynamic> json) => _$PushEnabledRequestDtoFromJson(json);

@override final  bool enabled;

/// Create a copy of PushEnabledRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushEnabledRequestDtoCopyWith<_PushEnabledRequestDto> get copyWith => __$PushEnabledRequestDtoCopyWithImpl<_PushEnabledRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushEnabledRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushEnabledRequestDto&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'PushEnabledRequestDto(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$PushEnabledRequestDtoCopyWith<$Res> implements $PushEnabledRequestDtoCopyWith<$Res> {
  factory _$PushEnabledRequestDtoCopyWith(_PushEnabledRequestDto value, $Res Function(_PushEnabledRequestDto) _then) = __$PushEnabledRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$PushEnabledRequestDtoCopyWithImpl<$Res>
    implements _$PushEnabledRequestDtoCopyWith<$Res> {
  __$PushEnabledRequestDtoCopyWithImpl(this._self, this._then);

  final _PushEnabledRequestDto _self;
  final $Res Function(_PushEnabledRequestDto) _then;

/// Create a copy of PushEnabledRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_PushEnabledRequestDto(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
