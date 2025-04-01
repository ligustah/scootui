import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../../state/battery.dart';

const powerLevels = [
  (88, Icons.battery_full, Colors.green),
  (75, Icons.battery_6_bar, Colors.green),
  (63, Icons.battery_5_bar, Colors.green),
  (50, Icons.battery_4_bar, Colors.green),
  (38, Icons.battery_3_bar, Colors.green),
  (30, Icons.battery_2_bar, Colors.green),
  (25, Icons.battery_2_bar, Colors.orange),
  (15, Icons.battery_1_bar, Colors.orange),
  (10, Icons.battery_1_bar, Colors.red),
  (0, Icons.battery_0_bar, Colors.red),
];

class BatteryStatusDisplay extends StatelessWidget {
  final BatteryData battery;

  const BatteryStatusDisplay({super.key, required this.battery});

  (IconData, MaterialColor) getIcon(BatteryData battery) {
    if (!battery.present) {
      return (Icons.battery_0_bar, Colors.grey);
    }

    if (battery.state == 'fault') {
      return (Icons.battery_alert, Colors.red);
    }

    for (final (threshold, icon, color) in powerLevels) {
      if (battery.charge >= threshold) return (icon, color);
    }

    // we shouldn't ever get here, so just in case
    return (Icons.battery_unknown, Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = getIcon(battery);

    // Primary battery indicator
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        if (battery.present) ...[
          Text(
            '${battery.charge.toStringAsFixed(0)}%',
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
        SizedBox(width: 60, child: BatteryStatusDisplay(battery: battery1)),
        if (battery2.present) ...[
          BatteryStatusDisplay(
            battery: battery2,
          ),
        ],
      ],
    );
  }
}
