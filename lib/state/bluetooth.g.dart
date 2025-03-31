// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

final $_ConnectionStatusMap = {
  "connected": ConnectionStatus.connected,
  "disconnected": ConnectionStatus.disconnected,
};

abstract mixin class $BluetoothData implements Syncable<BluetoothData> {
  ConnectionStatus get status;
  String get macAddress;
  String get pinCode;
  get syncSettings => SyncSettings(
      "ble",
      Duration(microseconds: 5000000),
      [
        SyncFieldSettings(
            name: "status",
            variable: "status",
            type: SyncFieldType.enum_,
            typeName: "ConnectionStatus",
            defaultValue: "disconnected",
            interval: null),
        SyncFieldSettings(
            name: "macAddress",
            variable: "mac-address",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "pinCode",
            variable: "pin-code",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
      ],
      "null");

  @override
  BluetoothData update(String name, String value) {
    return BluetoothData(
      status: "status" != name
          ? status
          : $_ConnectionStatusMap[value] ?? ConnectionStatus.disconnected,
      macAddress: "mac-address" != name ? macAddress : value,
      pinCode: "pin-code" != name ? pinCode : value,
    );
  }

  List<Object?> get props => [status, macAddress, pinCode];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("BluetoothData(");
    buf.writeln("	status = $status");
    buf.writeln("	macAddress = $macAddress");
    buf.writeln("	pinCode = $pinCode");
    buf.writeln(")");

    return buf.toString();
  }
}
