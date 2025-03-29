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

  @StateField()
  final int charge;

  @StateField()
  final int current;


  @StateField()
  final int remainingCapacity;

  @StateField()
  final int temperature;

  @StateField()
  final int cycleCount;

  @StateField()
  final int timeToFull;

  @StateField()
  final int timeToEmpty;

  @StateField()
  final int cellVoltage;

  @StateField()
  final int fullCapacity;

  @StateField()
  final int stateOfHealth;

  @StateField()
  final bool present;

  @StateField(defaultValue: "notCharging")
  final ChargeStatus chargeStatus;

  @StateField()
  final String partNumber;

  @StateField()
  final String serialNumber;

  @StateField()
  final String uniqueId;


  CbBatteryData({
    this.current = 0,
    this.temperature = 0,
    this.cellVoltage = 0,
    this.fullCapacity = 0,
    this.remainingCapacity = 0,
    this.timeToFull = 0,
    this.charge = 0,
    this.stateOfHealth = 0,
    this.cycleCount = 0,
    this.timeToEmpty = 0,
    this.present = false,
    this.chargeStatus = ChargeStatus.notCharging,
    this.partNumber = "",
    this.serialNumber = "",
    this.uniqueId = "",
  });
}
