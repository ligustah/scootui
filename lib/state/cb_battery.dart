import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'cb_battery.g.dart';

enum ChargeStatus {
  charging,
  notCharging,
}

@StateClass("cb-battery", Duration(seconds: 60))
class CbBatteryData extends Equatable with $CbBatteryData {
  @override
  @StateField()
  final int charge;

  @override
  @StateField()
  final int current;

  @override
  @StateField()
  final int remainingCapacity;

  @override
  @StateField()
  final int temperature;

  @override
  @StateField()
  final int cycleCount;

  @override
  @StateField()
  final int timeToFull;

  @override
  @StateField()
  final int timeToEmpty;

  @override
  @StateField()
  final int cellVoltage;

  @override
  @StateField()
  final int fullCapacity;

  @override
  @StateField()
  final int stateOfHealth;

  @override
  @StateField()
  final bool present;

  @override
  @StateField(defaultValue: "notCharging")
  final ChargeStatus chargeStatus;

  @override
  @StateField()
  final String partNumber;

  @override
  @StateField()
  final String serialNumber;

  @override
  @StateField()
  final String uniqueId;

  CbBatteryData({
    this.current = 0,
    this.temperature = 0,
    this.cellVoltage = 0,
    this.fullCapacity = 0,
    this.remainingCapacity = 0,
    this.timeToFull = 0,
    this.charge = 100, // Default to full charge to avoid warnings
    this.stateOfHealth = 0,
    this.cycleCount = 0,
    this.timeToEmpty = 0,
    this.present = false,
    this.chargeStatus = ChargeStatus.charging, // Default to charging to avoid warnings
    this.partNumber = "",
    this.serialNumber = "",
    this.uniqueId = "",
  });
}
