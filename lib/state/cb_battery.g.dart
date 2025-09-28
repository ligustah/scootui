// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cb_battery.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

final $_ChargeStatusMap = {
  "charging": ChargeStatus.charging,
  "not-charging": ChargeStatus.notCharging,
};

abstract mixin class $CbBatteryData implements Syncable<CbBatteryData> {
  int get charge;
  int get current;
  int get remainingCapacity;
  int get temperature;
  int get cycleCount;
  int get timeToFull;
  int get timeToEmpty;
  int get cellVoltage;
  int get fullCapacity;
  int get stateOfHealth;
  bool get present;
  ChargeStatus get chargeStatus;
  String get partNumber;
  String get serialNumber;
  String get uniqueId;
  get syncSettings => SyncSettings(
      "cb-battery",
      Duration(microseconds: 30000000),
      [
        SyncFieldSettings(
            name: "charge",
            variable: "charge",
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
            name: "remainingCapacity",
            variable: "remaining-capacity",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "temperature",
            variable: "temperature",
            type: SyncFieldType.int,
            typeName: "int",
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
            name: "timeToFull",
            variable: "time-to-full",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "timeToEmpty",
            variable: "time-to-empty",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "cellVoltage",
            variable: "cell-voltage",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "fullCapacity",
            variable: "full-capacity",
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
            name: "present",
            variable: "present",
            type: SyncFieldType.bool,
            typeName: "bool",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "chargeStatus",
            variable: "charge-status",
            type: SyncFieldType.enum_,
            typeName: "ChargeStatus",
            defaultValue: "notCharging",
            interval: null),
        SyncFieldSettings(
            name: "partNumber",
            variable: "part-number",
            type: SyncFieldType.string,
            typeName: "String",
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
            name: "uniqueId",
            variable: "unique-id",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
      ],
      "null");

  @override
  CbBatteryData update(String name, String value) {
    return CbBatteryData(
      charge: "charge" != name ? charge : int.parse(value),
      current: "current" != name ? current : int.parse(value),
      remainingCapacity:
          "remaining-capacity" != name ? remainingCapacity : int.parse(value),
      temperature: "temperature" != name ? temperature : int.parse(value),
      cycleCount: "cycle-count" != name ? cycleCount : int.parse(value),
      timeToFull: "time-to-full" != name ? timeToFull : int.parse(value),
      timeToEmpty: "time-to-empty" != name ? timeToEmpty : int.parse(value),
      cellVoltage: "cell-voltage" != name ? cellVoltage : int.parse(value),
      fullCapacity: "full-capacity" != name ? fullCapacity : int.parse(value),
      stateOfHealth:
          "state-of-health" != name ? stateOfHealth : int.parse(value),
      present: "present" != name ? present : bool.parse(value),
      chargeStatus: "charge-status" != name
          ? chargeStatus
          : $_ChargeStatusMap[value] ?? ChargeStatus.notCharging,
      partNumber: "part-number" != name ? partNumber : value,
      serialNumber: "serial-number" != name ? serialNumber : value,
      uniqueId: "unique-id" != name ? uniqueId : value,
    );
  }

  List<Object?> get props => [
        charge,
        current,
        remainingCapacity,
        temperature,
        cycleCount,
        timeToFull,
        timeToEmpty,
        cellVoltage,
        fullCapacity,
        stateOfHealth,
        present,
        chargeStatus,
        partNumber,
        serialNumber,
        uniqueId
      ];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("CbBatteryData(");
    buf.writeln("	charge = $charge");
    buf.writeln("	current = $current");
    buf.writeln("	remainingCapacity = $remainingCapacity");
    buf.writeln("	temperature = $temperature");
    buf.writeln("	cycleCount = $cycleCount");
    buf.writeln("	timeToFull = $timeToFull");
    buf.writeln("	timeToEmpty = $timeToEmpty");
    buf.writeln("	cellVoltage = $cellVoltage");
    buf.writeln("	fullCapacity = $fullCapacity");
    buf.writeln("	stateOfHealth = $stateOfHealth");
    buf.writeln("	present = $present");
    buf.writeln("	chargeStatus = $chargeStatus");
    buf.writeln("	partNumber = $partNumber");
    buf.writeln("	serialNumber = $serialNumber");
    buf.writeln("	uniqueId = $uniqueId");
    buf.writeln(")");

    return buf.toString();
  }
}
