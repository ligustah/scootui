// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ota.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

abstract mixin class $OtaData implements Syncable<OtaData> {
  String get otaStatus;
  get syncSettings => SyncSettings(
      "ota",
      Duration(microseconds: 1000000),
      [
        SyncFieldSettings(
            name: "otaStatus",
            variable: "status",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: "unknown",
            interval: null),
      ],
      "null");

  @override
  OtaData update(String name, String value) {
    return OtaData(
      otaStatus: "status" != name ? otaStatus : value,
    );
  }

  List<Object?> get props => [otaStatus];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("OtaData(");
    buf.writeln("	otaStatus = $otaStatus");
    buf.writeln(")");

    return buf.toString();
  }
}
