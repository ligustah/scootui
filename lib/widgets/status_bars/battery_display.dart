import 'package:flutter/material.dart';
import '../../models/vehicle_state.dart';

class BatteryStatusDisplay extends StatelessWidget {
  final VehicleState state;

  const BatteryStatusDisplay({super.key, required this.state});

  Color _getBatteryColor(BuildContext context, bool isPresent, double charge, String batteryState) {
    if (!isPresent) return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    
    if (batteryState == 'fault') return Theme.of(context).colorScheme.error;
    if (charge <= 20) return Theme.of(context).colorScheme.error;
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
                    state.battery0Present,
                    state.battery0Charge,
                    state.battery0State,
                  ),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  state.battery0Present 
                    ? '${state.battery0Charge.toStringAsFixed(0)}%'
                    : '--',
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            if (state.battery0Present) ...[
              Text(
                state.battery0TempState == 'high' 
                  ? 'High Temp!'
                  : state.battery0State,
                style: TextStyle(
                  fontSize: 12,
                  color: state.battery0TempState == 'high' || state.battery0State == 'fault'
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

class SecondaryBatteryDisplay extends StatelessWidget {
  final VehicleState state;

  const SecondaryBatteryDisplay({super.key, required this.state});

  Color _getBatteryColor(BuildContext context, bool isPresent, double charge, String batteryState) {
    if (!isPresent) return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    
    if (batteryState == 'fault') return Theme.of(context).colorScheme.error;
    if (charge <= 20) return Theme.of(context).colorScheme.error;
    if (charge <= 30) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.textTheme.bodyLarge?.color;
    final secondaryColor = theme.textTheme.bodyMedium?.color;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.battery_4_bar,
              color: _getBatteryColor(
                context,
                state.battery1Present,
                state.battery1Charge,
                state.battery1State,
              ),
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              state.battery1Present 
                ? '${state.battery1Charge.toStringAsFixed(0)}%'
                : '--',
              style: TextStyle(
                fontSize: 16,
                color: primaryColor,
              ),
            ),
          ],
        ),
        if (state.battery1Present) ...[
          Text(
            state.battery1TempState == 'high'
              ? 'High Temp!'
              : state.battery1State,
            style: TextStyle(
              fontSize: 12,
              color: state.battery1TempState == 'high' || state.battery1State == 'fault'
                ? theme.colorScheme.error
                : secondaryColor,
            ),
          ),
        ],
      ],
    );
  }
}

class CombinedBatteryDisplay extends StatelessWidget {
  final VehicleState state;
  
  const CombinedBatteryDisplay({super.key, required this.state});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BatteryStatusDisplay(state: state),
        if (state.battery1Present) ...[
          const SizedBox(width: 8),
          SecondaryBatteryDisplay(state: state),
        ],
      ],
    );
  }
}