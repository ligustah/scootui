part of 'screen_cubit.dart';

@freezed
sealed class ScreenState with _$ScreenState {
  const factory ScreenState.cluster() = ScreenCluster;
  const factory ScreenState.map() = ScreenMap;
}
