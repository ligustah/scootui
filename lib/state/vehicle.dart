import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import './enums.dart';

part 'vehicle.g.dart';

enum BlinkerState { off, left, right, both }

enum BlinkerSwitch { off, left, right }

enum HandleBarLockSensor { locked, unlocked }

enum SeatboxLock { open, closed }

enum ScooterState { standBy, readyToDrive, off, parked }

enum Kickstand { up, down }

enum HandleBarPosition { onPlace }

@StateClass("vehicle", Duration(seconds: 1))
class VehicleData with $VehicleData {
  @StateField(name: "blinker:state", defaultValue: "off")
  BlinkerState blinkerState;

  @StateField(
    name: "blinker:switch",
    defaultValue: "off",
    interval: Duration(seconds: 2),
  )
  BlinkerSwitch blinkerSwitch;

  @StateField(
    name: "brake:left",
    defaultValue: "off",
    interval: Duration(seconds: 30),
  )
  Toggle brakeLeft;

  @StateField(
    name: "brake:right",
    defaultValue: "off",
    interval: Duration(seconds: 30),
  )
  Toggle brakeRight;

  @StateField(defaultValue: "down")
  Kickstand kickstand;

  @StateField(defaultValue: "off")
  ScooterState state;

  @StateField(name: "handlebar:lock-sensor", defaultValue: "locked")
  HandleBarLockSensor handleBarLockSensor;

  @StateField(name: "handlebar:position", defaultValue: "onPlace")
  HandleBarPosition handleBarPosition;

  @StateField(name: "seatbox:button", defaultValue: "off")
  Toggle seatboxButton;

  @StateField(
    name: "seatbox:lock",
    defaultValue: "closed",
    interval: Duration(seconds: 30),
  )
  SeatboxLock seatboxLock;

  @StateField(defaultValue: "off")
  Toggle hornButton;

  VehicleData({
    this.blinkerSwitch = BlinkerSwitch.off,
    this.blinkerState = BlinkerState.off,
    this.state = ScooterState.off,
    this.kickstand = Kickstand.down,
    this.handleBarLockSensor = HandleBarLockSensor.locked,
    this.brakeLeft = Toggle.off,
    this.brakeRight = Toggle.off,
    this.hornButton = Toggle.off,
    this.seatboxLock = SeatboxLock.closed,
    this.handleBarPosition = HandleBarPosition.onPlace,
    this.seatboxButton = Toggle.off,
  });
}