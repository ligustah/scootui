import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../state/battery.dart';

class BatteryStatusDisplay extends StatelessWidget {
  final BatteryData battery;

  const BatteryStatusDisplay({super.key, required this.battery});

  Color _getBatteryColor(BuildContext context, bool isPresent, int charge,
      String batteryState) {
    if (!isPresent)
      return Theme
          .of(context)
          .textTheme
          .bodyMedium
          ?.color ?? Colors.grey;

    if (batteryState == 'fault') return Theme
        .of(context)
        .colorScheme
        .error;
    if (charge <= 20) return Theme
        .of(context)
        .colorScheme
        .error;
    if (charge <= 30) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.textTheme.bodyLarge?.color;
    final secondaryColor = theme.textTheme.bodyMedium?.color;

    // Primary battery indicator
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First driving battery
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.battery_full,
                  color: _getBatteryColor(
                    context,
                    battery.present,
                    battery.charge,
                    battery.state,
                  ),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  battery.present ? '${battery.charge}%' : '--',
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            if (battery.present) ...[
              Text(
                battery.temperatureState == 'high'
                    ? 'High Temp!'
                    : battery.state,
                style: TextStyle(
                  fontSize: 12,
                  color: battery.temperatureState == 'high' ||
                      battery.state == 'fault'
                      ? theme.colorScheme.error
                      : secondaryColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class CombinedBatteryDisplay extends StatelessWidget {
  const CombinedBatteryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final battery1 = Battery1Sync.watch(context);
    final battery2 = Battery2Sync.watch(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BatteryStatusDisplay(battery: battery1),
        if (battery2.present) ...[
          const SizedBox(width: 8),
          BatteryStatusDisplay(battery: battery2,),
        ],
      ],
    );
  }
}
