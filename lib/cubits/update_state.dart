import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_state.freezed.dart';

@freezed
abstract class UpdateState with _$UpdateState {
  const factory UpdateState.idle() = _Idle;
  const factory UpdateState.checking() = _Checking;
  const factory UpdateState.downloading(double progress) = _Downloading;
  const factory UpdateState.error(String message) = _Error;
  const factory UpdateState.updateAvailable() = _UpdateAvailable;
  const factory UpdateState.updatePendingRestart() = _UpdatePendingRestart;
}
