// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aux_battery.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

final $_AuxChargeStatusMap = {
  "not-charging": AuxChargeStatus.notCharging,
  "float-charge": AuxChargeStatus.floatCharge,
  "absorption-charge": AuxChargeStatus.absorptionCharge,
  "bulk-charge": AuxChargeStatus.bulkCharge,
};

abstract mixin class $AuxBatteryData implements Syncable<AuxBatteryData> {
  int get dateStreamEnable;
  int get voltage;
  int get charge;
  AuxChargeStatus get chargeStatus;
  get syncSettings => SyncSettings(
      "aux-battery",
      Duration(microseconds: 30000000),
      [
        SyncFieldSettings(
            name: "dateStreamEnable",
            variable: "date-stream-enable",
            type: SyncFieldType.int,
            typeName: "int",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "voltage",
            variable: "voltage",
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
            name: "chargeStatus",
            variable: "charge-status",
            type: SyncFieldType.enum_,
            typeName: "AuxChargeStatus",
            defaultValue: "floatCharge",
            interval: null),
      ],
      "null",
      []);

  @override
  AuxBatteryData update(String name, String value) {
    return AuxBatteryData(
      dateStreamEnable:
          "date-stream-enable" != name ? dateStreamEnable : int.parse(value),
      voltage: "voltage" != name ? voltage : int.parse(value),
      charge: "charge" != name ? charge : int.parse(value),
      chargeStatus: "charge-status" != name
          ? chargeStatus
          : $_AuxChargeStatusMap[value] ?? AuxChargeStatus.floatCharge,
    );
  }

  @override
  AuxBatteryData updateSet(String name, Set<dynamic> value) {
    return AuxBatteryData(
      dateStreamEnable: dateStreamEnable,
      voltage: voltage,
      charge: charge,
      chargeStatus: chargeStatus,
    );
  }

  List<Object?> get props => [dateStreamEnable, voltage, charge, chargeStatus];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("AuxBatteryData(");
    buf.writeln("	dateStreamEnable = $dateStreamEnable");
    buf.writeln("	voltage = $voltage");
    buf.writeln("	charge = $charge");
    buf.writeln("	chargeStatus = $chargeStatus");
    buf.writeln(")");

    return buf.toString();
  }
}
