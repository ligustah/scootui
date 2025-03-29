import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../models/vehicle_state.dart';
import '../../state/bluetooth.dart';
import '../../state/enums.dart';
import 'battery_display.dart';

class StatusBar extends StatelessWidget {
  final VehicleState state;
  final String currentTime;

  const StatusBar({
    super.key,
    required this.state,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    final bluetooth = BluetoothSync.watch(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Left side - Battery indicators
          Expanded(
            flex: 2,
            child: CombinedBatteryDisplay(),
          ),

          // Center - Time
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                currentTime,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),

          // Right side - Bluetooth icon
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.bluetooth,
                  color: bluetooth.status == ConnectionStatus.connected ? Colors.blue : Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
