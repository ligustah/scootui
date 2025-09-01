import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../../state/enums.dart';
import '../../state/vehicle.dart';
import '../indicators/indicator_lights.dart';

class MapOverlayIndicators extends StatelessWidget {
  const MapOverlayIndicators({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vehicleState = VehicleSync.watch(context);
    final ThemeState(:theme, :isDark) = ThemeCubit.watch(context);

    return Stack(
      children: [
        // Top left blinker (only when active)
        if (vehicleState.blinkerState == BlinkerState.left || vehicleState.blinkerState == BlinkerState.both)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                  width: 1,
                ),
              ),
              child: Center(
                child: Transform.scale(
                  scale: 0.8,
                  child: IndicatorLights.leftBlinker(vehicleState),
                ),
              ),
            ),
          ),

        // Top right blinker (only when active)
        if (vehicleState.blinkerState == BlinkerState.right || vehicleState.blinkerState == BlinkerState.both)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                  width: 1,
                ),
              ),
              child: Center(
                child: Transform.scale(
                  scale: 0.8,
                  child: IndicatorLights.rightBlinker(vehicleState),
                ),
              ),
            ),
          ),
      ],
    );
  }
}