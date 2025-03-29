import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'bluetooth.g.dart';

enum ConnectionStatus {
  connected,
  disconnected,
}

@StateClass("ble", Duration(seconds: 5))
class BluetoothData extends Equatable with $BluetoothData {
  @StateField(defaultValue: "disconnected")
  final ConnectionStatus status;

  @StateField()
  final String macAddress;

  @StateField()
  final String pinCode;

  BluetoothData({
    this.macAddress = "",
    this.pinCode = "",
    this.status = ConnectionStatus.disconnected,
  });
}
