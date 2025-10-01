// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

abstract mixin class $NavigationData implements Syncable<NavigationData> {
  String get destination;
  get syncSettings => SyncSettings(
      "navigation",
      Duration(microseconds: 5000000),
      [
        SyncFieldSettings(
            name: "destination",
            variable: "destination",
            type: SyncFieldType.string,
            typeName: "String",
            defaultValue: null,
            interval: null),
      ],
      "null",
      []);

  @override
  NavigationData update(String name, String value) {
    return NavigationData(
      destination: "destination" != name ? destination : value,
    );
  }

  @override
  NavigationData updateSet(String name, Set<dynamic> value) {
    return NavigationData(
      destination: destination,
    );
  }

  List<Object?> get props => [destination];
  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln("NavigationData(");
    buf.writeln("	destination = $destination");
    buf.writeln(")");

    return buf.toString();
  }
}
