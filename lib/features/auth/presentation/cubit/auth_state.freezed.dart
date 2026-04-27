// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AuthInitial value)?  initial,TResult Function( _AuthLoading value)?  loading,TResult Function( _AuthAuthenticated value)?  authenticated,TResult Function( _AuthUnauthenticated value)?  unauthenticated,TResult Function( _AuthError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial(_that);case _AuthLoading() when loading != null:
return loading(_that);case _AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _AuthError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AuthInitial value)  initial,required TResult Function( _AuthLoading value)  loading,required TResult Function( _AuthAuthenticated value)  authenticated,required TResult Function( _AuthUnauthenticated value)  unauthenticated,required TResult Function( _AuthError value)  error,}){
final _that = this;
switch (_that) {
case _AuthInitial():
return initial(_that);case _AuthLoading():
return loading(_that);case _AuthAuthenticated():
return authenticated(_that);case _AuthUnauthenticated():
return unauthenticated(_that);case _AuthError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AuthInitial value)?  initial,TResult? Function( _AuthLoading value)?  loading,TResult? Function( _AuthAuthenticated value)?  authenticated,TResult? Function( _AuthUnauthenticated value)?  unauthenticated,TResult? Function( _AuthError value)?  error,}){
final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial(_that);case _AuthLoading() when loading != null:
return loading(_that);case _AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _AuthError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( LoginResponseEntity user)?  authenticated,TResult Function()?  unauthenticated,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial();case _AuthLoading() when loading != null:
return loading();case _AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case _AuthError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( LoginResponseEntity user)  authenticated,required TResult Function()  unauthenticated,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _AuthInitial():
return initial();case _AuthLoading():
return loading();case _AuthAuthenticated():
return authenticated(_that.user);case _AuthUnauthenticated():
return unauthenticated();case _AuthError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( LoginResponseEntity user)?  authenticated,TResult? Function()?  unauthenticated,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial();case _AuthLoading() when loading != null:
return loading();case _AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case _AuthError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AuthInitial implements AuthState {
  const _AuthInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _AuthLoading implements AuthState {
  const _AuthLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class _AuthAuthenticated implements AuthState {
  const _AuthAuthenticated(this.user);
  

 final  LoginResponseEntity user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthAuthenticatedCopyWith<_AuthAuthenticated> get copyWith => __$AuthAuthenticatedCopyWithImpl<_AuthAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthAuthenticatedCopyWith(_AuthAuthenticated value, $Res Function(_AuthAuthenticated) _then) = __$AuthAuthenticatedCopyWithImpl;
@useResult
$Res call({
 LoginResponseEntity user
});




}
/// @nodoc
class __$AuthAuthenticatedCopyWithImpl<$Res>
    implements _$AuthAuthenticatedCopyWith<$Res> {
  __$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final _AuthAuthenticated _self;
  final $Res Function(_AuthAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_AuthAuthenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as LoginResponseEntity,
  ));
}


}

/// @nodoc


class _AuthUnauthenticated implements AuthState {
  const _AuthUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class _AuthError implements AuthState {
  const _AuthError(this.failure);
  

 final  Failure failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthErrorCopyWith<_AuthError> get copyWith => __$AuthErrorCopyWithImpl<_AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AuthState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthErrorCopyWith(_AuthError value, $Res Function(_AuthError) _then) = __$AuthErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class __$AuthErrorCopyWithImpl<$Res>
    implements _$AuthErrorCopyWith<$Res> {
  __$AuthErrorCopyWithImpl(this._self, this._then);

  final _AuthError _self;
  final $Res Function(_AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_AuthError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
