// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ota_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OtaState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(OtaStatus status, String statusText) minimal,
    required TResult Function(OtaStatus status, String statusText, bool isParked) fullScreen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(OtaStatus status, String statusText)? minimal,
    TResult? Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(OtaStatus status, String statusText)? minimal,
    TResult Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OtaInactive value) inactive,
    required TResult Function(OtaMinimal value) minimal,
    required TResult Function(OtaFullScreen value) fullScreen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OtaInactive value)? inactive,
    TResult? Function(OtaMinimal value)? minimal,
    TResult? Function(OtaFullScreen value)? fullScreen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OtaInactive value)? inactive,
    TResult Function(OtaMinimal value)? minimal,
    TResult Function(OtaFullScreen value)? fullScreen,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtaStateCopyWith<$Res> {
  factory $OtaStateCopyWith(OtaState value, $Res Function(OtaState) then) = _$OtaStateCopyWithImpl<$Res, OtaState>;
}

/// @nodoc
class _$OtaStateCopyWithImpl<$Res, $Val extends OtaState> implements $OtaStateCopyWith<$Res> {
  _$OtaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$OtaInactiveImplCopyWith<$Res> {
  factory _$$OtaInactiveImplCopyWith(_$OtaInactiveImpl value, $Res Function(_$OtaInactiveImpl) then) =
      __$$OtaInactiveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OtaInactiveImplCopyWithImpl<$Res> extends _$OtaStateCopyWithImpl<$Res, _$OtaInactiveImpl>
    implements _$$OtaInactiveImplCopyWith<$Res> {
  __$$OtaInactiveImplCopyWithImpl(_$OtaInactiveImpl _value, $Res Function(_$OtaInactiveImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OtaInactiveImpl implements OtaInactive {
  const _$OtaInactiveImpl();

  @override
  String toString() {
    return 'OtaState.inactive()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$OtaInactiveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(OtaStatus status, String statusText) minimal,
    required TResult Function(OtaStatus status, String statusText, bool isParked) fullScreen,
  }) {
    return inactive();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(OtaStatus status, String statusText)? minimal,
    TResult? Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
  }) {
    return inactive?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(OtaStatus status, String statusText)? minimal,
    TResult Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
    required TResult orElse(),
  }) {
    if (inactive != null) {
      return inactive();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OtaInactive value) inactive,
    required TResult Function(OtaMinimal value) minimal,
    required TResult Function(OtaFullScreen value) fullScreen,
  }) {
    return inactive(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OtaInactive value)? inactive,
    TResult? Function(OtaMinimal value)? minimal,
    TResult? Function(OtaFullScreen value)? fullScreen,
  }) {
    return inactive?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OtaInactive value)? inactive,
    TResult Function(OtaMinimal value)? minimal,
    TResult Function(OtaFullScreen value)? fullScreen,
    required TResult orElse(),
  }) {
    if (inactive != null) {
      return inactive(this);
    }
    return orElse();
  }
}

abstract class OtaInactive implements OtaState {
  const factory OtaInactive() = _$OtaInactiveImpl;
}

/// @nodoc
abstract class _$$OtaMinimalImplCopyWith<$Res> {
  factory _$$OtaMinimalImplCopyWith(_$OtaMinimalImpl value, $Res Function(_$OtaMinimalImpl) then) =
      __$$OtaMinimalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({OtaStatus status, String statusText});
}

/// @nodoc
class __$$OtaMinimalImplCopyWithImpl<$Res> extends _$OtaStateCopyWithImpl<$Res, _$OtaMinimalImpl>
    implements _$$OtaMinimalImplCopyWith<$Res> {
  __$$OtaMinimalImplCopyWithImpl(_$OtaMinimalImpl _value, $Res Function(_$OtaMinimalImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? statusText = null,
  }) {
    return _then(_$OtaMinimalImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OtaStatus,
      statusText: null == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OtaMinimalImpl implements OtaMinimal {
  const _$OtaMinimalImpl({required this.status, required this.statusText});

  @override
  final OtaStatus status;
  @override
  final String statusText;

  @override
  String toString() {
    return 'OtaState.minimal(status: $status, statusText: $statusText)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtaMinimalImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusText, statusText) || other.statusText == statusText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, statusText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtaMinimalImplCopyWith<_$OtaMinimalImpl> get copyWith =>
      __$$OtaMinimalImplCopyWithImpl<_$OtaMinimalImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(OtaStatus status, String statusText) minimal,
    required TResult Function(OtaStatus status, String statusText, bool isParked) fullScreen,
  }) {
    return minimal(status, statusText);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(OtaStatus status, String statusText)? minimal,
    TResult? Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
  }) {
    return minimal?.call(status, statusText);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(OtaStatus status, String statusText)? minimal,
    TResult Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
    required TResult orElse(),
  }) {
    if (minimal != null) {
      return minimal(status, statusText);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OtaInactive value) inactive,
    required TResult Function(OtaMinimal value) minimal,
    required TResult Function(OtaFullScreen value) fullScreen,
  }) {
    return minimal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OtaInactive value)? inactive,
    TResult? Function(OtaMinimal value)? minimal,
    TResult? Function(OtaFullScreen value)? fullScreen,
  }) {
    return minimal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OtaInactive value)? inactive,
    TResult Function(OtaMinimal value)? minimal,
    TResult Function(OtaFullScreen value)? fullScreen,
    required TResult orElse(),
  }) {
    if (minimal != null) {
      return minimal(this);
    }
    return orElse();
  }
}

abstract class OtaMinimal implements OtaState {
  const factory OtaMinimal({required final OtaStatus status, required final String statusText}) = _$OtaMinimalImpl;

  OtaStatus get status;
  String get statusText;
  @JsonKey(ignore: true)
  _$$OtaMinimalImplCopyWith<_$OtaMinimalImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OtaFullScreenImplCopyWith<$Res> {
  factory _$$OtaFullScreenImplCopyWith(_$OtaFullScreenImpl value, $Res Function(_$OtaFullScreenImpl) then) =
      __$$OtaFullScreenImplCopyWithImpl<$Res>;
  @useResult
  $Res call({OtaStatus status, String statusText, bool isParked});
}

/// @nodoc
class __$$OtaFullScreenImplCopyWithImpl<$Res> extends _$OtaStateCopyWithImpl<$Res, _$OtaFullScreenImpl>
    implements _$$OtaFullScreenImplCopyWith<$Res> {
  __$$OtaFullScreenImplCopyWithImpl(_$OtaFullScreenImpl _value, $Res Function(_$OtaFullScreenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? statusText = null,
    Object? isParked = null,
  }) {
    return _then(_$OtaFullScreenImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OtaStatus,
      statusText: null == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
      isParked: null == isParked
          ? _value.isParked
          : isParked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$OtaFullScreenImpl implements OtaFullScreen {
  const _$OtaFullScreenImpl({required this.status, required this.statusText, required this.isParked});

  @override
  final OtaStatus status;
  @override
  final String statusText;
  @override
  final bool isParked;

  @override
  String toString() {
    return 'OtaState.fullScreen(status: $status, statusText: $statusText, isParked: $isParked)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtaFullScreenImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusText, statusText) || other.statusText == statusText) &&
            (identical(other.isParked, isParked) || other.isParked == isParked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, statusText, isParked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtaFullScreenImplCopyWith<_$OtaFullScreenImpl> get copyWith =>
      __$$OtaFullScreenImplCopyWithImpl<_$OtaFullScreenImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(OtaStatus status, String statusText) minimal,
    required TResult Function(OtaStatus status, String statusText, bool isParked) fullScreen,
  }) {
    return fullScreen(status, statusText, isParked);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(OtaStatus status, String statusText)? minimal,
    TResult? Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
  }) {
    return fullScreen?.call(status, statusText, isParked);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(OtaStatus status, String statusText)? minimal,
    TResult Function(OtaStatus status, String statusText, bool isParked)? fullScreen,
    required TResult orElse(),
  }) {
    if (fullScreen != null) {
      return fullScreen(status, statusText, isParked);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OtaInactive value) inactive,
    required TResult Function(OtaMinimal value) minimal,
    required TResult Function(OtaFullScreen value) fullScreen,
  }) {
    return fullScreen(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OtaInactive value)? inactive,
    TResult? Function(OtaMinimal value)? minimal,
    TResult? Function(OtaFullScreen value)? fullScreen,
  }) {
    return fullScreen?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OtaInactive value)? inactive,
    TResult Function(OtaMinimal value)? minimal,
    TResult Function(OtaFullScreen value)? fullScreen,
    required TResult orElse(),
  }) {
    if (fullScreen != null) {
      return fullScreen(this);
    }
    return orElse();
  }
}

abstract class OtaFullScreen implements OtaState {
  const factory OtaFullScreen(
      {required final OtaStatus status,
      required final String statusText,
      required final bool isParked}) = _$OtaFullScreenImpl;

  OtaStatus get status;
  String get statusText;
  bool get isParked;
  @JsonKey(ignore: true)
  _$$OtaFullScreenImplCopyWith<_$OtaFullScreenImpl> get copyWith => throw _privateConstructorUsedError;
}
