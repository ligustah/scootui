import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import 'indicator_lights.dart';
import 'speed_limit_indicator.dart';

class WarningIndicators extends StatelessWidget {
  const WarningIndicators({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = VehicleSync.watch(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left turn signal
          IndicatorLights.leftBlinker(state),

          // Center section with parking indicator and speed limit
          Row(
            children: [
              // Parking indicator
              IndicatorLights.parkingBrake(state),
              
              // Small spacer between indicators
              const SizedBox(width: 10),
              
              // Speed limit indicator
              const SpeedLimitIndicator(iconSize: 36),
            ],
          ),

          // Right turn signal
          IndicatorLights.rightBlinker(state),
        ],
      ),
    );
  }
}

