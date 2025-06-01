// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ota.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

abstract mixin class $OtaData implements Syncable<OtaData> {
  String get otaStatus;
  String get updateType;
  String get dbcStatus;
  String get mdbStatus;
  String get dbcUpdateVersion;
  get syncSettings => SyncSettings(
      "ota",
      Duration(microseconds: 5000000),
      [
        SyncFieldSettings(
            name: "otaStatus",
            variable: "status",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: "unknown",
            interval: null),
        SyncFieldSettings(
            name: "updateType",
            variable: "update-type",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: "none",
            interval: null),
        SyncFieldSettings(
            name: "dbcStatus",
            variable: "status:dbc",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: "",
            interval: null),
        SyncFieldSettings(
            name: "mdbStatus",
            variable: "status:mdb",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: "",
            interval: null),
        SyncFieldSettings(
            name: "dbcUpdateVersion",
            variable: "update-version:dbc",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: "",
            interval: null),
      ],
      "null");

  @override
  OtaData update(String name, String value) {
    return OtaData(
      otaStatus: "status" != name ? otaStatus : value,
      updateType: "update-type" != name ? updateType : value,
      dbcStatus: "status:dbc" != name ? dbcStatus : value,
      mdbStatus: "status:mdb" != name ? mdbStatus : value,
      dbcUpdateVersion: "update-version:dbc" != name ? dbcUpdateVersion : value,
    );
  }

  List<Object?> get props =>
      [otaStatus, updateType, dbcStatus, mdbStatus, dbcUpdateVersion];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("OtaData(");
    buf.writeln("	otaStatus = $otaStatus");
    buf.writeln("	updateType = $updateType");
    buf.writeln("	dbcStatus = $dbcStatus");
    buf.writeln("	mdbStatus = $mdbStatus");
    buf.writeln("	dbcUpdateVersion = $dbcUpdateVersion");
    buf.writeln(")");

    return buf.toString();
  }
}
