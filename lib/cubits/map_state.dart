part of 'map_cubit.dart';

@freezed
sealed class MapState with _$MapState {
  const factory MapState.initial() = MapInitial;

  const factory MapState.loading() = MapLoading;

  const factory MapState.unavailable(String error) = MapUnavailable;

  const factory MapState.loaded({
    required MbTiles mbTiles,
    required LatLng position,
    required double orientation,
    required MapController controller,
    required Theme theme,
    void Function ()? onReady,
    @Default(false) bool isReady,
  }) = MapLoaded;
}
