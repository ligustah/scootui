String _reprDuration(Duration? dur) =>
    dur == null ? 'null' : "Duration(microseconds: ${dur.inMicroseconds})";

enum SyncFieldType { bool, num, double, int, string, enum_ }

class SyncSettings {
  final String channel;
  final Duration interval;
  final List<SyncFieldSettings> fields;
  final String? discriminator;

  const SyncSettings(this.channel, this.interval, this.fields, this.discriminator);

  @override
  String toString() {
    final buf = StringBuffer();

    final chan = discriminator == null ? '"$channel"' : '"$channel:\$$discriminator"';

    buf.write("SyncSettings(");
    buf.write('$chan,');
    buf.write(_reprDuration(interval));
    buf.write(",[");
    for (final field in fields) {
      buf.write(field.toString());
      buf.write(",");
    }
    buf.write('], "$discriminator")');

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
