// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed_limit.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

abstract mixin class $SpeedLimitData implements Syncable<SpeedLimitData> {
  String get speedLimit;
  String get roadName;
  String get roadType;
  get syncSettings => SyncSettings(
      "speed-limit",
      Duration(microseconds: 5000000),
      [
        SyncFieldSettings(
            name: "speedLimit",
            variable: "speed-limit",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "roadName",
            variable: "road-name",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "roadType",
            variable: "road-type",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
      ],
      "null");

  @override
  SpeedLimitData update(String name, String value) {
    return SpeedLimitData(
      speedLimit: "speed-limit" != name ? speedLimit : value,
      roadName: "road-name" != name ? roadName : value,
      roadType: "road-type" != name ? roadType : value,
    );
  }

  List<Object?> get props => [speedLimit, roadName, roadType];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("SpeedLimitData(");
    buf.writeln("	speedLimit = $speedLimit");
    buf.writeln("	roadName = $roadName");
    buf.writeln("	roadType = $roadType");
    buf.writeln(")");

    return buf.toString();
  }
}
