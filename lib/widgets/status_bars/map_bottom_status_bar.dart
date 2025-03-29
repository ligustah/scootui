import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cubits/mdb_cubits.dart';
import '../../state/vehicle.dart';

class MapBottomStatusBar extends StatelessWidget {
  const MapBottomStatusBar({
    super.key,
  });

  Widget _buildBlinkerIcon(
      BuildContext context, String iconPath, bool isActive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color =
        isActive ? Colors.green : (isDark ? Colors.white24 : Colors.black26);

    return SvgPicture.asset(
      iconPath,
      width: 48,
      height: 48,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    final engine = EngineSync.watch(context);
    final vehicle = VehicleSync.watch(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left blinker
          _buildBlinkerIcon(
            context,
            'assets/icons/librescoot-turn-left.svg',
            vehicle.blinkerState == BlinkerState.left ||
                vehicle.blinkerState == BlinkerState.both,
          ),

          // Speed display
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                engine.speed.toStringAsFixed(0),
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
          _buildBlinkerIcon(
            context,
            'assets/icons/librescoot-turn-right.svg',
            vehicle.blinkerState == BlinkerState.right ||
                vehicle.blinkerState == BlinkerState.both,
          ),
        ],
      ),
    );
  }
}
