import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../state/vehicle.dart';
import '../../state/enums.dart';
import 'indicator_lights.dart';

class WarningIndicators extends StatelessWidget {
  const WarningIndicators({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = VehicleSync.watch(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left turn signal
          IndicatorLights.leftBlinker(state),

          // Center indicators cluster
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.isUnableToDrive == Toggle.on) IndicatorLights.engineWarning(state),
              if (state.blinkerState == BlinkerState.both) IndicatorLights.hazards(state),
              if (state.state == ScooterState.parked) IndicatorLights.parkingBrake(state),
            ],
          ),

          // Right turn signal
          IndicatorLights.rightBlinker(state),
        ],
      ),
    );
  }
}
