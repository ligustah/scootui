import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'battery.g.dart';

enum BatteryState { unknown, asleep, idle, active }

@StateClass("battery", Duration(seconds: 30))
class BatteryData extends Equatable with $BatteryData {
  @StateDiscriminator()
  final String id;

  @StateField()
  final bool present;

  @StateField(defaultValue: 'unknown')
  final BatteryState state;

  @StateField()
  final int voltage;

  @StateField()
  final int current;

  @StateField()
  final int charge;

  @StateField(name: "temperature:0")
  final int temperature0;

  @StateField(name: "temperature:1")
  final int temperature1;

  @StateField(name: "temperature:2")
  final int temperature2;

  @StateField(name: "temperature:3")
  final int temperature3;

  @StateField()
  final String temperatureState;

  @StateField()
  final int cycleCount;

  @StateField()
  final int stateOfHealth;

  @StateField()
  final String serialNumber;

  @StateField()
  final String manufacturingDate;

  @StateField(name: "fw-version")
  final String firmwareVersion;

  BatteryData({
    required this.id,
    this.present = false,
    this.state = BatteryState.unknown,
    this.voltage = 0,
    this.current = 0,
    this.charge = 0,
    this.cycleCount = 0,
    this.stateOfHealth = 0,
    this.serialNumber = "",
    this.firmwareVersion = "",
    this.manufacturingDate = "",
    this.temperature0 = 0,
    this.temperature1 = 0,
    this.temperature2 = 0,
    this.temperature3 = 0,
    this.temperatureState = "",
  });
}
