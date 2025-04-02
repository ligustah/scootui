import 'package:flutter/material.dart';

import '../../state/vehicle.dart';
import 'indicator_light.dart';

final class IndicatorLights {
  static IndicatorLight rightBlinker(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-turn-right.svg'),
        isActive: state.blinkerState == BlinkerState.right ||
            state.blinkerState == BlinkerState.both,
        activeColor: Colors.green,
        size: 48,
        blinking: true,
      );

  static IndicatorLight leftBlinker(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-turn-left.svg'),
        isActive: state.blinkerState == BlinkerState.left ||
            state.blinkerState == BlinkerState.both,
        activeColor: Colors.green,
        size: 48,
        blinking: true,
      );

  static IndicatorLight parkingBrake(VehicleData state) => IndicatorLight(
        icon: IndicatorLight.svgAsset('librescoot-parking-brake.svg'),
        isActive: state.state == ScooterState.parked,
        activeColor: Colors.red,
        size: 36, // Smaller than blinkers
      );
}
