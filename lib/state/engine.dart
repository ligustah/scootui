import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import './enums.dart';

part 'engine.g.dart';

@StateClass("engine-ecu", Duration(seconds: 1))
class EngineData extends Equatable with $EngineData {
  @StateField(name: "state", defaultValue: "off", interval: Duration(seconds: 10))
  final Toggle powerState;

  @StateField(name: "kers", defaultValue: "on")
  final Toggle kers;

  @StateField()
  final String kersReasonOff;

  @StateField(name: "motor:voltage")
  final num motorVoltage;

  @StateField(name: "motor:current")
  final num motorCurrent;

  @StateField()
  final num rpm;

  @StateField(interval: Duration(milliseconds: 100))
  final num speed;

  @StateField(defaultValue: "off")
  final Toggle throttle;

  @StateField(name: "fw-version")
  final String firmwareVersion;

  @StateField(interval: Duration(seconds: 5))
  final double odometer;

  @StateField()
  final double temperature;

  double get powerOutput => motorVoltage * motorCurrent / 1000;

  EngineData({
    this.powerState = Toggle.off,
    this.kers = Toggle.on,
    this.kersReasonOff = "none",
    this.speed = 0,
    this.firmwareVersion = "",
    this.motorCurrent = 0,
    this.motorVoltage = 0,
    this.odometer = 0,
    this.rpm = 0,
    this.temperature = 0,
    this.throttle = Toggle.off,
  });
}
