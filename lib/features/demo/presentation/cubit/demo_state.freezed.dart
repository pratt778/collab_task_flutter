// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DemoState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemoState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DemoState()';
}


}

/// @nodoc
class $DemoStateCopyWith<$Res>  {
$DemoStateCopyWith(DemoState _, $Res Function(DemoState) __);
}


/// Adds pattern-matching-related methods to [DemoState].
extension DemoStatePatterns on DemoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _DemoInitial value)?  initial,TResult Function( _DemoLoading value)?  loading,TResult Function( _DemoLoaded value)?  loaded,TResult Function( _DemoError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemoInitial() when initial != null:
return initial(_that);case _DemoLoading() when loading != null:
return loading(_that);case _DemoLoaded() when loaded != null:
return loaded(_that);case _DemoError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _DemoInitial value)  initial,required TResult Function( _DemoLoading value)  loading,required TResult Function( _DemoLoaded value)  loaded,required TResult Function( _DemoError value)  error,}){
final _that = this;
switch (_that) {
case _DemoInitial():
return initial(_that);case _DemoLoading():
return loading(_that);case _DemoLoaded():
return loaded(_that);case _DemoError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _DemoInitial value)?  initial,TResult? Function( _DemoLoading value)?  loading,TResult? Function( _DemoLoaded value)?  loaded,TResult? Function( _DemoError value)?  error,}){
final _that = this;
switch (_that) {
case _DemoInitial() when initial != null:
return initial(_that);case _DemoLoading() when loading != null:
return loading(_that);case _DemoLoaded() when loaded != null:
return loaded(_that);case _DemoError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DemoEntity> demos)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemoInitial() when initial != null:
return initial();case _DemoLoading() when loading != null:
return loading();case _DemoLoaded() when loaded != null:
return loaded(_that.demos);case _DemoError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DemoEntity> demos)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _DemoInitial():
return initial();case _DemoLoading():
return loading();case _DemoLoaded():
return loaded(_that.demos);case _DemoError():
return error(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DemoEntity> demos)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _DemoInitial() when initial != null:
return initial();case _DemoLoading() when loading != null:
return loading();case _DemoLoaded() when loaded != null:
return loaded(_that.demos);case _DemoError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DemoInitial implements DemoState {
  const _DemoInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DemoState.initial()';
}


}




/// @nodoc


class _DemoLoading implements DemoState {
  const _DemoLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DemoState.loading()';
}


}




/// @nodoc


class _DemoLoaded implements DemoState {
  const _DemoLoaded(final  List<DemoEntity> demos): _demos = demos;
  

 final  List<DemoEntity> _demos;
 List<DemoEntity> get demos {
  if (_demos is EqualUnmodifiableListView) return _demos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_demos);
}


/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemoLoadedCopyWith<_DemoLoaded> get copyWith => __$DemoLoadedCopyWithImpl<_DemoLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoLoaded&&const DeepCollectionEquality().equals(other._demos, _demos));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_demos));

@override
String toString() {
  return 'DemoState.loaded(demos: $demos)';
}


}

/// @nodoc
abstract mixin class _$DemoLoadedCopyWith<$Res> implements $DemoStateCopyWith<$Res> {
  factory _$DemoLoadedCopyWith(_DemoLoaded value, $Res Function(_DemoLoaded) _then) = __$DemoLoadedCopyWithImpl;
@useResult
$Res call({
 List<DemoEntity> demos
});




}
/// @nodoc
class __$DemoLoadedCopyWithImpl<$Res>
    implements _$DemoLoadedCopyWith<$Res> {
  __$DemoLoadedCopyWithImpl(this._self, this._then);

  final _DemoLoaded _self;
  final $Res Function(_DemoLoaded) _then;

/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? demos = null,}) {
  return _then(_DemoLoaded(
null == demos ? _self._demos : demos // ignore: cast_nullable_to_non_nullable
as List<DemoEntity>,
  ));
}


}

/// @nodoc


class _DemoError implements DemoState {
  const _DemoError(this.failure);
  

 final  Failure failure;

/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemoErrorCopyWith<_DemoError> get copyWith => __$DemoErrorCopyWithImpl<_DemoError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DemoState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DemoErrorCopyWith<$Res> implements $DemoStateCopyWith<$Res> {
  factory _$DemoErrorCopyWith(_DemoError value, $Res Function(_DemoError) _then) = __$DemoErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class __$DemoErrorCopyWithImpl<$Res>
    implements _$DemoErrorCopyWith<$Res> {
  __$DemoErrorCopyWithImpl(this._self, this._then);

  final _DemoError _self;
  final $Res Function(_DemoError) _then;

/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_DemoError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
