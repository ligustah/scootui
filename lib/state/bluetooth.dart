import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import 'enums.dart';

part 'bluetooth.g.dart';

@StateClass("ble", Duration(seconds: 5))
class BluetoothData extends Equatable with $BluetoothData {
  @override
  @StateField(defaultValue: "disconnected")
  final ConnectionStatus status;

  @override
  @StateField()
  final String macAddress;

  @override
  @StateField()
  final String pinCode;

  BluetoothData({
    this.macAddress = "",
    this.pinCode = "",
    this.status = ConnectionStatus.disconnected,
  });
}
