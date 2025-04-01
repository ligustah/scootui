import 'package:flutter/material.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../../state/battery.dart';

class BottomStatusBar extends StatelessWidget {
  final String? errorMessage;
  final String? bluetoothPinCode;

  const BottomStatusBar({
    super.key, 
    this.errorMessage,
    this.bluetoothPinCode,
  });

  String? _getStatusMessage(BatteryData battery1, BatteryData battery2) {
    if (errorMessage != null) {
      return errorMessage;
    }
    
    if (!battery1.present && !battery2.present) {
      return 'No battery connected';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final battery1 = Battery1Sync.watch(context);
    final battery2 = Battery2Sync.watch(context);
    final ThemeState(:theme) = ThemeCubit.watch(context);

    final message = _getStatusMessage(battery1, battery2);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: message != null 
        ? Center(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ) 
        : bluetoothPinCode != null
          ? Center(
              child: Text(
                'Bluetooth Pin Code: $bluetoothPinCode',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
