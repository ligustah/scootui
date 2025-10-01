import 'settings.dart';

class StateClass {
  final String channel;
  final Duration interval;

  const StateClass(this.channel, this.interval);
}

class StateField {
  final String? name;
  final Duration? interval;
  final String? defaultValue;

  const StateField({this.name, this.interval, this.defaultValue});
}

class StateDiscriminator {
  const StateDiscriminator();
}

class SetField {
  final String setKey;
  final String elementType;
  final Duration? interval;

  const SetField({
    required this.setKey,
    this.elementType = "string",
    this.interval,
  });
}

abstract class Syncable<T> {
  SyncSettings get syncSettings;
  T update(String name, String value);
  T updateSet(String name, Set<dynamic> value);
}
