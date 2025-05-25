import 'package:flutter/material.dart';

import '../../state/vehicle.dart';
import '../../state/enums.dart';
import 'indicator_light.dart';

final class IndicatorLights {
  static IndicatorLight rightBlinker(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-turn-right.svg'),
        isActive: state.blinkerState == BlinkerState.right || state.blinkerState == BlinkerState.both,
        activeColor: Colors.green,
        size: 64,
        blinking: true,
      );

  static IndicatorLight leftBlinker(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-turn-left.svg'),
        isActive: state.blinkerState == BlinkerState.left || state.blinkerState == BlinkerState.both,
        activeColor: Colors.green,
        size: 64,
        blinking: true,
      );

  static IndicatorLight parkingBrake(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-parking-brake.svg'),
        isActive: state.state == ScooterState.parked,
        activeColor: Colors.red,
        size: 36, // Smaller than blinkers
      );

  static IndicatorLight engineWarning(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-engine-warning.svg'),
        isActive: state.isUnableToDrive == Toggle.on,
        activeColor: Colors.yellow,
        size: 36,
      );

  static IndicatorLight hazards(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-hazards.svg'),
        isActive: state.blinkerState == BlinkerState.both,
        activeColor: Colors.red,
        size: 36,
        blinking: true,
      );
}
