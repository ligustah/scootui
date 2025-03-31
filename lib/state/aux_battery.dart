import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'aux_battery.g.dart';

@StateClass("aux-battery", Duration(seconds: 30))
class AuxBatteryData extends Equatable with $AuxBatteryData {
  @StateField()
  final int dateStreamEnable;

  @StateField()
  final int voltage;

  @StateField()
  final int charge;

  @StateField()
  final int chargeStatus;

  AuxBatteryData({
    this.dateStreamEnable = 0,
    this.voltage = 0,
    this.chargeStatus = 0,
    this.charge = 0,
  });
}
