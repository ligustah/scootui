import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../../state/enums.dart';
import '../../state/vehicle.dart';
import '../indicators/indicator_lights.dart';
import '../indicators/speed_limit_indicator.dart';

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
            top: 46, // Below the status bar (30px) + margin
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
            top: 46, // Below the status bar (30px) + margin
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

        // Road name display below vehicle icon (center of map) - only show if content exists
        Positioned(
          top: 260, // Roughly center of 480px height, below vehicle position
          left: 60,
          right: 60,
          child: Center(
            child: Builder(
              builder: (context) {
                final speedLimitData = SpeedLimitSync.watch(context);
                // Only show container if there's actually a road name
                if (speedLimitData.roadName.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: RoadNameDisplay(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Warning indicators in bottom left corner (only show if any warnings are active)
        if (vehicleState.isUnableToDrive == Toggle.on || 
            vehicleState.blinkerState == BlinkerState.both || 
            vehicleState.state == ScooterState.parked)
          Positioned(
            bottom: 100, // Just above the bottom status bar
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (vehicleState.isUnableToDrive == Toggle.on) ...[
                    IndicatorLights.engineWarning(vehicleState),
                    const SizedBox(width: 8),
                  ],
                  if (vehicleState.blinkerState == BlinkerState.both) ...[
                    IndicatorLights.hazards(vehicleState),
                    const SizedBox(width: 8),
                  ],
                  if (vehicleState.state == ScooterState.parked) ...[
                    IndicatorLights.parkingBrake(vehicleState),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}