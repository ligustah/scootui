// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

abstract mixin class $SettingsData implements Syncable<SettingsData> {
  String? get showRawSpeed;
  get syncSettings => SyncSettings(
      "settings",
      Duration(microseconds: 5000000),
      [
        SyncFieldSettings(
            name: "showRawSpeed",
            variable: "dashboard.show-raw-speed",
            type: SyncFieldType.string,
            typeName: "String?",
            defaultValue: "false",
            interval: null),
      ],
      "null");

  @override
  SettingsData update(String name, String value) {
    return SettingsData(
      showRawSpeed: "dashboard.show-raw-speed" != name ? showRawSpeed : value,
    );
  }

  List<Object?> get props => [showRawSpeed];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("SettingsData(");
    buf.writeln("	showRawSpeed = $showRawSpeed");
    buf.writeln(")");

    return buf.toString();
  }
}
