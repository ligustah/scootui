import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../indicators/indicator_lights.dart';
import '../indicators/speed_limit_indicator.dart';

class MapBottomStatusBar extends StatelessWidget {
  const MapBottomStatusBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final speed = EngineSync.select(context, (data) => data.speed);
    final vehicle = VehicleSync.watch(context);
    final ThemeState(:isDark, :theme) = ThemeCubit.watch(context);
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Road name display at the top
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: RoadNameDisplay(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          
          // Main controls row below
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left section with blinker and speed limit
                Row(
                  children: [
                    // Left blinker
                    IndicatorLights.leftBlinker(vehicle),
                    
                    // Small space between blinker and speed limit
                    const SizedBox(width: 12),
                    
                    // Speed limit indicator
                    const SpeedLimitIndicator(iconSize: 40),
                  ],
                ),
      
                // Speed display
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      speed.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'km/h',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
      
                // Right blinker
                IndicatorLights.rightBlinker(vehicle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
