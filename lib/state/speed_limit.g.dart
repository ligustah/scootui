// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed_limit.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

abstract mixin class $SpeedLimitData implements Syncable<SpeedLimitData> {
  String get value;
  String get roadName;
  String get roadType;
  get syncSettings => SyncSettings(
      "speed_limit",
      Duration(microseconds: 5000000),
      [
        SyncFieldSettings(
            name: "value",
            variable: "value",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "roadName",
            variable: "road_name",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "roadType",
            variable: "road_type",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
      ],
      "null");

  @override
  SpeedLimitData update(String name, String value) {
    return SpeedLimitData(
      value: "value" != name ? value : value,
      roadName: "road_name" != name ? roadName : value,
      roadType: "road_type" != name ? roadType : value,
    );
  }

  List<Object?> get props => [value, roadName, roadType];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("SpeedLimitData(");
    buf.writeln("	value = $value");
    buf.writeln("	roadName = $roadName");
    buf.writeln("	roadType = $roadType");
    buf.writeln(")");

    return buf.toString();
  }
}
