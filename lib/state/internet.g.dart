// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internet.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

final $_ToggleMap = {
  "on": Toggle.on,
  "off": Toggle.off,
};

final $_ConnectionStatusMap = {
  "connected": ConnectionStatus.connected,
  "disconnected": ConnectionStatus.disconnected,
};

abstract mixin class $InternetData implements Syncable<InternetData> {
  Toggle get modemState;
  ConnectionStatus get unuCloud;
  ConnectionStatus get status;
  String get ipAddress;
  String get accessTech;
  int get signalQuality;
  String get simImei;
  String get simIccid;
  get syncSettings => SyncSettings(
      "aux-battery",
      Duration(microseconds: 5000000),
      [
        SyncFieldSettings(
            name: "modemState",
            variable: "modem-state",
            type: SyncFieldType.enum_,
            typeName: "Toggle",
            defaultValue: "off",
            interval: null),
        SyncFieldSettings(
            name: "unuCloud",
            variable: "unu-cloud",
            type: SyncFieldType.enum_,
            typeName: "ConnectionStatus",
            defaultValue: "disconnected",
            interval: null),
        SyncFieldSettings(
            name: "status",
            variable: "status",
            type: SyncFieldType.enum_,
            typeName: "ConnectionStatus",
            defaultValue: "disconnected",
            interval: null),
        SyncFieldSettings(
            name: "ipAddress",
            variable: "ip-address",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "accessTech",
            variable: "access-tech",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "signalQuality",
            variable: "signal-quality",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "simImei",
            variable: "sim-imei",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "simIccid",
            variable: "sim-iccid",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
      ],
      "null");

  @override
  InternetData update(String name, String value) {
    return InternetData(
      modemState:
          "modem-state" != name ? modemState : $_ToggleMap[value] ?? Toggle.off,
      unuCloud: "unu-cloud" != name
          ? unuCloud
          : $_ConnectionStatusMap[value] ?? ConnectionStatus.disconnected,
      status: "status" != name
          ? status
          : $_ConnectionStatusMap[value] ?? ConnectionStatus.disconnected,
      ipAddress: "ip-address" != name ? ipAddress : value,
      accessTech: "access-tech" != name ? accessTech : value,
      signalQuality:
          "signal-quality" != name ? signalQuality : int.parse(value),
      simImei: "sim-imei" != name ? simImei : value,
      simIccid: "sim-iccid" != name ? simIccid : value,
    );
  }

  List<Object?> get props => [
        modemState,
        unuCloud,
        status,
        ipAddress,
        accessTech,
        signalQuality,
        simImei,
        simIccid
      ];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("InternetData(");
    buf.writeln("	modemState = $modemState");
    buf.writeln("	unuCloud = $unuCloud");
    buf.writeln("	status = $status");
    buf.writeln("	ipAddress = $ipAddress");
    buf.writeln("	accessTech = $accessTech");
    buf.writeln("	signalQuality = $signalQuality");
    buf.writeln("	simImei = $simImei");
    buf.writeln("	simIccid = $simIccid");
    buf.writeln(")");

    return buf.toString();
  }
}
