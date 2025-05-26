// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

abstract mixin class $DashboardData implements Syncable<DashboardData> {
  double? get brightness;
  int? get backlight;
  String? get theme;
  String? get mode;
  String? get debug;
  get syncSettings => SyncSettings(
      "dashboard",
      Duration(microseconds: 1000000),
      [
        SyncFieldSettings(
            name: "brightness",
            variable: "brightness",
            type: SyncFieldType.double,
            typeName: "double?",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "backlight",
            variable: "backlight",
            type: SyncFieldType.int,
            typeName: "int?",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "theme",
            variable: "theme",
            type: SyncFieldType.string,
            typeName: "String?",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "mode",
            variable: "mode",
            type: SyncFieldType.string,
            typeName: "String?",
            defaultValue: null,
            interval: null),
        SyncFieldSettings(
            name: "debug",
            variable: "debug",
            type: SyncFieldType.string,
            typeName: "String?",
            defaultValue: null,
            interval: null),
      ],
      "null");

  @override
  DashboardData update(String name, String value) {
    return DashboardData(
      brightness: "brightness" != name ? brightness : double.parse(value),
      backlight: "backlight" != name ? backlight : int.parse(value),
      theme: "theme" != name ? theme : value,
      mode: "mode" != name ? mode : value,
      debug: "debug" != name ? debug : value,
    );
  }

  List<Object?> get props => [brightness, backlight, theme, mode, debug];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("DashboardData(");
    buf.writeln("	brightness = $brightness");
    buf.writeln("	backlight = $backlight");
    buf.writeln("	theme = $theme");
    buf.writeln("	mode = $mode");
    buf.writeln("	debug = $debug");
    buf.writeln(")");

    return buf.toString();
  }
}
