// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mbtiles_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Request {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Request);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return '_Request()';
  }
}

/// @nodoc
class _$RequestCopyWith<$Res> {
  _$RequestCopyWith(_Request _, $Res Function(_Request) __);
}

/// @nodoc

class _GetTileRequest implements _Request {
  const _GetTileRequest(this.requestId, this.tile);

  final String requestId;
  final TileIdentity tile;

  /// Create a copy of _Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GetTileRequestCopyWith<_GetTileRequest> get copyWith =>
      __$GetTileRequestCopyWithImpl<_GetTileRequest>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GetTileRequest &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.tile, tile) || other.tile == tile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId, tile);

  @override
  String toString() {
    return '_Request.getTile(requestId: $requestId, tile: $tile)';
  }
}

/// @nodoc
abstract mixin class _$GetTileRequestCopyWith<$Res>
    implements _$RequestCopyWith<$Res> {
  factory _$GetTileRequestCopyWith(
          _GetTileRequest value, $Res Function(_GetTileRequest) _then) =
      __$GetTileRequestCopyWithImpl;
  @useResult
  $Res call({String requestId, TileIdentity tile});
}

/// @nodoc
class __$GetTileRequestCopyWithImpl<$Res>
    implements _$GetTileRequestCopyWith<$Res> {
  __$GetTileRequestCopyWithImpl(this._self, this._then);

  final _GetTileRequest _self;
  final $Res Function(_GetTileRequest) _then;

  /// Create a copy of _Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? tile = null,
  }) {
    return _then(_GetTileRequest(
      null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      null == tile
          ? _self.tile
          : tile // ignore: cast_nullable_to_non_nullable
              as TileIdentity,
    ));
  }
}

/// @nodoc

class _DisposeRequest implements _Request {
  const _DisposeRequest();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DisposeRequest);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return '_Request.dispose()';
  }
}

/// @nodoc

class _InitRequest implements _Request {
  const _InitRequest(this.tilesRepository);

  final TilesRepository tilesRepository;

  /// Create a copy of _Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InitRequestCopyWith<_InitRequest> get copyWith =>
      __$InitRequestCopyWithImpl<_InitRequest>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InitRequest &&
            (identical(other.tilesRepository, tilesRepository) ||
                other.tilesRepository == tilesRepository));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tilesRepository);

  @override
  String toString() {
    return '_Request.init(tilesRepository: $tilesRepository)';
  }
}

/// @nodoc
abstract mixin class _$InitRequestCopyWith<$Res>
    implements _$RequestCopyWith<$Res> {
  factory _$InitRequestCopyWith(
          _InitRequest value, $Res Function(_InitRequest) _then) =
      __$InitRequestCopyWithImpl;
  @useResult
  $Res call({TilesRepository tilesRepository});
}

/// @nodoc
class __$InitRequestCopyWithImpl<$Res> implements _$InitRequestCopyWith<$Res> {
  __$InitRequestCopyWithImpl(this._self, this._then);

  final _InitRequest _self;
  final $Res Function(_InitRequest) _then;

  /// Create a copy of _Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tilesRepository = null,
  }) {
    return _then(_InitRequest(
      null == tilesRepository
          ? _self.tilesRepository
          : tilesRepository // ignore: cast_nullable_to_non_nullable
              as TilesRepository,
    ));
  }
}

/// @nodoc
mixin _$Response {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Response);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return '_Response()';
  }
}

/// @nodoc
class _$ResponseCopyWith<$Res> {
  _$ResponseCopyWith(_Response _, $Res Function(_Response) __);
}

/// @nodoc

class _TileResponse implements _Response {
  const _TileResponse(this.requestId, this.tile);

  final String requestId;
  final Uint8List tile;

  /// Create a copy of _Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TileResponseCopyWith<_TileResponse> get copyWith =>
      __$TileResponseCopyWithImpl<_TileResponse>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TileResponse &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            const DeepCollectionEquality().equals(other.tile, tile));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, requestId, const DeepCollectionEquality().hash(tile));

  @override
  String toString() {
    return '_Response.tile(requestId: $requestId, tile: $tile)';
  }
}

/// @nodoc
abstract mixin class _$TileResponseCopyWith<$Res>
    implements _$ResponseCopyWith<$Res> {
  factory _$TileResponseCopyWith(
          _TileResponse value, $Res Function(_TileResponse) _then) =
      __$TileResponseCopyWithImpl;
  @useResult
  $Res call({String requestId, Uint8List tile});
}

/// @nodoc
class __$TileResponseCopyWithImpl<$Res>
    implements _$TileResponseCopyWith<$Res> {
  __$TileResponseCopyWithImpl(this._self, this._then);

  final _TileResponse _self;
  final $Res Function(_TileResponse) _then;

  /// Create a copy of _Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? tile = null,
  }) {
    return _then(_TileResponse(
      null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      null == tile
          ? _self.tile
          : tile // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _ErrorResponse implements _Response {
  const _ErrorResponse(this.requestId, this.message);

  final String requestId;
  final String message;

  /// Create a copy of _Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorResponseCopyWith<_ErrorResponse> get copyWith =>
      __$ErrorResponseCopyWithImpl<_ErrorResponse>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ErrorResponse &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId, message);

  @override
  String toString() {
    return '_Response.error(requestId: $requestId, message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorResponseCopyWith<$Res>
    implements _$ResponseCopyWith<$Res> {
  factory _$ErrorResponseCopyWith(
          _ErrorResponse value, $Res Function(_ErrorResponse) _then) =
      __$ErrorResponseCopyWithImpl;
  @useResult
  $Res call({String requestId, String message});
}

/// @nodoc
class __$ErrorResponseCopyWithImpl<$Res>
    implements _$ErrorResponseCopyWith<$Res> {
  __$ErrorResponseCopyWithImpl(this._self, this._then);

  final _ErrorResponse _self;
  final $Res Function(_ErrorResponse) _then;

  /// Create a copy of _Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? message = null,
  }) {
    return _then(_ErrorResponse(
      null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _InitResponse implements _Response {
  const _InitResponse(this.result);

  final InitResult result;

  /// Create a copy of _Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InitResponseCopyWith<_InitResponse> get copyWith =>
      __$InitResponseCopyWithImpl<_InitResponse>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InitResponse &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  @override
  String toString() {
    return '_Response.init(result: $result)';
  }
}

/// @nodoc
abstract mixin class _$InitResponseCopyWith<$Res>
    implements _$ResponseCopyWith<$Res> {
  factory _$InitResponseCopyWith(
          _InitResponse value, $Res Function(_InitResponse) _then) =
      __$InitResponseCopyWithImpl;
  @useResult
  $Res call({InitResult result});

  $InitResultCopyWith<$Res> get result;
}

/// @nodoc
class __$InitResponseCopyWithImpl<$Res>
    implements _$InitResponseCopyWith<$Res> {
  __$InitResponseCopyWithImpl(this._self, this._then);

  final _InitResponse _self;
  final $Res Function(_InitResponse) _then;

  /// Create a copy of _Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? result = null,
  }) {
    return _then(_InitResponse(
      null == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as InitResult,
    ));
  }

  /// Create a copy of _Response
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InitResultCopyWith<$Res> get result {
    return $InitResultCopyWith<$Res>(_self.result, (value) {
      return _then(_self.copyWith(result: value));
    });
  }
}

/// @nodoc
mixin _$InitResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InitResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'InitResult()';
  }
}

/// @nodoc
class $InitResultCopyWith<$Res> {
  $InitResultCopyWith(InitResult _, $Res Function(InitResult) __);
}

/// @nodoc

class InitSuccess implements InitResult {
  const InitSuccess(this.metadata);

  final MbTilesMetadata metadata;

  /// Create a copy of InitResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InitSuccessCopyWith<InitSuccess> get copyWith =>
      _$InitSuccessCopyWithImpl<InitSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InitSuccess &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, metadata);

  @override
  String toString() {
    return 'InitResult.success(metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $InitSuccessCopyWith<$Res>
    implements $InitResultCopyWith<$Res> {
  factory $InitSuccessCopyWith(
          InitSuccess value, $Res Function(InitSuccess) _then) =
      _$InitSuccessCopyWithImpl;
  @useResult
  $Res call({MbTilesMetadata metadata});
}

/// @nodoc
class _$InitSuccessCopyWithImpl<$Res> implements $InitSuccessCopyWith<$Res> {
  _$InitSuccessCopyWithImpl(this._self, this._then);

  final InitSuccess _self;
  final $Res Function(InitSuccess) _then;

  /// Create a copy of InitResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? metadata = null,
  }) {
    return _then(InitSuccess(
      null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as MbTilesMetadata,
    ));
  }
}

/// @nodoc

class InitError implements InitResult {
  const InitError(this.message);

  final String message;

  /// Create a copy of InitResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InitErrorCopyWith<InitError> get copyWith =>
      _$InitErrorCopyWithImpl<InitError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InitError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'InitResult.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $InitErrorCopyWith<$Res>
    implements $InitResultCopyWith<$Res> {
  factory $InitErrorCopyWith(InitError value, $Res Function(InitError) _then) =
      _$InitErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$InitErrorCopyWithImpl<$Res> implements $InitErrorCopyWith<$Res> {
  _$InitErrorCopyWithImpl(this._self, this._then);

  final InitError _self;
  final $Res Function(InitError) _then;

  /// Create a copy of InitResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(InitError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
