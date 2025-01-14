import 'package:flutter/material.dart';
import '../../models/vehicle_state.dart';

class BottomStatusBar extends StatelessWidget {
  final VehicleState state;
  final String? errorMessage;
  final String? bluetoothPinCode;

  const BottomStatusBar({
    super.key, 
    required this.state,
    this.errorMessage,
    this.bluetoothPinCode,
  });

  String? _getStatusMessage() {
    if (errorMessage != null) {
      return errorMessage;
    }
    
    if (!state.battery0Present && !state.battery1Present) {
      return 'No battery connected';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final message = _getStatusMessage();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: message != null 
        ? Center(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
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
