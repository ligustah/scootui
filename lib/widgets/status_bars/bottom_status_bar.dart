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

  String? _getStatusMessage(BatteryData battery0, BatteryData battery1) {
    if (errorMessage != null) {
      return errorMessage;
    }
    
    if (!battery0.present && !battery1.present) {
      return 'No battery connected';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final battery0 = Battery0Sync.watch(context);
    final battery1 = Battery1Sync.watch(context);
    final ThemeState(:theme) = ThemeCubit.watch(context);

    final message = _getStatusMessage(battery0, battery1);
    
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
