String _reprDuration(Duration? dur) =>
    dur == null ? 'null' : "Duration(microseconds: ${dur.inMicroseconds})";

enum SyncFieldType {
  bool,
  num,
  double,
  int,
  string,
  enum_,
  set_int,
  set_string
}

class SyncSettings {
  final String channel;
  final Duration interval;
  final List<SyncFieldSettings> fields;
  final List<SyncSetFieldSettings> setFields;
  final String? discriminator;

  const SyncSettings(
      this.channel, this.interval, this.fields, this.discriminator,
      [this.setFields = const []]);

  @override
  String toString() {
    final buf = StringBuffer();

    final chan =
        discriminator == null ? '"$channel"' : '"$channel:\$$discriminator"';

    buf.write("SyncSettings(");
    buf.write('$chan,');
    buf.write(_reprDuration(interval));
    buf.write(",[");
    for (final field in fields) {
      buf.write(field.toString());
      buf.write(",");
    }
    buf.write('], "$discriminator", [');
    for (final field in setFields) {
      buf.write(field.toString());
      buf.write(",");
    }
    buf.write('])');

    return buf.toString();
  }
}

class SyncFieldSettings {
  // the name of the field in the original class
  final String name;

  // the name of the variable to sync against
  final String variable;
  final SyncFieldType type;
  final String typeName;
  final Duration? interval;
  final String? defaultValue;

  const SyncFieldSettings({
    required this.name,
    required this.variable,
    required this.type,
    required this.typeName,
    this.defaultValue,
    this.interval,
  });

  @override
  String toString() {
    final def = defaultValue == null ? 'null' : '"$defaultValue"';

    return 'SyncFieldSettings(name: "$name", variable: "$variable", type: $type, '
        'typeName: "$typeName", defaultValue: $def, interval: ${_reprDuration(interval)})';
  }
}

class SyncSetFieldSettings {
  final String name;
  final String setKey;
  final SyncFieldType elementType;
  final String typeName;
  final Duration? interval;

  const SyncSetFieldSettings({
    required this.name,
    required this.setKey,
    required this.elementType,
    required this.typeName,
    this.interval,
  });

  @override
  String toString() {
    return 'SyncSetFieldSettings(name: "$name", setKey: "$setKey", elementType: $elementType, '
        'typeName: "$typeName", interval: ${_reprDuration(interval)})';
  }
}
