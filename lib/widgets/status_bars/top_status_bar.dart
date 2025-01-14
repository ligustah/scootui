import 'package:flutter/material.dart';
import '../../models/vehicle_state.dart';

class StatusBar extends StatelessWidget {
  final VehicleState state;
  final String currentTime;

  const StatusBar({
    super.key,
    required this.state,
    required this.currentTime,
  });

  Widget _buildBatteryIndicator(bool isPresent, double charge, bool isSecondary) {
    IconData icon;
    Color color;
    
    if (!isPresent) {
      icon = isSecondary ? Icons.battery_4_bar : Icons.battery_full;
      color = Colors.grey;
    } else {
      // Select battery icon based on charge level
      if (charge >= 90) {
        icon = isSecondary ? Icons.battery_6_bar : Icons.battery_full;
      } else if (charge >= 70) {
        icon = isSecondary ? Icons.battery_5_bar : Icons.battery_6_bar;
      } else if (charge >= 50) {
        icon = isSecondary ? Icons.battery_4_bar : Icons.battery_5_bar;
      } else if (charge >= 30) {
        icon = isSecondary ? Icons.battery_3_bar : Icons.battery_4_bar;
      } else if (charge >= 15) {
        icon = isSecondary ? Icons.battery_2_bar : Icons.battery_3_bar;
      } else {
        icon = isSecondary ? Icons.battery_1_bar : Icons.battery_2_bar;
      }

      // Determine color based on charge level
      if (charge <= 15) {
        color = Colors.red;
      } else if (charge <= 30) {
        color = Colors.orange;
      } else {
        color = Colors.green;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        if (isPresent) ...[
          const SizedBox(width: 4),
          Text(
            '${charge.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: Row(
              children: [
                _buildBatteryIndicator(
                  state.battery0Present, 
                  state.battery0Charge,
                  false,
                ),
                if (state.battery1Present) ...[
                  const SizedBox(width: 12),
                  _buildBatteryIndicator(
                    state.battery1Present,
                    state.battery1Charge,
                    true,
                  ),
                ],
              ],
            ),
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
                  color: state.isBluetoothConnected ? Colors.blue : Colors.grey,
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
