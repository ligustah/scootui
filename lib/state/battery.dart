import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'battery.g.dart';

enum BatteryState { unknown, asleep, idle, active }

@StateClass("battery", Duration(seconds: 30))
class BatteryData extends Equatable with $BatteryData {
  @override
  @StateDiscriminator()
  final String id;

  @override
  @StateField()
  final bool present;

  @override
  @StateField(defaultValue: 'unknown')
  final BatteryState state;

  @override
  @StateField()
  final int voltage;

  @override
  @StateField()
  final int current;

  @override
  @StateField()
  final int charge;

  @override
  @StateField(name: "temperature:0")
  final int temperature0;

  @override
  @StateField(name: "temperature:1")
  final int temperature1;

  @override
  @StateField(name: "temperature:2")
  final int temperature2;

  @override
  @StateField(name: "temperature:3")
  final int temperature3;

  @override
  @StateField()
  final String temperatureState;

  @override
  @StateField()
  final int cycleCount;

  @override
  @StateField()
  final int stateOfHealth;

  @override
  @StateField()
  final String serialNumber;

  @override
  @StateField()
  final String manufacturingDate;

  @override
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
