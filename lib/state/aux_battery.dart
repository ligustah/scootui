import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'aux_battery.g.dart';

enum AuxChargeStatus {
  notCharging,
  floatCharge,
  absorptionCharge,
  bulkCharge,
}

@StateClass("aux-battery", Duration(seconds: 30))
class AuxBatteryData extends Equatable with $AuxBatteryData {
  @override
  @StateField()
  final int dateStreamEnable;

  @override
  @StateField()
  final int voltage;

  @override
  @StateField()
  final int charge;

  @override
  @StateField(defaultValue: "floatCharge")
  final AuxChargeStatus chargeStatus;

  AuxBatteryData({
    this.dateStreamEnable = 0,
    this.voltage = 12500, // Default to 12.5V to avoid low voltage warnings
    this.chargeStatus = AuxChargeStatus.floatCharge, // Default to charging state
    this.charge = 100, // Default to full charge
  });
}
