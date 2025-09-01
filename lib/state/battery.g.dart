// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

final $_BatteryStateMap = {
  "unknown": BatteryState.unknown,
  "asleep": BatteryState.asleep,
  "idle": BatteryState.idle,
  "active": BatteryState.active,
};

abstract mixin class $BatteryData implements Syncable<BatteryData> {
  dynamic get id;
  bool get present;
  BatteryState get state;
  int get voltage;
  int get current;
  int get charge;
  int get temperature0;
  int get temperature1;
  int get temperature2;
  int get temperature3;
  String get temperatureState;
  int get cycleCount;
  int get stateOfHealth;
  String get serialNumber;
  String get manufacturingDate;
  String get firmwareVersion;
  int get fault;
  get syncSettings => SyncSettings(
      "battery:$id",
      Duration(microseconds: 30000000),
      [
        SyncFieldSettings(
            name: "present",
            variable: "present",
            type: SyncFieldType.bool,
            typeName: "bool",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "state",
            variable: "state",
            type: SyncFieldType.enum_,
            typeName: "BatteryState",
            defaultValue: "unknown",
            interval: null),
        SyncFieldSettings(
            name: "voltage",
            variable: "voltage",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "current",
            variable: "current",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "charge",
            variable: "charge",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "temperature0",
            variable: "temperature:0",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "temperature1",
            variable: "temperature:1",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "temperature2",
            variable: "temperature:2",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "temperature3",
            variable: "temperature:3",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "temperatureState",
            variable: "temperature-state",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "cycleCount",
            variable: "cycle-count",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "stateOfHealth",
            variable: "state-of-health",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "serialNumber",
            variable: "serial-number",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "manufacturingDate",
            variable: "manufacturing-date",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "firmwareVersion",
            variable: "fw-version",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "fault",
            variable: "fault",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
      ],
      "id");

  @override
  BatteryData update(String name, String value) {
    return BatteryData(
      id: id,
      present: "present" != name ? present : bool.parse(value),
      state: "state" != name
          ? state
          : $_BatteryStateMap[value] ?? BatteryState.unknown,
      voltage: "voltage" != name ? voltage : int.parse(value),
      current: "current" != name ? current : int.parse(value),
      charge: "charge" != name ? charge : int.parse(value),
      temperature0: "temperature:0" != name ? temperature0 : int.parse(value),
      temperature1: "temperature:1" != name ? temperature1 : int.parse(value),
      temperature2: "temperature:2" != name ? temperature2 : int.parse(value),
      temperature3: "temperature:3" != name ? temperature3 : int.parse(value),
      temperatureState: "temperature-state" != name ? temperatureState : value,
      cycleCount: "cycle-count" != name ? cycleCount : int.parse(value),
      stateOfHealth:
          "state-of-health" != name ? stateOfHealth : int.parse(value),
      serialNumber: "serial-number" != name ? serialNumber : value,
      manufacturingDate:
          "manufacturing-date" != name ? manufacturingDate : value,
      firmwareVersion: "fw-version" != name ? firmwareVersion : value,
      fault: "fault" != name ? fault : int.parse(value),
    );
  }

  List<Object?> get props => [
        present,
        state,
        voltage,
        current,
        charge,
        temperature0,
        temperature1,
        temperature2,
        temperature3,
        temperatureState,
        cycleCount,
        stateOfHealth,
        serialNumber,
        manufacturingDate,
        firmwareVersion,
        fault
      ];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("BatteryData(");
    buf.writeln("	present = $present");
    buf.writeln("	state = $state");
    buf.writeln("	voltage = $voltage");
    buf.writeln("	current = $current");
    buf.writeln("	charge = $charge");
    buf.writeln("	temperature0 = $temperature0");
    buf.writeln("	temperature1 = $temperature1");
    buf.writeln("	temperature2 = $temperature2");
    buf.writeln("	temperature3 = $temperature3");
    buf.writeln("	temperatureState = $temperatureState");
    buf.writeln("	cycleCount = $cycleCount");
    buf.writeln("	stateOfHealth = $stateOfHealth");
    buf.writeln("	serialNumber = $serialNumber");
    buf.writeln("	manufacturingDate = $manufacturingDate");
    buf.writeln("	firmwareVersion = $firmwareVersion");
    buf.writeln("	fault = $fault");
    buf.writeln(")");

    return buf.toString();
  }
}
