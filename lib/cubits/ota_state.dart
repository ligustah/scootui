part of 'ota_cubit.dart';

@freezed
sealed class OtaState with _$OtaState {
  // No OTA update is active or visible
  const factory OtaState.inactive() = OtaInactive;

  // Minimal OTA info (shown at bottom of screen in ready-to-drive mode)
  const factory OtaState.minimal({
    required OtaStatus status,
    required String statusText,
  }) = OtaMinimal;

  // Full-screen OTA display (shown in parked or standby mode)
  const factory OtaState.fullScreen({
    required OtaStatus status,
    required String statusText,
    required bool isParked, // Controls background opacity
  }) = OtaFullScreen;
}
