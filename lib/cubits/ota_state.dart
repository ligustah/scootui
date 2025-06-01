part of 'ota_cubit.dart';

@freezed
sealed class OtaState with _$OtaState {
  // No OTA update is active or visible
  const factory OtaState.inactive() = OtaInactive;

  // Status bar icon for OTA updates (shown in unlocked states)
  const factory OtaState.statusBar({
    required OtaStatus status,
    required String statusText,
  }) = OtaStatusBar;

  // Full-screen OTA display (shown in parked or standby mode)
  const factory OtaState.fullScreen({
    required OtaStatus status,
    required String statusText,
    required bool isParked, // Controls background opacity
  }) = OtaFullScreen;
}
